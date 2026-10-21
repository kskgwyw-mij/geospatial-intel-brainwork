#!/usr/bin/env python3
"""End-to-end test on real data: DOP20 imagery + pretrained detector + real OSM.

For each test site:
  1. fetch a real Bavarian DOP20 crop (WMS, EPSG:25832, 0.2 m),
  2. rotate it by a random heading and crop it -> a metadata-free "photo"
     (only this script keeps the true position/scale/heading),
  3. detect anchors with a pretrained YOLO11-OBB (DOTA classes, no fine-tuning),
  4. locate the photo with tools/geo_match.py against a real Overpass export,
  5. score detection (vs. OSM objects inside the photo) and localisation (vs. truth).

Sites: `anchor` = near a random detectable OSM object (optimistic),
       `uniform` = uniformly inside the district polygons (honest coverage).

  venv/bin/python tools/real_geo_test.py --osm raw/2026-10-21-osm-anchors-alpine-edge.json \
      --bounds 'b_*.json' --sites 30 --mode uniform --out results/

Needs: numpy, Pillow, pyproj, ultralytics (torch). Imagery: Bayerische
Vermessungsverwaltung, CC BY 4.0. OSM: © OpenStreetMap contributors, ODbL.
"""
import argparse
import glob
import io
import json
import math
import random
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from pyproj import Transformer

sys.path.insert(0, str(Path(__file__).resolve().parent))
import geo_match  # noqa: E402

WMS = "https://geoservices.bayern.de/od/wms/dop/v1/dop20"
DOP_GSD = 0.2
# DOTA class -> canonical anchor class used for matching
DOTA_TO_CLASS = {"swimming pool": "pool", "tennis court": "tennis", "soccer ball field": "soccer",
                 "ground track field": "track", "storage tank": "tank", "basketball court": "basketball",
                 "baseball diamond": "baseball"}
COURTS = {"tennis", "basketball", "baseball"}  # often confused (e.g. clay tennis courts -> "baseball diamond")
TO_UTM = Transformer.from_crs(4326, 25832, always_xy=True)
TO_LL = Transformer.from_crs(25832, 4326, always_xy=True)


def canonical(tags):
    """Map OSM tags to the canonical anchor classes a DOTA detector can see (outdoor only)."""
    if tags.get("indoor") == "yes" or tags.get("location") in ("indoor", "underground") or tags.get("covered") == "yes":
        return None
    if tags.get("leisure") == "swimming_pool":
        return "pool"
    if tags.get("man_made") == "storage_tank":
        return "tank"
    if tags.get("leisure") == "track" or tags.get("sport") in ("athletics", "running") and tags.get("leisure") == "track":
        return "track"
    if tags.get("leisure") == "pitch":
        return {"tennis": "tennis", "soccer": "soccer", "basketball": "basketball", "baseball": "baseball"}.get(tags.get("sport"))
    return None


def merge(cls, merge_courts):
    return "court" if merge_courts and cls in COURTS else cls


def load_anchors(path, merge_courts=False):
    data = json.loads(Path(path).read_text())
    out = {}
    for el in data["elements"]:
        cls = merge(canonical(el.get("tags", {})), merge_courts)
        c = el.get("center") or ({"lat": el["lat"], "lon": el["lon"]} if "lat" in el else None)
        if cls and c:
            out.setdefault(cls, []).append((c["lon"], c["lat"], f"{el['type']}/{el['id']}"))
    return out


def load_segments(patterns):
    segs = []
    for pat in patterns:
        for f in glob.glob(pat):
            for rel in json.loads(Path(f).read_text()).get("elements", []):
                for m in rel.get("members", []):
                    if m.get("role") == "outer" and m.get("geometry"):
                        g = m["geometry"]
                        segs += [(g[i]["lon"], g[i]["lat"], g[i + 1]["lon"], g[i + 1]["lat"]) for i in range(len(g) - 1)]
    return np.array(segs)


def inside(segs, lon, lat):
    """Even-odd ray casting over all outer boundary segments (works without assembling rings)."""
    x1, y1, x2, y2 = segs.T
    crosses = ((y1 > lat) != (y2 > lat)) & (lon < x1 + (lat - y1) * (x2 - x1) / (y2 - y1 + 1e-15))
    return bool(np.count_nonzero(crosses) % 2)


def fetch_dop(e, n, side_m, url=WMS, layer="by_dop20c"):
    """Square DOP crop centred on (e, n) in EPSG:25832; `url`/`layer` select e.g. a historical flight year."""
    px = int(round(side_m / DOP_GSD))
    h = side_m / 2
    q = {"SERVICE": "WMS", "VERSION": "1.3.0", "REQUEST": "GetMap", "LAYERS": layer, "STYLES": "",
         "CRS": "EPSG:25832", "BBOX": f"{e - h},{n - h},{e + h},{n + h}", "WIDTH": px, "HEIGHT": px,
         "FORMAT": "image/jpeg"}
    for attempt in range(3):
        try:
            with urllib.request.urlopen(url + "?" + urllib.parse.urlencode(q), timeout=120) as r:
                return Image.open(io.BytesIO(r.read())).convert("RGB")
        except Exception:
            time.sleep(5 * (attempt + 1))
    raise RuntimeError("WMS fetch failed")


def detect(model, img, tile=1024, overlap=200, conf=0.25, merge_courts=False):
    W, H = img.size
    dets = []
    step = tile - overlap
    for y0 in range(0, max(H - overlap, 1), step):
        for x0 in range(0, max(W - overlap, 1), step):
            crop = img.crop((x0, y0, min(x0 + tile, W), min(y0 + tile, H)))
            r = model.predict(crop, imgsz=tile, conf=conf, verbose=False)[0]
            if r.obb is None:
                continue
            for (cx, cy, w, h, _), c, p in zip(r.obb.xywhr.tolist(), r.obb.cls.tolist(), r.obb.conf.tolist()):
                cls = merge(DOTA_TO_CLASS.get(model.names[int(c)]), merge_courts)
                if cls:
                    dets.append({"class": cls, "x": x0 + cx, "y": y0 + cy, "conf": p, "len_px": max(w, h)})
    dets.sort(key=lambda d: -d["conf"])
    kept = []
    for d in dets:  # merge duplicates from overlapping tiles
        if all(k["class"] != d["class"] or math.hypot(k["x"] - d["x"], k["y"] - d["y"]) > 15 for k in kept):
            kept.append(d)
    return kept


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--osm", required=True)
    ap.add_argument("--bounds", nargs="+", default=[], help="Overpass relation exports (out geom) for uniform sampling")
    ap.add_argument("--mode", choices=["anchor", "uniform"], default="anchor")
    ap.add_argument("--sites", type=int, default=20)
    ap.add_argument("--photo-m", default="500x375", help="photo footprint in metres (at 0.2 m/px)")
    ap.add_argument("--model", default="yolo11s-obb.pt")
    ap.add_argument("--conf", type=float, default=0.25)
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--no-merge-courts", action="store_true", help="keep tennis/basketball/baseball separate")
    ap.add_argument("--out", default="results")
    ap.add_argument("--save-images", type=int, default=3, help="annotated photos to save")
    args = ap.parse_args()

    from ultralytics import YOLO
    model = YOLO(args.model)
    rng = random.Random(args.seed)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    mc = not args.no_merge_courts
    anchors = load_anchors(args.osm, mc)
    allpts = [(lon, lat) for v in anchors.values() for lon, lat, _ in v]
    frame = geo_match.LocalFrame(np.mean([p[0] for p in allpts]), np.mean([p[1] for p in allpts]))
    Wm, Hm = (float(v) for v in args.photo_m.split("x"))
    W, H = int(Wm / DOP_GSD), int(Hm / DOP_GSD)
    segs = load_segments(args.bounds) if args.mode == "uniform" else None
    if args.mode == "uniform" and not len(segs):
        raise SystemExit("--mode uniform needs --bounds")
    print("anchors:", {k: len(v) for k, v in anchors.items()})

    log = (out / f"real_{args.mode}.jsonl").open("w")
    for s in range(args.sites):
        if args.mode == "anchor":
            cls = rng.choice(sorted(anchors))
            lon, lat, _ = rng.choice(anchors[cls])
            e, n = TO_UTM.transform(lon, lat)
            e, n = e + rng.uniform(-150, 150), n + rng.uniform(-150, 150)
        else:
            lon0, lat0, lon1, lat1 = segs[:, 0].min(), segs[:, 1].min(), segs[:, 0].max(), segs[:, 1].max()
            while True:
                lon, lat = rng.uniform(lon0, lon1), rng.uniform(lat0, lat1)
                if inside(segs, lon, lat):
                    break
            e, n = TO_UTM.transform(lon, lat)
        heading = rng.uniform(0, 360)
        t0 = time.time()
        big = fetch_dop(e, n, math.hypot(Wm, Hm) + 10)
        rot = big.rotate(heading, resample=Image.BICUBIC)
        cx, cy = rot.size[0] / 2, rot.size[1] / 2
        photo = rot.crop((int(cx - W / 2), int(cy - H / 2), int(cx - W / 2) + W, int(cy - H / 2) + H))
        dets = detect(model, photo, conf=args.conf, merge_courts=mc)

        # Ground truth: true similarity transform image -> map (same convention as geo_match)
        clon, clat = TO_LL.transform(e, n)
        t_true = complex(*frame.to_xy(clon, clat))
        a_true = DOP_GSD * complex(math.cos(math.radians(-heading)), math.sin(math.radians(-heading)))
        truth = []
        for c, items in anchors.items():
            for olon, olat, oid in items:
                zp = (complex(*frame.to_xy(olon, olat)) - t_true) / a_true
                if abs(zp.real) < W / 2 and abs(zp.imag) < H / 2:
                    truth.append({"class": c, "x": W / 2 + zp.real, "y": H / 2 - zp.imag, "id": oid})
        tp = sum(1 for d in dets if any(t["class"] == d["class"] and
                                          math.hypot(t["x"] - d["x"], t["y"] - d["y"]) * DOP_GSD < 10 for t in truth))
        found = sum(1 for t in truth if any(t["class"] == d["class"] and
                                             math.hypot(t["x"] - d["x"], t["y"] - d["y"]) * DOP_GSD < 10 for d in dets))

        res = geo_match.match(dets, (W, H), anchors, frame) if len(dets) >= 2 else None
        row = {"site": s, "mode": args.mode, "e": round(e, 1), "n": round(n, 1), "heading": round(heading, 2),
               "dets": len(dets), "det_tp": tp, "osm_in_photo": len(truth), "osm_found": found,
               "det_classes": sorted({d["class"] for d in dets}), "status": None, "err_m": None,
               "dets_px": [[d["class"], round(d["x"], 1), round(d["y"], 1), round(d["conf"], 3), round(d["len_px"], 1)]
                           for d in dets]}
        if res:
            ex, ny = TO_UTM.transform(*res["center_lonlat"])
            row.update({"status": res["status"], "inliers": res["inliers"], "margin": res["margin"],
                        "inlier_classes": res["inlier_classes"], "err_m": round(math.hypot(ex - e, ny - n), 2),
                        "gsd_err_pct": round(100 * abs(res["gsd_m"] / DOP_GSD - 1), 2),
                        "heading_err": round(abs((res["heading_deg"] - heading + 180) % 360 - 180), 2)})
        row["sec"] = round(time.time() - t0, 1)
        log.write(json.dumps(row) + "\n")
        log.flush()
        print(json.dumps(row))

        if s < args.save_images:
            draw = ImageDraw.Draw(photo)
            for t in truth:
                draw.ellipse([t["x"] - 25, t["y"] - 25, t["x"] + 25, t["y"] + 25], outline=(0, 160, 255), width=4)
            for d in dets:
                draw.rectangle([d["x"] - 20, d["y"] - 20, d["x"] + 20, d["y"] + 20], outline=(255, 40, 40), width=4)
                draw.text((d["x"] + 24, d["y"] - 20), f"{d['class']} {d['conf']:.2f}", fill=(255, 255, 0))
            photo.resize((W // 2, H // 2)).save(out / f"site_{args.mode}_{s:02d}.jpg", quality=85)
    log.close()


if __name__ == "__main__":
    main()

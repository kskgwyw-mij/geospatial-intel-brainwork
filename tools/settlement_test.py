#!/usr/bin/env python3
"""Can inhabited (built-up) areas be detected stably in DOP20? Tile-level test on real data.

collect: samples 100 m cells inside district boundaries (uniform + building-centred), labels each
         cell from OSM building centroids, fetches the cell from the current DOP20 and from an older
         flight year, and extracts (a) hand-crafted colour/texture features and (b) embeddings of a
         pretrained aerial backbone (YOLO11-OBB trained on DOTA). Writes one .npz.
analyse: spatial-block CV inside the first district, transfer to the other district, and transfer
         from the current flight to the older one (season, sun, vegetation, real changes).

  venv/bin/python tools/settlement_test.py collect --district MB buildings_mb.json b_2168231.json \
      --district GAP buildings_gap.json b_62726.json --cells 300 --centred 100 --out cells.npz
  venv/bin/python tools/settlement_test.py analyse cells.npz

Needs: numpy, Pillow, pyproj, ultralytics, scikit-learn. Imagery: Bayerische Vermessungsverwaltung,
CC BY 4.0. OSM: © OpenStreetMap contributors, ODbL.
"""
import argparse
import json
import random
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from overpass_settlements import is_dwelling  # noqa: E402
from real_geo_test import TO_UTM, fetch_dop, inside, load_segments  # noqa: E402

HIST_WMS = "https://geoservices.bayern.de/od/wms/histdop/v1/histdop"


def load_buildings(path):
    """Building centroids in EPSG:25832 plus a dwelling flag (same rule as overpass_settlements.py)."""
    els = [el for el in json.loads(Path(path).read_text())["elements"] if "center" in el]
    pts = [(*TO_UTM.transform(el["center"]["lon"], el["center"]["lat"]), is_dwelling(el.get("tags", {}))) for el in els]
    return np.array(pts, dtype=float)


def count(bld, e, n, half):
    m = (np.abs(bld[:, 0] - e) < half) & (np.abs(bld[:, 1] - n) < half)
    return int(m.sum()), int(bld[m, 2].sum())


def handcrafted(img):
    """Colour and texture statistics (see wiki: spectral-texture-features)."""
    a = np.asarray(img, dtype=np.float32) / 255.0
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    gray = a.mean(axis=2)
    mx, mn = a.max(axis=2), a.min(axis=2)
    sat = (mx - mn) / (mx + 1e-6)
    exg = 2 * g - r - b
    gx, gy = np.gradient(gray)
    grad = np.hypot(gx, gy)
    h, w = gray.shape
    blocks = gray[: h - h % 10, : w - w % 10].reshape(h // 10, 10, w // 10, 10).std(axis=(1, 3))
    hist = np.histogram(gray, bins=8, range=(0, 1))[0] / gray.size
    return np.concatenate([
        a.reshape(-1, 3).mean(0), a.reshape(-1, 3).std(0),
        [exg.mean(), (exg > 0.05).mean(), sat.mean(), (sat < 0.12).mean(),        # vegetation, grey surfaces
         ((r > g + 0.05) & (r > b + 0.05)).mean(),                                # reddish roofs
         grad.mean(), (grad > 0.08).mean(), blocks.mean(), blocks.std()],         # edges, texture
        hist])


def collect(args):
    from ultralytics import YOLO
    model = YOLO(args.model)
    rng = random.Random(args.seed)
    rows, feats_now, feats_old, emb_now, emb_old = [], [], [], [], []
    for name, bpath, bounds in args.district:
        segs = load_segments([bounds])
        bld = load_buildings(bpath)
        lon0, lat0, lon1, lat1 = segs[:, 0].min(), segs[:, 1].min(), segs[:, 0].max(), segs[:, 1].max()
        cells = []
        while len(cells) < args.cells:
            lon, lat = rng.uniform(lon0, lon1), rng.uniform(lat0, lat1)
            if inside(segs, lon, lat):
                cells.append((*TO_UTM.transform(lon, lat), "uniform"))
        for _ in range(args.centred):
            e, n, _ = bld[rng.randrange(len(bld))]
            cells.append((e + rng.uniform(-40, 40), n + rng.uniform(-40, 40), "centred"))
        half = args.cell_m / 2

        def work(c):
            e, n, kind = c
            now = fetch_dop(e, n, args.cell_m)
            old = fetch_dop(e, n, args.cell_m, url=HIST_WMS, layer=args.hist_layer)
            return c, now, old

        with ThreadPoolExecutor(args.threads) as ex:
            for i, ((e, n, kind), now, old) in enumerate(ex.map(work, cells)):
                nb, ndw = count(bld, e, n, half)
                nb150 = int(np.count_nonzero(np.hypot(bld[:, 0] - e, bld[:, 1] - n) < 150))
                old_ok = float(np.asarray(old).std()) > 1.0          # blank (white) = not flown that year
                rows.append({"district": name, "e": round(e, 1), "n": round(n, 1), "kind": kind,
                             "nb": nb, "ndw": ndw, "nb150": nb150, "old_ok": old_ok})
                feats_now.append(handcrafted(now))
                feats_old.append(handcrafted(old))
                emb_now.append(model.embed(now, imgsz=512, verbose=False)[0].cpu().numpy())
                emb_old.append(model.embed(old, imgsz=512, verbose=False)[0].cpu().numpy())
                if i < args.save_images:
                    now.save(Path(args.out).with_name(f"cell_{name}_{i:02d}_nb{nb}.jpg"), quality=85)
                if i % 50 == 0:
                    print(name, i, len(cells), rows[-1], flush=True)
    np.savez_compressed(args.out, rows=json.dumps(rows), hc_now=np.array(feats_now), hc_old=np.array(feats_old),
                        emb_now=np.array(emb_now), emb_old=np.array(emb_old))
    print("wrote", args.out, len(rows), "cells")


def analyse(args):
    from sklearn.linear_model import LogisticRegression
    from sklearn.metrics import f1_score, precision_score, recall_score, roc_auc_score
    from sklearn.model_selection import GroupKFold
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler

    z = np.load(args.npz)
    rows = json.loads(str(z["rows"]))
    for name, path in args.buildings or []:  # (re)label from Overpass exports, e.g. for files made before `ndw`
        bld = load_buildings(path)
        for r in rows:
            if r["district"] == name:
                r["nb"], r["ndw"] = count(bld, r["e"], r["n"], 50)
    dist = np.array([r["district"] for r in rows])
    uni = np.array([r["kind"] == "uniform" for r in rows])
    old_ok = np.array([r["old_ok"] for r in rows])
    blocks = np.array([f"{r['district']}_{int(r['e'] // 2000)}_{int(r['n'] // 2000)}" for r in rows])
    targets = {"built (>=1 building in 1 ha)": np.array([r["nb"] >= 1 for r in rows]),
               "settlement (>=5 buildings in 1 ha)": np.array([r["nb"] >= 5 for r in rows])}
    if all("ndw" in r for r in rows):  # Overpass dwelling rule: excludes barns, huts, garages
        targets["inhabited (>=1 dwelling in 1 ha)"] = np.array([r["ndw"] >= 1 for r in rows])
        targets["settlement (>=3 dwellings in 1 ha)"] = np.array([r["ndw"] >= 3 for r in rows])
    featsets = {"colour/texture": ("hc_now", "hc_old"), "DOTA embedding": ("emb_now", "emb_old")}
    first, second = dist[0], [d for d in dict.fromkeys(dist) if d != dist[0]][0]
    out = {"cells": {d: int((dist == d).sum()) for d in dict.fromkeys(dist)},
           "uniform_cells": {d: int(((dist == d) & uni).sum()) for d in dict.fromkeys(dist)}, "results": []}

    def model():
        return make_pipeline(StandardScaler(), LogisticRegression(C=0.1, max_iter=3000, class_weight="balanced"))

    def score(y, p, mask):
        y, p = y[mask], p[mask]
        if len(set(y)) < 2:
            return None
        yh = p >= 0.5
        return {"n": int(mask.sum()), "pos": int(y.sum()), "auc": round(roc_auc_score(y, p), 3),
                "f1": round(f1_score(y, yh), 3), "precision": round(precision_score(y, yh, zero_division=0), 3),
                "recall": round(recall_score(y, yh), 3)}

    for tname, y in targets.items():
        for fname, (now_k, old_k) in featsets.items():
            Xn, Xo = z[now_k], z[old_k]
            a = dist == first
            p_cv = np.zeros(len(y))
            for tr, te in GroupKFold(5).split(Xn[a], y[a], blocks[a]):
                idx = np.where(a)[0]
                p_cv[idx[te]] = model().fit(Xn[idx[tr]], y[idx[tr]]).predict_proba(Xn[idx[te]])[:, 1]
            m = model().fit(Xn[a], y[a])
            p_b, p_old = m.predict_proba(Xn)[:, 1], m.predict_proba(Xo)[:, 1]
            b = dist == second
            res = {"target": tname, "features": fname,
                   f"{first} spatial CV (all)": score(y, p_cv, a),
                   f"{first} spatial CV (uniform only)": score(y, p_cv, a & uni),
                   f"{first}->{second} (all)": score(y, p_b, b),
                   f"{first}->{second} (uniform only)": score(y, p_b, b & uni),
                   f"{first}->{second}, {args.old_name} flight": score(y, p_old, b & old_ok),
                   f"{first} model on {first} {args.old_name} flight": score(y, p_old, a & old_ok),
                   f"same-cell agreement 2024 vs {args.old_name} ({second})":
                       round(float(((p_b >= 0.5) == (p_old >= 0.5))[b & old_ok].mean()), 3)}
            out["results"].append(res)
    print(json.dumps(out, indent=1))
    if args.json:
        Path(args.json).write_text(json.dumps(out, indent=1))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("collect")
    c.add_argument("--district", nargs=3, action="append", required=True, metavar=("NAME", "BUILDINGS", "BOUNDS"),
                   help="name, Overpass building export (out center), Overpass boundary relation (out geom)")
    c.add_argument("--cells", type=int, default=300, help="uniform cells per district")
    c.add_argument("--centred", type=int, default=100, help="extra cells centred near a random building")
    c.add_argument("--cell-m", type=float, default=100)
    c.add_argument("--hist-layer", default="by_dop_2018_h")
    c.add_argument("--model", default="yolo11s-obb.pt")
    c.add_argument("--threads", type=int, default=3)
    c.add_argument("--seed", type=int, default=11)
    c.add_argument("--save-images", type=int, default=0)
    c.add_argument("--out", default="cells.npz")
    a = sub.add_parser("analyse")
    a.add_argument("npz")
    a.add_argument("--old-name", default="2018")
    a.add_argument("--buildings", nargs=2, action="append", metavar=("NAME", "FILE"),
                   help="recount labels from an Overpass building export (cell size 100 m)")
    a.add_argument("--json")
    args = ap.parse_args()
    collect(args) if args.cmd == "collect" else analyse(args)


if __name__ == "__main__":
    main()

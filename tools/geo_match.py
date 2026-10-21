#!/usr/bin/env python3
"""Locate a metadata-free nadir photo by matching detected objects to OSM.

Given detected objects in pixel coordinates (class + position) and an OSM export of
the search region, find the 2D similarity transform (position, scale = GSD, rotation
= heading) that maps the photo onto the map. Hypothesise-and-verify in the spirit of
RANSAC (wiki/concepts/ransac.md): every pair of detections plus every OSM pair of the
same classes at a compatible distance proposes a transform; each proposal is scored
by how many other detections land on an OSM object of the same class.

Detections JSON:
  {"image_size": [W, H],
   "objects": [{"class": "sport=tennis", "x": 1210, "y": 830, "length_px": 128}, ...]}
  `length_px` is optional; for classes with a standard size (KNOWN_LENGTH_M) it
  narrows the scale (metric anchors, wiki/analyses/osm-fingerprint-geolocalization.md).

OSM input: Overpass Turbo GeoJSON export or Overpass JSON (`out geom` / `out center`).

  python3 tools/geo_match.py detections.json region.geojson --out match.json

Needs numpy only.
"""
import argparse
import cmath
import json
import math
import sys
from collections import defaultdict
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from osm_overlay import load_features  # noqa: E402

R = 6378137.0
DEFAULT_KEYS = ["sport", "leisure", "man_made", "power", "aerialway"]
KNOWN_LENGTH_M = {"sport=tennis": 23.77, "sport=beachvolleyball": 16.0}


class LocalFrame:
    """Equirectangular metres around a reference point; fine for a regional search."""

    def __init__(self, lon0, lat0):
        self.lon0, self.lat0 = lon0, lat0
        self.kx = math.radians(1) * R * math.cos(math.radians(lat0))
        self.ky = math.radians(1) * R

    def to_xy(self, lon, lat):
        return (lon - self.lon0) * self.kx, (lat - self.lat0) * self.ky

    def to_lonlat(self, x, y):
        return self.lon0 + x / self.kx, self.lat0 + y / self.ky


class GridIndex:
    def __init__(self, pts, cell):
        self.pts, self.cell = pts, cell
        self.cells = defaultdict(list)
        for i, z in enumerate(pts):
            self.cells[(math.floor(z.real / cell), math.floor(z.imag / cell))].append(i)

    def within(self, z, r):
        cx, cy, n = math.floor(z.real / self.cell), math.floor(z.imag / self.cell), math.ceil(r / self.cell)
        for i in range(cx - n, cx + n + 1):
            for j in range(cy - n, cy + n + 1):
                for k in self.cells.get((i, j), ()):
                    if abs(self.pts[k] - z) <= r:
                        yield k

    def nearest(self, z, r):
        best, bd = None, r
        for k in self.within(z, r):
            d = abs(self.pts[k] - z)
            if d <= bd:
                best, bd = k, d
        return best, bd


def class_of(tags, keys):
    for k in keys:
        if k in tags:
            return f"{k}={tags[k]}"
    return None


def load_osm(path, keys):
    """Return {class: [(lon, lat, osm_id)]} using ring centroids."""
    out = defaultdict(list)
    for tags, fid, rings in load_features(path):
        cls = class_of(tags, keys)
        if cls is None or not rings or not rings[0]:
            continue
        ring = rings[0][:-1] if len(rings[0]) > 2 and rings[0][0] == rings[0][-1] else rings[0]
        out[cls].append((sum(p[0] for p in ring) / len(ring), sum(p[1] for p in ring) / len(ring), fid))
    return out


def fit_similarity(zp, zm):
    """Least-squares a, t with zm ≈ a·zp + t (a complex: scale·e^{iθ})."""
    zp, zm = np.asarray(zp), np.asarray(zm)
    cp, cm = zp.mean(), zm.mean()
    a = np.sum(np.conj(zp - cp) * (zm - cm)) / np.sum(np.abs(zp - cp) ** 2)
    return complex(a), complex(cm - a * cp)


def match(dets, size, osm, frame, gsd_range=(0.05, 0.6), tol_m=4.0, max_pairs=20, min_px=40):
    W, H = size
    classes = [d["class"] for d in dets]
    zp = [complex(d["x"] - W / 2, -(d["y"] - H / 2)) for d in dets]  # image frame, y up
    idx, pts = {}, {}
    for cls, items in osm.items():
        pts[cls] = [complex(*frame.to_xy(lon, lat)) for lon, lat, _ in items]
        idx[cls] = GridIndex(pts[cls], cell=100.0)

    # Metric anchors narrow the scale range.
    est = [KNOWN_LENGTH_M[d["class"]] / d["length_px"] for d in dets
           if d.get("length_px") and d["class"] in KNOWN_LENGTH_M]
    gmin, gmax = gsd_range
    if est:
        g = float(np.median(est))
        gmin, gmax = max(gmin, 0.85 * g), min(gmax, 1.15 * g)

    usable = [i for i, c in enumerate(classes) if c in idx and idx[c].pts]
    rarity = {c: len(pts[c]) for c in idx}
    pairs = [(i, j) for a, i in enumerate(usable) for j in usable[a + 1:] if abs(zp[j] - zp[i]) >= min_px]
    pairs.sort(key=lambda p: rarity[classes[p[0]]] * rarity[classes[p[1]]])
    pairs = pairs[:max_pairs]

    by_rarity = sorted(usable, key=lambda k: rarity[classes[k]])
    hyps = []
    for i, j in pairs:
        # Cheap pre-check: a true hypothesis should also hit one of a few other rare detections.
        verifiers = [k for k in by_rarity if k not in (i, j)][:3]
        dp = zp[j] - zp[i]
        dmin, dmax = abs(dp) * gmin, abs(dp) * gmax
        ca, cb = classes[i], classes[j]
        for ia, ma in enumerate(pts[ca]):
            for ib in idx[cb].within(ma, dmax):
                mb = pts[cb][ib]
                if (ca == cb and ib == ia) or abs(mb - ma) < dmin:
                    continue
                a = (mb - ma) / dp
                t = ma - a * zp[i]
                if verifiers:
                    tol = max(tol_m, 3 * abs(a))
                    if not any(idx[classes[k]].nearest(a * zp[k] + t, tol)[0] is not None for k in verifiers):
                        continue
                hyps.append((a, t))

    def score(a, t):
        tol = max(tol_m, 3 * abs(a))
        inl, res = [], 0.0
        for k, c in enumerate(classes):
            if c not in idx:
                continue
            nk, d = idx[c].nearest(a * zp[k] + t, tol)
            if nk is not None:
                inl.append((k, pts[c][nk]))
                res += d * d
        return inl, res

    results = []
    for a, t in hyps:
        inl, res = score(a, t)
        if len(inl) >= 2:
            results.append((len(inl), -res, a, t, inl))
    if not results:
        return None
    results.sort(key=lambda r: (r[0], r[1]), reverse=True)

    def refine(r):
        a, t, inl = r[2], r[3], r[4]
        for _ in range(2):
            if len(inl) >= 3:
                a, t = fit_similarity([zp[k] for k, _ in inl], [m for _, m in inl])
            inl, _ = score(a, t)
        rms = math.sqrt(np.mean([abs(a * zp[k] + t - m) ** 2 for k, m in inl])) if inl else float("nan")
        return a, t, inl, rms

    a, t, inl, rms = refine(results[0])
    runner = next((r for r in results[1:] if abs(r[3] - t) > 200), None)

    def describe(a, t, n_in, rms_m):
        lon, lat = frame.to_lonlat(t.real, t.imag)
        corners = []
        for u, v in [(-W / 2, H / 2), (W / 2, H / 2), (W / 2, -H / 2), (-W / 2, -H / 2)]:
            z = a * complex(u, v) + t
            corners.append([round(c, 7) for c in frame.to_lonlat(z.real, z.imag)])
        return {"center_lonlat": [round(lon, 7), round(lat, 7)], "gsd_m": round(abs(a), 4),
                "heading_deg": round((-math.degrees(cmath.phase(a))) % 360, 2),
                "inliers": n_in, "detections": len(dets), "rms_m": round(rms_m, 2),
                "corners_lonlat_tl_tr_br_bl": corners}

    best = describe(a, t, len(inl), rms)
    best["hypotheses"] = len(hyps)
    best["gsd_range_used"] = [round(gmin, 4), round(gmax, 4)]
    best["inlier_ids"] = [k for k, _ in inl]
    if runner:
        best["runner_up"] = describe(runner[2], runner[3], runner[0], float("nan"))
        best["margin"] = len(inl) - runner[0]
    else:
        best["margin"] = len(inl)
    # Two points always fit some similarity transform, so 2 inliers carry no evidence.
    if len(inl) >= 4 and best["margin"] >= 2:
        best["status"] = "confident"
    elif len(inl) >= 3 and best["margin"] >= 1:
        best["status"] = "probable"
    else:
        best["status"] = "ambiguous"
    return best


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("detections")
    ap.add_argument("osm")
    ap.add_argument("--keys", default=",".join(DEFAULT_KEYS))
    ap.add_argument("--gsd-range", default="0.05,0.6", help="min,max metres per pixel")
    ap.add_argument("--tol", type=float, default=4.0, help="inlier tolerance in metres")
    ap.add_argument("--max-pairs", type=int, default=20)
    ap.add_argument("--out")
    args = ap.parse_args()

    det = json.loads(Path(args.detections).read_text())
    osm = load_osm(args.osm, [k.strip() for k in args.keys.split(",") if k.strip()])
    allpts = [(lon, lat) for items in osm.values() for lon, lat, _ in items]
    if not allpts:
        raise SystemExit("No OSM objects of the selected keys in the export")
    frame = LocalFrame(sum(p[0] for p in allpts) / len(allpts), sum(p[1] for p in allpts) / len(allpts))
    res = match(det["objects"], det["image_size"], osm, frame,
                tuple(float(v) for v in args.gsd_range.split(",")), args.tol, args.max_pairs)
    if res is None:
        raise SystemExit("No consistent match found")
    text = json.dumps(res, indent=1)
    if args.out:
        Path(args.out).write_text(text)
    print(text)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Evaluate tools/geo_match.py on simulated metadata-free nadir photos.

Builds a synthetic search region (objects clustered around villages), takes random
"photos" (unknown position, GSD and heading), simulates an imperfect detector (pixel
jitter, misses, false alarms) and imperfect OSM (missing objects), then checks whether
the matcher recovers position, scale and heading. With --osm, real Overpass exports
replace the synthetic region (use for counts from wiki/entities/oberbayern-sued.md).

  python3 tools/sim_geo_match.py --trials 50
  python3 tools/sim_geo_match.py --osm region.geojson --trials 50

Numbers produced with synthetic densities are illustrative only.
"""
import argparse
import cmath
import math
import random
import statistics
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from geo_match import DEFAULT_KEYS, KNOWN_LENGTH_M, LocalFrame, load_osm, match  # noqa: E402

# Objects per village cluster (Poisson means), loosely Alpine-edge-like; hypothetical.
CLUSTER_MIX = {"leisure=swimming_pool": 6.0, "sport=tennis": 1.2, "man_made=storage_tank": 0.6,
               "sport=soccer": 0.5, "man_made=silo": 0.8, "power=tower": 1.5}


def poisson(lam, rng):
    L, k, p = math.exp(-lam), 0, 1.0
    while True:
        p *= rng.random()
        if p <= L:
            return k
        k += 1


def synth_region(rng, size_km, villages):
    objs = []
    for _ in range(villages):
        cx, cy = rng.uniform(0, size_km * 1000), rng.uniform(0, size_km * 1000)
        spread = rng.uniform(150, 600)
        for cls, lam in CLUSTER_MIX.items():
            for _ in range(poisson(lam, rng)):
                objs.append((cls, complex(rng.gauss(cx, spread), rng.gauss(cy, spread))))
    return objs


def take_photo(rng, objs, W, H, recall, fp, jitter, gsd_rng):
    centre = rng.choice(objs)[1] + complex(rng.gauss(0, 100), rng.gauss(0, 100))
    gsd, heading = rng.uniform(*gsd_rng), rng.uniform(0, 360)
    a = gsd * cmath.exp(-1j * math.radians(heading))  # image frame -> map
    dets = []
    for cls, z in objs:
        zp = (z - centre) / a
        if abs(zp.real) < W / 2 and abs(zp.imag) < H / 2 and rng.random() < recall:
            d = {"class": cls, "x": W / 2 + zp.real + rng.gauss(0, jitter),
                 "y": H / 2 - zp.imag + rng.gauss(0, jitter)}
            if cls in KNOWN_LENGTH_M:
                d["length_px"] = KNOWN_LENGTH_M[cls] / gsd * rng.gauss(1, 0.03)
            dets.append(d)
    for _ in range(fp):
        dets.append({"class": rng.choice(list(CLUSTER_MIX)), "x": rng.uniform(0, W), "y": rng.uniform(0, H)})
    return dets, centre, gsd, heading


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--osm", help="real OSM export instead of the synthetic region")
    ap.add_argument("--trials", type=int, default=30)
    ap.add_argument("--size-km", type=float, default=30)
    ap.add_argument("--villages", type=int, default=120)
    ap.add_argument("--image", default="4000x3000")
    ap.add_argument("--gsd", default="0.08,0.25", help="true GSD range of simulated photos")
    ap.add_argument("--recall", type=float, default=0.85)
    ap.add_argument("--false-pos", type=int, default=2)
    ap.add_argument("--osm-missing", type=float, default=0.1, help="share of real objects absent from OSM")
    ap.add_argument("--osm-noise", type=float, default=0.0, help="OSM positional error, std dev in metres per axis")
    ap.add_argument("--jitter", type=float, default=3.0, help="detector position noise in px")
    ap.add_argument("--seed", type=int, default=1)
    args = ap.parse_args()
    rng = random.Random(args.seed)
    W, H = (int(v) for v in args.image.split("x"))
    gsd_rng = tuple(float(v) for v in args.gsd.split(","))

    if args.osm:
        osm_real = load_osm(args.osm, DEFAULT_KEYS)
        pts = [(lon, lat) for items in osm_real.values() for lon, lat, _ in items]
        frame = LocalFrame(sum(p[0] for p in pts) / len(pts), sum(p[1] for p in pts) / len(pts))
        world = [(c, complex(*frame.to_xy(lon, lat))) for c, items in osm_real.items() for lon, lat, _ in items]
    else:
        frame = LocalFrame(11.8, 47.7)  # arbitrary anchor in the Alpine-edge districts
        world = synth_region(rng, args.size_km, args.villages)
    mapped = [(c, z + complex(rng.gauss(0, args.osm_noise), rng.gauss(0, args.osm_noise)))
              for c, z in world if rng.random() >= args.osm_missing]  # what OSM knows (incomplete, shifted)
    osm = {}
    for c, z in mapped:
        lon, lat = frame.to_lonlat(z.real, z.imag)
        osm.setdefault(c, []).append((lon, lat, None))
    area = args.size_km ** 2 if not args.osm else None
    print(f"world objects {len(world)}, in OSM {len(mapped)}" + (f", region {area:.0f} km²" if area else ""))

    rows = []
    for t in range(args.trials):
        dets, centre, gsd, heading = take_photo(rng, world, W, H, args.recall, args.false_pos, args.jitter, gsd_rng)
        res = match(dets, (W, H), osm, frame)
        if res is None:
            rows.append({"ok": False, "n": len(dets)})
            continue
        cx, cy = frame.to_xy(*res["center_lonlat"])
        err = abs(complex(cx, cy) - centre)
        dh = abs((res["heading_deg"] - heading + 180) % 360 - 180)
        rows.append({"ok": err < 10, "n": len(dets), "err_m": err, "gsd_err": abs(res["gsd_m"] / gsd - 1),
                     "head_err": dh, "inl": res["inliers"], "margin": res["margin"], "status": res["status"]})

    ok = [r for r in rows if r["ok"]]
    print(f"trials {len(rows)}: located within 10 m: {len(ok)} ({100 * len(ok) / len(rows):.0f} %)")
    if ok:
        print(f"  median position error {statistics.median(r['err_m'] for r in ok):.2f} m, "
              f"GSD error {100 * statistics.median(r['gsd_err'] for r in ok):.2f} %, "
              f"heading error {statistics.median(r['head_err'] for r in ok):.2f}°")
    for st in ("confident", "probable", "ambiguous"):
        sub = [r for r in rows if r.get("status") == st]
        if sub:
            print(f"  status {st:9s}: {len(sub):3d} photos, correct {sum(r['ok'] for r in sub)}")
    print("  by number of detections (n: located/total):")
    for lo, hi in [(0, 2), (3, 4), (5, 7), (8, 1000)]:
        sub = [r for r in rows if lo <= r["n"] <= hi]
        if sub:
            print(f"    {lo}-{hi if hi < 1000 else '+'}: {sum(r['ok'] for r in sub)}/{len(sub)}")


if __name__ == "__main__":
    main()

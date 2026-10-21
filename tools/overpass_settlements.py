#!/usr/bin/env python3
"""Inhabited areas from the Overpass API, as a 100 m grid (the map side of settlement detection).

Queries (or reads a saved export of) all buildings in an area plus `place=*` nodes, splits buildings into
dwellings (residential building types, or anything with a house number that is not a barn/hut/garage type)
and non-dwellings, counts them per grid cell in EPSG:25832, and writes GeoJSON:

  - one polygon per non-empty cell with counts and a class
      settlement  >= 3 dwellings      (default --settlement-min)
      inhabited   >= 1 dwelling
      built_only  buildings, but no dwelling (barns, huts, sheds, garages ...)
  - one point per place node (city ... isolated_dwelling) as a named reference.

The same rule labels the training cells in tools/settlement_test.py, so detector output and Overpass
layer use one definition of "inhabited".

  python3 tools/overpass_settlements.py --area-relation 62726 --out gap_settlements.geojson
  python3 tools/overpass_settlements.py --bbox 47.70,11.70,47.80,11.90 --out test.geojson
  python3 tools/overpass_settlements.py --osm buildings_gap.json --out gap.geojson   # saved export

Needs: pyproj. Data: © OpenStreetMap contributors, ODbL.
"""
import argparse
import json
import math
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path

from pyproj import Transformer

TO_UTM = Transformer.from_crs(4326, 25832, always_xy=True)
TO_LL = Transformer.from_crs(25832, 4326, always_xy=True)
DWELLING_TYPES = {"house", "detached", "residential", "apartments", "semidetached_house", "terrace", "farm",
                  "bungalow", "hotel", "dormitory"}
NON_DWELLING_TYPES = {"barn", "shed", "garage", "garages", "carport", "hut", "cabin", "farm_auxiliary", "roof",
                      "service", "chapel", "stable", "cowshed", "hangar", "greenhouse", "transformer_tower", "ruins"}
PLACES = "city|town|village|hamlet|isolated_dwelling|suburb|neighbourhood"


def is_dwelling(tags):
    """Residential building type, or an address on a building that is not an outbuilding type."""
    b = tags.get("building")
    return b in DWELLING_TYPES or ("addr:housenumber" in tags and b not in NON_DWELLING_TYPES)


def query(area_relation=None, bbox=None):
    sel = f"(area.r)" if area_relation else f"({bbox})"
    head = f"area(id:{3600000000 + int(area_relation)})->.r;\n" if area_relation else ""
    return (f"[out:json][timeout:600];\n{head}"
            f"(way[\"building\"]{sel};relation[\"building\"]{sel};);\nout center tags;\n"
            f"node[\"place\"~\"^({PLACES})$\"]{sel};\nout;\n")


def fetch(q, endpoint, tries=4):
    """POST the query; Overpass answers 429/504 when busy, so retry with backoff."""
    data = urllib.parse.urlencode({"data": q}).encode()
    for attempt in range(tries):
        try:
            with urllib.request.urlopen(endpoint, data=data, timeout=900) as r:
                return json.loads(r.read())
        except urllib.error.HTTPError as e:
            if e.code not in (429, 502, 503, 504) or attempt == tries - 1:
                raise
            time.sleep(30 * (attempt + 1))


def grid(elements, cell_m, settlement_min):
    cells = defaultdict(lambda: [0, 0])  # (buildings, dwellings)
    places = []
    for el in elements:
        tags = el.get("tags", {})
        if "building" in tags and "center" in el:
            x, y = TO_UTM.transform(el["center"]["lon"], el["center"]["lat"])
            c = cells[(math.floor(x / cell_m), math.floor(y / cell_m))]
            c[0] += 1
            c[1] += is_dwelling(tags)
        elif el["type"] == "node" and "place" in tags:
            places.append(el)
    feats = []
    for (i, j), (nb, nd) in sorted(cells.items()):
        cls = "settlement" if nd >= settlement_min else "inhabited" if nd else "built_only"
        ring = [list(TO_LL.transform(x * cell_m, y * cell_m)) for x, y in ((i, j), (i + 1, j), (i + 1, j + 1), (i, j + 1), (i, j))]
        feats.append({"type": "Feature", "geometry": {"type": "Polygon", "coordinates": [ring]},
                      "properties": {"class": cls, "buildings": nb, "dwellings": nd, "cell_e": i * cell_m, "cell_n": j * cell_m}})
    for p in places:
        feats.append({"type": "Feature", "geometry": {"type": "Point", "coordinates": [p["lon"], p["lat"]]},
                      "properties": {"place": p["tags"]["place"], "name": p["tags"].get("name"), "osm_id": p["id"]}})
    return feats


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    src = ap.add_mutually_exclusive_group(required=True)
    src.add_argument("--area-relation", type=int, help="OSM relation id of the area, e.g. 62726 = Lkr. Garmisch-Partenkirchen")
    src.add_argument("--bbox", help="south,west,north,east")
    src.add_argument("--osm", help="saved Overpass JSON export (buildings with `out center tags`)")
    ap.add_argument("--endpoint", default="https://overpass-api.de/api/interpreter")
    ap.add_argument("--cell-m", type=float, default=100)
    ap.add_argument("--settlement-min", type=int, default=3, help="dwellings per cell for class 'settlement'")
    ap.add_argument("--print-query", action="store_true")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    if args.osm:
        elements = json.loads(Path(args.osm).read_text())["elements"]
    else:
        q = query(args.area_relation, args.bbox)
        if args.print_query:
            print(q)
        elements = fetch(q, args.endpoint)["elements"]
    feats = grid(elements, args.cell_m, args.settlement_min)
    Path(args.out).write_text(json.dumps({"type": "FeatureCollection", "features": feats}))
    counts = defaultdict(int)
    for f in feats:
        counts[f["properties"].get("class") or "place:" + f["properties"]["place"]] += 1
    print(json.dumps(dict(sorted(counts.items())), indent=1))


if __name__ == "__main__":
    main()

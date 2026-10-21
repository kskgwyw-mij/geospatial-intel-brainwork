#!/usr/bin/env python3
"""Project Overpass / OSM objects onto a nadir image and emit pixel labels.

Locates where known OSM objects ("Overpass Turbo markers") fall inside a
georeferenced, north-up nadir image, draws them, and writes per-object pixel
boxes/polygons usable as training labels (see wiki/concepts/osm-weak-labels.md).
This is label projection, not visual detection: objects missing from OSM are
not found, and OSM-vs-image offsets are carried over.

Georeference (pick one):
  --bbox W,S,E,N     lon/lat bounds of a Web-Mercator image (map screenshot, XYZ tiles)
  --worldfile F      .pgw/.jgw/.tfw world file, with --epsg (4326 and 3857 built in;
                     others such as 31287 or 32632 need `pip install pyproj`)
  (none)             GeoTIFF: read tie point + pixel scale + EPSG from its tags

OSM input: Overpass Turbo "Export -> GeoJSON", or raw Overpass JSON from `out geom;`.

  python3 tools/osm_overlay.py ortho.png export.geojson --bbox 12.16,47.57,12.18,47.58
  python3 tools/osm_overlay.py ortho.tif export.geojson --yolo labels/

Needs numpy and Pillow; pyproj only for national CRSs.
"""
import argparse
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

R = 6378137.0
PRIMARY_KEYS = ["building", "leisure", "man_made", "power", "amenity", "landuse",
                "natural", "highway", "railway", "waterway", "aeroway", "sport"]
PALETTE = [(230, 25, 75), (60, 180, 75), (255, 225, 25), (0, 130, 200), (245, 130, 48),
           (145, 30, 180), (70, 240, 240), (240, 50, 230), (210, 245, 60), (250, 190, 212)]


def lonlat_to_3857(lon, lat):
    lat = max(min(lat, 85.05112878), -85.05112878)
    return R * math.radians(lon), R * math.log(math.tan(math.pi / 4 + math.radians(lat) / 2))


def make_projector(epsg):
    """Return f(lon, lat) -> (x, y) in the image CRS."""
    if epsg == 4326:
        return lambda lon, lat: (lon, lat)
    if epsg == 3857:
        return lonlat_to_3857
    try:
        from pyproj import Transformer
    except ImportError:
        raise SystemExit(f"EPSG:{epsg} needs pyproj: pip install pyproj")
    t = Transformer.from_crs(4326, epsg, always_xy=True)
    return lambda lon, lat: t.transform(lon, lat)


def geotiff_georef(img):
    """(x0, y0, sx, sy, epsg) from GeoTIFF tags of a north-up image."""
    tags = getattr(img, "tag_v2", {})
    tie, scale, keys = tags.get(33922), tags.get(33550), tags.get(34735)
    if not tie or not scale:
        raise SystemExit("No GeoTIFF tags found: pass --bbox or --worldfile")
    i, j, _, x, y, _ = tie[:6]
    epsg = None
    if keys:  # GeoKeyDirectory: header of 4, then entries of (key, loc, count, value)
        for k in range(4, len(keys), 4):
            if keys[k] in (3072, 2048):  # ProjectedCSTypeGeoKey, GeographicTypeGeoKey
                epsg = keys[k + 3]
    if epsg is None:
        raise SystemExit("GeoTIFF has no EPSG code: pass --epsg")
    return x - i * scale[0], y + j * scale[1], scale[0], -scale[1], epsg


def worldfile_georef(path):
    a, d, b, e, c, f = (float(v) for v in Path(path).read_text().split()[:6])
    if abs(d) > 1e-12 or abs(b) > 1e-12:
        raise SystemExit("Rotated world files are not supported (image must be north-up)")
    # World file references pixel centres; shift to the top-left corner.
    return c - a / 2, f - e / 2, a, e


def load_features(path):
    """Yield (tags, osm_id, rings) with rings = list of [(lon, lat), ...]."""
    data = json.loads(Path(path).read_text())
    if "features" in data:  # GeoJSON (Overpass Turbo export)
        for ft in data["features"]:
            g, props = ft.get("geometry") or {}, ft.get("properties") or {}
            tags = props.get("tags", props)
            fid = props.get("@id") or ft.get("id") or props.get("id")
            t, c = g.get("type"), g.get("coordinates")
            if t == "Point":
                rings = [[tuple(c)]]
            elif t == "LineString":
                rings = [[tuple(p) for p in c]]
            elif t == "Polygon":
                rings = [[tuple(p) for p in c[0]]]
            elif t == "MultiPolygon":
                rings = [[tuple(p) for p in poly[0]] for poly in c]
            elif t == "MultiLineString":
                rings = [[tuple(p) for p in line] for line in c]
            else:
                continue
            yield tags, fid, rings
    elif "elements" in data:  # raw Overpass JSON with `out geom;`
        for el in data["elements"]:
            tags, fid = el.get("tags", {}), f"{el['type']}/{el['id']}"
            if "lat" in el:
                rings = [[(el["lon"], el["lat"])]]
            elif "geometry" in el:
                rings = [[(p["lon"], p["lat"]) for p in el["geometry"]]]
            elif "members" in el:
                rings = [[(p["lon"], p["lat"]) for p in m["geometry"]]
                         for m in el["members"] if m.get("role") == "outer" and m.get("geometry")]
            elif "center" in el:
                rings = [[(el["center"]["lon"], el["center"]["lat"])]]
            else:
                continue
            if tags:
                yield tags, fid, rings
    else:
        raise SystemExit("Unrecognised OSM file: expected GeoJSON or Overpass JSON")


def class_of(tags, keys):
    for k in keys:
        if k in tags:
            return f"{k}={tags[k]}"
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("image")
    ap.add_argument("osm", help="Overpass Turbo GeoJSON export or Overpass JSON (out geom)")
    ap.add_argument("--bbox", help="W,S,E,N in lon/lat for a Web-Mercator image")
    ap.add_argument("--worldfile")
    ap.add_argument("--epsg", type=int, help="CRS of the image (with --worldfile, or to override GeoTIFF)")
    ap.add_argument("--keys", default=",".join(PRIMARY_KEYS), help="tag keys that define the class, in priority order")
    ap.add_argument("--point-box", type=float, default=16, help="box size in px for point objects")
    ap.add_argument("--out", help="annotated image path (default: <image>_osm.png)")
    ap.add_argument("--yolo", help="also write YOLO labels + classes.txt into this directory")
    args = ap.parse_args()

    img = Image.open(args.image)
    W, H = img.size
    if args.bbox:
        w, s, e, n = (float(v) for v in args.bbox.split(","))
        (x0, y1), (x1, y0) = lonlat_to_3857(w, s), lonlat_to_3857(e, n)
        sx, sy, proj = (x1 - x0) / W, (y1 - y0) / H, lonlat_to_3857  # y1 is south, so sy < 0
    elif args.worldfile:
        if not args.epsg:
            raise SystemExit("--worldfile needs --epsg")
        x0, y0, sx, sy = worldfile_georef(args.worldfile)
        proj = make_projector(args.epsg)
    else:
        x0, y0, sx, sy, epsg = geotiff_georef(img)
        proj = make_projector(args.epsg or epsg)

    def to_px(lon, lat):
        x, y = proj(lon, lat)
        return (x - x0) / sx, (y - y0) / sy

    keys = [k.strip() for k in args.keys.split(",") if k.strip()]
    canvas = img.convert("RGB")
    draw = ImageDraw.Draw(canvas)
    font = ImageFont.load_default()
    classes, labels = {}, []

    for tags, fid, rings in load_features(args.osm):
        cls = class_of(tags, keys)
        if cls is None:
            continue
        px_rings = [[to_px(lon, lat) for lon, lat in ring] for ring in rings]
        pts = [p for ring in px_rings for p in ring]
        xs, ys = [p[0] for p in pts], [p[1] for p in pts]
        if len(pts) == 1:
            half = args.point_box / 2
            box = [xs[0] - half, ys[0] - half, xs[0] + half, ys[0] + half]
        else:
            box = [min(xs), min(ys), max(xs), max(ys)]
        if box[2] < 0 or box[3] < 0 or box[0] >= W or box[1] >= H:
            continue  # entirely outside the image
        clipped = [max(box[0], 0), max(box[1], 0), min(box[2], W), min(box[3], H)]
        cid = classes.setdefault(cls, len(classes))
        color = PALETTE[cid % len(PALETTE)]
        for ring in px_rings:
            if len(ring) == 1:
                draw.ellipse([ring[0][0] - 5, ring[0][1] - 5, ring[0][0] + 5, ring[0][1] + 5], outline=color, width=2)
            else:
                draw.line(ring, fill=color, width=2)
        draw.rectangle(clipped, outline=color, width=1)
        draw.text((clipped[0] + 2, clipped[1] + 2), cls, fill=color, font=font)
        labels.append({"osm_id": fid, "class": cls, "class_id": cid,
                       "bbox_px": [round(v, 1) for v in clipped],
                       "truncated": clipped != box,
                       "polygons_px": [[[round(x, 1), round(y, 1)] for x, y in r] for r in px_rings]})

    out = Path(args.out or Path(args.image).with_suffix("").as_posix() + "_osm.png")
    canvas.save(out)
    labels_path = out.with_suffix(".json")
    labels_path.write_text(json.dumps({"image": args.image, "size": [W, H], "classes": classes,
                                       "objects": labels}, indent=1))
    if args.yolo:
        d = Path(args.yolo)
        d.mkdir(parents=True, exist_ok=True)
        lines = [f"{o['class_id']} {(o['bbox_px'][0] + o['bbox_px'][2]) / 2 / W:.6f} "
                 f"{(o['bbox_px'][1] + o['bbox_px'][3]) / 2 / H:.6f} "
                 f"{(o['bbox_px'][2] - o['bbox_px'][0]) / W:.6f} {(o['bbox_px'][3] - o['bbox_px'][1]) / H:.6f}"
                 for o in labels]
        (d / (Path(args.image).stem + ".txt")).write_text("\n".join(lines) + ("\n" if lines else ""))
        (d / "classes.txt").write_text("\n".join(sorted(classes, key=classes.get)) + "\n")

    counts = {}
    for o in labels:
        counts[o["class"]] = counts.get(o["class"], 0) + 1
    print(f"{len(labels)} OSM objects inside {W}x{H} image -> {out}, {labels_path}")
    for cls, n in sorted(counts.items(), key=lambda kv: -kv[1]):
        print(f"  {n:4d}  {cls}")


if __name__ == "__main__":
    main()

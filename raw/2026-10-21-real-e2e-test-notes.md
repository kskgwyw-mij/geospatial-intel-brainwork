# Real end-to-end test: DOP20 + pretrained detector + real OSM (run 2026-10-21)

Test record written by the assistant for the author. The per-site rows are in
`raw/2026-10-21-real-e2e-anchor.jsonl` and `raw/2026-10-21-real-e2e-uniform.jsonl`. Example image:
`raw/assets/2026-10-21-real-e2e-site-anchor-01.jpg` (blue circles = OSM objects, red boxes = detections).
Imagery: Bayerische Vermessungsverwaltung, DOP20 via WMS, CC BY 4.0. OSM: © OpenStreetMap contributors, ODbL.

## Setup
- Script: `tools/real_geo_test.py` (commit on branch claude/jolly-wozniak-3si3uq), seed 7, 40 sites per mode.
- Photo: real DOP20 RGB (`by_dop20c`, 0.2 m), rotated by a random heading and centre-cropped to 500 × 375 m
  (2500 × 1875 px). No metadata is passed to the matcher.
- Detector: YOLO11s-OBB pretrained on DOTA v1 (`yolo11s-obb.pt`), **no fine-tuning**, conf 0.25, 1024 px tiles with
  200 px overlap. Classes used: swimming pool → pool, storage tank → tank, soccer field → soccer, ground track field
  → track; tennis, basketball and baseball merged → court.
- Reference: real Overpass export of the Alpine-edge districts (`raw/2026-10-21-osm-anchors-alpine-edge.json`),
  outdoor objects of these classes only.
- Matcher: `tools/geo_match.py`, defaults (GSD 0.05–0.6 m, 4 m tolerance). Status: confident ≥ 4 inliers and margin ≥ 2;
  probable ≥ 3 and margin ≥ 1.
- Modes: `anchor` = photo centre within ±150 m of a random OSM object of a random class (optimistic);
  `uniform` = uniform inside the district boundaries available (GAP, MB, RO district, RO city, TS; TÖL, WM, BGL
  boundaries failed to download).
- A detection counts as correct if an OSM object of the same class lies within 10 m; a localisation counts as correct
  if the error is < 50 m.
- Runtime: about 8 s per photo (WMS fetch + CPU detection), median.

## Results — anchor mode (40 sites)
- Detections 313, of which 153 matched an OSM object → precision vs OSM 0.49. OSM objects in photos 239, found 149 →
  recall 0.62. Without the tank-farm site 17: precision 113/224 = 0.50, recall 108/195 = 0.55.
- Precision vs OSM is a lower bound: some "false positives" are real, unmapped objects (e.g. a grass pitch next to
  a mapped artificial-turf pitch at site 1). Recall misses are mostly small or partly hidden pools, and courts
  that DOTA does not recognise.
- 18/40 sites gave no match attempt (< 2 detections): 14 had 0 detections although 1–6 OSM objects were inside.
- Matcher status (22 attempts):
  - confident 4 → 3 correct (errors 0.9, 1.2, 1.6 m), **1 wrong (site 17, 63.5 km off)**;
  - probable 4 → 2 correct (2.7, 5.2 m), 2 wrong (44 and 50 km);
  - ambiguous 14 → 1 correct.
  - Overall correct localisations: 6/40 (15 %).
  - Correct matches: scale error 0.35–2.35 %, heading error 0.9–2.9°.
- **Site 17 failure:** a tank farm (48.0564 N, 12.1872 E) with 44 mapped tanks and 89 tank detections. The matcher
  picked the densest storage-tank cluster in the region (81 tanks, 47.7662 N, 12.9189 E) at a scale 76 % too large,
  with 68 inliers, more than the true pose supports. A dense, repetitive, single-class cluster breaks the
  independence assumption behind the inlier-count uniqueness argument.

## Results — uniform mode (40 sites)
- 36/40 photos contained **no** OSM anchor of these classes; 2 contained any; none contained ≥ 4.
- 18 detections in total, 2 correct (precision 0.11); 4 match attempts, all ambiguous and all wrong.
- Correct localisations: **0/40**, consistent with the 1 % found with simulated detections on the real layout.

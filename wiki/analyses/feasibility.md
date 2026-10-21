---
title: Technical & statistical feasibility
type: analysis
tags: [feasibility, statistics, evaluation, risks]
sources: [localization-levers-test, real-e2e-test, osm-real-test, author-decision-no-metadata, author-decision-search-region, author-decision-detection-in-scope, bayern-dop20rgb-detail, bayern-opengeodata, pretrained-models-search, dsia-studienordnung-2027, costea-2016-aerial-geolocalization]
updated: 2026-10-21
---
Why metadata-free localisation from detected OSM objects is technically buildable and statistically sound, with back-of-envelope numbers: false-match probability, anchor availability, precision, and the test-set sizes needed to prove it.

## Technical feasibility

| Component | What it needs | Status / effort |
|---|---|---|
| Data | DOP20, DOM20, DGM1, official labels, all open CC BY 4.0 ([[bayern-opengeodata]], [[bayern-dop20rgb-detail]]); OSM via Overpass | Available. Sample tiles (the full region is about 160–390 GB) |
| Detection (FF1) | Fine-tune YOLO11-OBB (DOTA weights) and a U-Net on 20 cm chips ([[pretrained-models]]) | Standard; one GPU; the HOK "Data Labs" might provide compute ([[dsia-studienordnung-2027]]). Labels via `osm_overlay.py` |
| Map index | All anchor objects of about 7,800 km² in memory | Tens to hundreds of thousands of points, trivial in RAM (unsourced) |
| Matching (stage 1–2) | `geo_match.py` | Working: about 2.7 s per photo for the full region in pure Python; vectorising would speed it up ([[geo-match-prototype]]) |
| Fine registration (stage 3–4) | OpenCV keypoints + RANSAC homography; DOM20 heights for the pose | Standard computer-vision building blocks ([[coarse-to-fine-localization]]) |
| Evaluation | Simulated metadata-free crops of held-out DOP20 with known truth | Cheap: thousands of test photos possible (`sim_geo_match.py`) |

Main technical risks (unsourced):
1. Too few detectable anchors in rural and Alpine photos (see A2).
2. Domain gap between orthophotos used for training and raw drone frames at test time (lean, lighting, season).
3. OSM incompleteness and positional error.

## Statistical feasibility

### A1. Is a match unique? (false-match probability)
For a wrong hypothesis, each other detection lands on a same-class OSM object by chance with
p ≈ ρ_class · π · tol². For hypothetical pools (4,250 in 7,800 km², ρ ≈ 0.5/km², tol 4 m), p ≈ 2.7·10⁻⁵.
With H tested hypotheses and m = 8 other detections, the expected number of false matches is H · P(Binomial(m, p) ≥ k−2):

| Required inliers k | H = 10⁵ | H = 10⁶ |
|---|---|---|
| 3 | 22 | 220 |
| **4** | **0.002** | **0.02** |
| 5 | 10⁻⁷ | 10⁻⁶ |

**Each extra agreeing object multiplies the false-match risk by about 10⁻⁴.** This is why 3 inliers are
ambiguous and ≥ 4 is "confident", consistent with the simulation ([[geo-match-prototype]]). Caveats: objects cluster in
villages, which raises local density and p; dense classes such as buildings (about 50/km² hypothetical, p ≈ 2.6·10⁻³)
need more inliers, or a richer per-object descriptor (size, orientation, roof shape) that lowers p. (unsourced, hypothetical counts)

### A2. Will a photo contain enough anchors? (the real bottleneck)
The anchors detected in one photo follow roughly Poisson(λ), with λ = anchor density × footprint × recall. A 4000 × 3000 photo at
0.15 m covers about 0.27 km²; recall 0.85:

| Anchor density | Mean detected | P(≥ 4) | P(≥ 8) |
|---|---|---|---|
| 2 /km² (rare point objects, e.g. pools) | 0.5 | 0.00 | 0.00 |
| 10 /km² | 2.3 | 0.20 | 0.00 |
| 30 /km² | 6.9 | 0.91 | 0.38 |
| 100 /km² (e.g. buildings in villages) | 22.9 | 1.00 | 1.00 |

So rare anchors alone cannot work for single photos. **Dense anchors (buildings, trees, intersections) are statistically
required**, with rare anchors as the discriminating "keys". This matches [[author-note-rural-roads]]. (unsourced, hypothetical densities)

### A3. How precise? (error propagation)
With n matched points and per-point noise σ (detector centroid + OSM position error), a least-squares fit gives
position error ≈ σ/√n and heading error ≈ σ/(√n·R), where R is the spread of the points:
- σ = 2 m, n = 8 → about **0.7 m**, heading about 0.3°;
- dense registration, σ = 0.3 m, n = 300 → about **2 cm** formally; systematic errors (relief, DOP georeference) then dominate.

**Simulation check** (`sim_geo_match.py --osm-noise`, 60 photos, 900 km²):

| OSM position error (σ per axis) | Median position error | GSD error | Heading error | Confident correct |
|---|---|---|---|---|
| 0 m | 0.30 m | 0.07 % | 0.06° | 12/12 |
| 1 m | 0.72 m | 0.23 % | 0.13° | 12/12 |
| 2 m | 1.78 m | 0.49 % | 0.25° | 9/9 |

The OSM error passes almost one-to-one into position error, while correctness of confident matches is unaffected. Hence
stage 3 registers against DOP20 rather than OSM for sub-metre results ([[coarse-to-fine-localization]]).

### A4. How to prove it (evaluation design)
- **Sample size:** a success rate with a 95 % CI of ±10 percentage points needs about **100 test photos per condition**;
  ±5 pp needs about 385. Conditions: urban / rural / Alpine × anchor types × detector variants. Simulated crops make this cheap.
- **Spatial independence:** train on the Oberland districts, test on RO, TS and BGL ([[imagery-sources]]), so test areas are never seen in training.
- **Report:**
  - success rate with Wilson confidence interval;
  - position, scale and heading error as median and 90th percentile;
  - calibration of the status (precision of "confident");
  - success vs. number of detected anchors (the FF2 curve);
  - detector metrics per class (FF1).
- **Comparisons:** bootstrap CIs, or McNemar's test for paired success/failure between methods on the same photos.
- **End-to-end:** replace simulated detections with real detector output to measure how FF1 errors propagate into FF2 ([[author-decision-detection-in-scope]]).

## Reality check with real OSM data ([[osm-real-test]])
The densities above were hypothetical. Measured in the region:
- **Point anchors are about 1.5/km² in total** (pools 0.12/km², not the assumed 0.5/km²). That is the "2/km²" row of A2, so P(≥ 4) is about 0.
- On the real layout, **randomly placed photos are located only 1 % of the time**, and 89 % contain ≤ 2 detections.
- **Buildings: about 55/km²** in Miesbach. Real random footprints: ≥ 4 buildings 32 %, ≥ 8 buildings 23 %, **no building in 51 %**.

So A2's prediction is confirmed with real data. Object-based localisation is feasible in **settled areas** using buildings
(with size, orientation and roof descriptors, because 74 % are just `building=yes`). In about half of the Alpine-edge area it is
infeasible without terrain (DGM1) and shape cues (forest edges, water).

## Real end-to-end check ([[real-e2e-test]])
With real DOP20 photos, an off-the-shelf DOTA detector (precision about 0.5, recall about 0.6 against OSM) and real OSM:
6/40 photos near anchors and **0/40 uniformly placed photos** were located. One "confident" match was wrong. A repetitive tank farm
matched a denser tank farm 63.5 km away, so A1's independence assumption fails for clustered single-class objects.
A1 should therefore count inliers *above the expected chance level for the local density* rather than raw inliers (proposal, unsourced).

## Coverage ceilings per cue ([[localization-levers-test]])
Share of random Garmisch photos (500 × 375 m) with enough of each cue: point anchors 0.1–1.6 %, buildings ≥ 8 16 %, junctions ≥ 3 32 %, object cues combined 34 %, object or line cues (roads, water, forest edges) **78 %**, nothing mapped 22 %. Ranked plan: [[localization-improvements]].

## Bottom line
Technically, every component exists or has a working prototype. Statistically, uniqueness is not the problem
(≥ 4 agreeing objects make false matches very rare in about 7,800 km²); **anchor availability is**, and real OSM data
confirms it: point anchors cover about 1 % of random photos, buildings about 25–30 %, and half the area has no buildings ([[osm-real-test]]). The real end-to-end run located 0/40 random photos and showed that repetitive clusters can fool the confidence rule ([[real-e2e-test]]). The thesis
therefore stands or falls on detecting enough *dense* anchors per photo, which makes FF1 (detection) and FF2
(localisation) inseparable.

## Related
- [[geo-match-prototype]]
- [[coarse-to-fine-localization]]
- [[osm-fingerprint-geolocalization]]
- [[thesis-timeline]]

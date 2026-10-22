---
title: Geolocation matcher prototype & first simulation
type: analysis
tags: [geolocalization, ransac, prototype, evaluation]
sources: [author-note-novelty, localization-levers-test, real-e2e-test, osm-real-test, author-decision-no-metadata, author-decision-search-region, costea-2016-aerial-geolocalization, author-decision-detection-in-scope]
updated: 2026-10-22
---
First working prototype of metadata-free photo geolocation (`tools/geo_match.py`) and its evaluation on simulated photos (`tools/sim_geo_match.py`): confident matches were always right, but photos need about 5–8 detected anchors.

## What it does
Input: detected objects (class + pixel position, optional `length_px` for standard-size objects such as tennis
courts) and an Overpass export of the search region. Output: centre position, GSD (m/px), heading of the image
top, the four corner coordinates, inliers, runner-up, and a **status** (`confident` / `probable` / `ambiguous`).
It fits a 2D similarity transform by hypothesise-and-verify in the spirit of [[ransac]]:
1. Every pair of detections (rarest classes first) plus every OSM pair of the same classes at a compatible distance proposes a transform. The scale range comes from the GSD prior or from metric anchors.
2. A cheap pre-check against a few other rare detections prunes proposals.
3. Each surviving proposal is scored by how many detections land within tolerance (max(4 m, 3 px)) of a same-class OSM object.
4. The best proposal is refined by least squares on its inliers; the runner-up must be more than 200 m away.

This follows the retrieve-then-verify pattern of [[costea-2016-aerial-geolocalization]], adapted to the input decision that photos carry no metadata, so scale and rotation are unknown ([[author-decision-no-metadata]]).

## Simulation setup (all synthetic)
- Objects clustered around villages: pools, tennis courts, storage tanks, soccer pitches, silos and power towers, with hypothetical Poisson counts per village.
- Photos are 4000 × 3000 px with true GSD 0.08–0.25 m and random heading.
- Detector: 85 % recall, ±3 px jitter, 2 false alarms per photo. OSM is missing 10 % of objects.
- Two region sizes: 900 km² (120 villages) and **7,744 km²** (1,040 villages), about the size of the Alpine-edge search region [[oberbayern-sued]] ([[author-decision-search-region]]).

## Results (synthetic densities, illustrative only)

| Region | Photos | Located < 10 m | Confident (correct) | Probable (correct) | 5–7 detections | ≥ 8 detections | Time per photo |
|---|---|---|---|---|---|---|---|
| 900 km² | 60 | 21 (35 %) | 11 (11) | 10 (7) | 17/20 | 4/4 | about 0.2 s |
| 7,744 km² | 40 | 9 (22 %) | 8 (8) | 5 (1) | 3/10 | 6/7 | about 2.7 s |

When located: median position error **0.2–0.4 m**, GSD error **< 0.1 %**, heading error **< 0.1°**.

## Real OSM layout (added later; detections still simulated)
> [!warning] The tables above use synthetic villages with hypothetical densities.
> On the **real** OSM anchors of the seven districts ([[osm-real-test]], 11,599 objects, about 1.5/km²), with 1 m OSM noise and 100 photos:
> - photos near objects: 38 % located, **confident 30/30 correct**, median error 0.74 m;
> - **photos uniformly placed in the region: 1 % located** (89/100 photos had 0–2 detections).
>
> Reliability holds on real geometry; coverage does not. Point anchors alone cannot locate typical photos. Use
> `--uniform-photos` for honest coverage numbers; the default (photos near objects) is optimistic.

## Real end-to-end run (added later; real imagery and real detector)
> [!warning] Contradiction
> With real DOP20 photos and a pretrained DOTA detector ([[real-e2e-test]]), "confident" was **3/4 correct**, not 100 %.
> The failure was a tank farm (44 mapped tanks, 89 detections) matched to the region's densest tank cluster 63.5 km away, at a 76 % wrong
> scale with 68 inliers. In a dense, repetitive single-class cluster, inlier count no longer measures uniqueness.
> Overall: 6/40 photos near anchors located (15 %), 0/40 uniformly placed. Correct matches: 0.9–5.2 m, ≤ 2.4 % scale and ≤ 2.9° heading error.

**Implemented (2026-10-21):** "confident" now also needs inliers from ≥ 2 classes (`min_classes=2`). On the same 40 real sites, confident went from 3/4 to 2/2 correct ([[localization-levers-test]]). Simulation numbers above were produced with the old rule.

**Planned replacement:** score poses with a point-process likelihood that includes a detector-error model, and compare it against a null hypothesis instead of counting inliers. Its undetected-object term should penalise lattice errors like the tank farm on principle ([[thesis-contribution]]).

Further fixes (proposal, unsourced): score hypotheses by inliers **beyond the chance expectation** given the local OSM density
of each class at the hypothesised scale; cap the contribution of any one class (or require ≥ 2 classes for "confident"); and keep a GSD prior
when the camera type is roughly known.

## OSM positional error (added later)
`--osm-noise` shifts OSM objects by σ metres per axis. At σ = 0 / 1 / 2 m (60 photos, 900 km²) the median position error is 0.30 / 0.72 / 1.78 m, while confident matches stay 100 % correct (12/12, 12/12, 9/9). OSM error passes almost one-to-one into position error, so sub-metre accuracy needs registration against DOP20 ([[feasibility]], [[coarse-to-fine-localization]]).

## Findings
- **Two detections never suffice**: two points always fit some similarity transform, so 2-inlier answers are noise. This is why the status rule needs ≥ 3 inliers.
- **"Confident" (≥ 4 inliers, margin ≥ 2) was 100 % correct** in both simulated runs (19/19), but only 3/4 on real data ([[real-e2e-test]]); see the warning above. "Probable" degrades with region size (1 of 5 correct at 7,744 km²).
- **About 8 or more detected anchors are needed** in a region of about 7,700 km²; 5–7 suffice in a 900 km² region. Larger regions need more evidence, consistent with the uniqueness maths in [[osm-fingerprint-geolocalization]].
- **3–4 detections fail (0/51).** At 0.08–0.25 m a 4000 × 3000 photo covers only about 320 × 240 m to 1000 × 750 m, so rural photos often have too few point anchors. This quantifies [[author-note-rural-roads]]: add dense anchors (buildings with orientation, road intersections) and shape or terrain cues ([[rural-geolocalization-search]]).

## Limitations / next steps (unsourced)
- This prototype is stages 1–2 of [[coarse-to-fine-localization]]. Fine accuracy needs dense registration against DOP20 and DOM20 heights (stages 3–4).
- ~~Synthetic densities: rerun with the real Overpass export~~ done ([[osm-real-test]]); real imagery + real detector done ([[real-e2e-test]]).
- Only point anchors so far. Next: building footprints (orientation and size), road intersections (Costea-style), forest-edge and water shape matching, DEM.
- Pure Python; about 2.7 s per photo at regional scale. Vectorising or using a k-d tree would speed it up.
- Real detections will come from the fine-tuned detectors ([[pretrained-models]], [[methods-10-25cm]]). Detection is in scope ([[author-decision-detection-in-scope]]), so replace the simulated 85 % recall, 2 false alarms and perfect classes with the **measured** detector performance, including class confusion. First measurement with the off-the-shelf DOTA model: precision about 0.5, recall about 0.6 against OSM ([[real-e2e-test]]).

## Related
- [[thesis-contribution]]
- [[localization-improvements]]
- [[feasibility]]
- [[coarse-to-fine-localization]]
- [[osm-fingerprint-geolocalization]]
- [[ransac]]
- [[oberbayern-sued]]
- [[thesis-poc-pipeline]]

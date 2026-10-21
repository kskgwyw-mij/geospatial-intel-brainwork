---
title: RANSAC
type: concept
tags: [geometry, matching, robust-estimation]
sources: [costea-2016-aerial-geolocalization]
updated: 2026-10-21
---
RANSAC (RANdom SAmple Consensus) fits a geometric model, such as the shift, rotation and scale that map a photo onto the map, from data that contains many wrong matches, by repeatedly fitting to tiny random samples and keeping the model that most points agree with.

## The problem it solves
Matching detected objects to OSM objects produces candidate correspondences ("this pool in the photo is that
OSM pool"), and many are wrong: false detections, similar-looking neighbours, objects missing from OSM.
A least-squares fit over all of them is pulled off by the wrong ones. RANSAC ignores them. (unsourced)

## How it works (unsourced; standard algorithm, Fischler & Bolles 1981)
1. **Sample** the minimum number of correspondences that defines the model. A 2D similarity transform
   (translation + rotation + scale) needs **2** point pairs; an affine transform needs **3**.
2. **Fit** the model to just that sample.
3. **Score:** apply it to all other correspondences and count the **inliers**, the ones that land within a
   tolerance (for example 5 m) of their partner.
4. **Repeat** many times and keep the model with the most inliers.
5. **Refine:** re-fit with least squares on all inliers of the best model.

Number of iterations needed: k = log(1 − p) / log(1 − wˢ), where w = inlier ratio, s = sample size and
p = desired success probability. With w = 0.3, s = 2 and p = 0.99, k ≈ 49 iterations. With s = 3 (affine), k ≈ 169.

## Where it appears in this wiki
- **Costea & Leordeanu:** Shape Context correspondences between detected and OSM roads → affine transform fitted with RANSAC → Chamfer distance to score the fit ([[costea-2016-aerial-geolocalization]]).
- **Metadata-free geolocation:** the core matcher. Fit the similarity transform between detected anchors and the regional OSM index. The winning model *is* the answer: position, scale (GSD) and rotation (north) ([[osm-fingerprint-geolocalization]]).
- Also usable to align projected OSM labels to detections when cleaning weak labels ([[osm-weak-labels]]).

## Toy example (unsourced)
Photo: 6 detected objects. Candidates: 10 OSM matches, of which 7 are wrong.
- One random sample, "pool ↔ pool A" plus "tank ↔ tank B", gives scale 0.2 m/px and rotation 30°; only 2 of 10 matches agree, so reject it.
- Another, "pool ↔ pool C" plus "court ↔ court D", gives scale 0.19 m/px and rotation 112°; 3 of 10 agree within 5 m, and nothing else beats it, so keep it.
- Re-fit on those 3 inliers: the photo lies at that location, at 0.19 m/px, rotated 112°.

## Related
- [[osm-fingerprint-geolocalization]]
- [[costea-2016-aerial-geolocalization]]
- [[osm-weak-labels]]

---
title: Costea & Leordeanu 2016 — aerial geolocalisation via roads & intersections in OSM
type: source
tags: [geolocalization, osm, roads, matching, paper]
sources: [costea-2016-aerial-geolocalization]
raw: raw/2026-10-21-costea-2016-arxiv-1605.08323v1.pdf
updated: 2026-10-21
---
Locates aerial images without GPS by detecting roads and intersections, matching the neighbourhood of each intersection to OSM as a "unique fingerprint", and confirming with geometric road alignment: about 90 % of intersections are localised within 2.5 m.

## Summary
Dragos Costea & Marius Leordeanu (University Politehnica of Bucharest), arXiv:1605.08323v1,
26 May 2016 (BMVC 2016). Full text read from the PDF. The pipeline has four stages:
1. pixelwise road detection;
2. intersection detection;
3. intersection identification, by matching its surrounding region to a stored OSM database of roads and intersections, giving k candidates;
4. geometric alignment, keeping the candidate with the lowest alignment error. The aligned OSM map is then used to improve the road detection.

Key insight, quoted: intersections "tend to have a unique pattern of roads in the neighborhood region, which acts as a
**unique fingerprint**". That reduces localisation to sparse feature matching followed by a local alignment.

## Key claims
- **Why intersections are used as anchors:**
  - once they are matched, every image point is located;
  - they are sparse, so storage and matching are cheap;
  - their surroundings make them discriminative.
- **Orientation is assumed known** (from a compass). Robustness was tested with Gaussian rotation noise of σ = 5°. That slightly hurt identification but not the final alignment, which is affine-invariant.
- **Roads:** LG-Net, a dual-stream CNN. A local VGG-type path looks at a 64×64 patch and a context AlexNet-type path at a 256×256 patch; the output is a 16×16 centre road mask.
- **Intersections:** AlexNet on RGB plus the predicted road map, scanning window plus non-maxima suppression.
  - Adding RGB to the road map raised detection F from 65.18 % to 67.71 %.
  - Evaluating on a 10-px grid and interpolating gave a ×100 speed-up for a small loss in quality.
- **Descriptor:** the 4096-d final fully connected layer, fine-tuned Siamese-style with a contrastive loss (margin m): same intersection pulled close, different ones pushed apart.
- **Region matching (Algorithm 1):** the distance between a test and an OSM intersection is the symmetric mean of summed 1-nearest-neighbour descriptor distances between all intersections within radius w around each. **A larger radius gives more accurate identification.** Neighbouring intersections are often confused, which alignment fixes.
- **Geometric verification (Algorithm 2):** Shape Context descriptors on sampled road points → kNN correspondences → affine transform fitted with RANSAC → symmetric Chamfer distance via a distance transform. Keep the candidate with the minimum distance.
- **Data:** two European cities, 600×600 px tiles at **1 m/px**, about 70 km² each. Trained on city A, tested on city B, with 3,177 test intersections. Image quality is low. OSM serves as ground truth.
- **Results:**
  - Identification rate rises with radius, and geometric alignment brings it **close to 90 %** even for small radii. Descriptor fine-tuning helps consistently.
  - **About 90 % or more of localisation errors are below 2.5 m**, which is under 3 px.
- **Road enhancement with aligned OSM:**
  - Method: soft-dilate the predicted roads, multiply them by the aligned OSM map, smooth, thin, then re-dilate.
  - Road F-measure rises from **66.5 % to 93.9 %**, without using ground-truth localisation.
- **OSM is imperfect:** some correctly detected intersections are missing in OSM, and OSM roads can be wrong or outdated.
- **Compute:** training took 3–5 days on a GTX 970 (4 GB). Test speed is about 5 km²/s for roads and 0.7 km²/s for intersections; matching and alignment are about 10× faster still within 70 km². With a search area 5× smaller, the authors estimate near real-time on a Jetson TX1.

## Relevance to this wiki
- It **validates the fingerprint idea** in [[osm-fingerprint-geolocalization]], but shows the fingerprint should be
  a **neighbourhood constellation** of anchors (all intersections within radius w), not a single object, and
  that **retrieve-then-verify** (descriptor kNN, then geometric alignment) is the working pattern.
- It confirms that **known orientation (north-up) is a usable second factor**; orthophotos give it for free.
- At 1 m/px roads and intersections suffice. At 10–25 cm, richer anchors (pools, tanks, pitches) become available ([[methods-10-25cm]]). (unsourced)
- The OSM-alignment trick for cleaning detections can also clean noisy training labels ([[osm-weak-labels]]).

## Correction
An earlier version of this page, built from search snippets, mixed in a "648× faster" claim. That claim is from **Lin et al.
(SPIE)**, not this paper. It remains in `raw/2026-10-21-aerial-geolocalization-osm-search.md` and is cited separately below.
- Lin et al. (SPIE): semantic-level object descriptors are orders of magnitude fewer than pixel descriptors, and matching was 648× faster (search snippet only).

## Pages touched
[[osm-fingerprint-geolocalization]], [[osm-weak-labels]], [[overview]]

## Related
- [[osm-fingerprint-geolocalization]]
- [[osm-weak-labels]]

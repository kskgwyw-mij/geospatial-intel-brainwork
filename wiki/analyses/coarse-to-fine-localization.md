---
title: Coarse-to-fine localisation
type: analysis
tags: [geolocalization, registration, pose, accuracy]
sources: [settlement-test, costea-2016-aerial-geolocalization, author-decision-no-metadata, author-decision-search-region, bayern-dop20rgb-detail, bayern-opengeodata, maggiori-2017-hr-semantic-labeling, rural-geolocalization-search]
updated: 2026-10-21
---
How to go from "somewhere in the search region" to a fine-grained (decimetre-level) position, scale, heading and full camera pose for a metadata-free nadir photo, in four stages from object fingerprints to dense image registration.

## Why one step is not enough
OSM object positions are only accurate to metres, and centroids of detected boxes are noisy. The object matcher
([[geo-match-prototype]]) therefore delivers a *good coarse fix*, not survey accuracy. Fine accuracy needs a
reference with centimetre georeferencing: the Bavarian **DOP20** orthophoto ([[bayern-dop20rgb-detail]]) and the
**DOM20/DGM1** height models ([[bayern-opengeodata]]). (unsourced)

## The four stages

| Stage | Input → output | Method | Expected accuracy |
|---|---|---|---|
| **0. Prior** | Search region | Region polygon (ALKIS districts) | about 7,800 km² ([[oberbayern-sued]]) |
| **1. Retrieval** | Detected objects → a few candidate places | Object-constellation fingerprints against the OSM index; optionally an image-embedding search over DOP tiles (for example DINOv3 features, [[pretrained-models]]) | km → 10–100 m (unsourced) |
| **2. Object alignment** | Candidate → position + scale + heading | Similarity fit with [[ransac]] on matched objects (`geo_match.py`); confident status only | about 0.2–0.4 m in simulation ([[geo-match-prototype]]); Costea & Leordeanu: about 90 % of intersections within 2.5 m at 1 m/px ([[costea-2016-aerial-geolocalization]]) |
| **3. Dense registration** | Photo + DOP20 window → sub-metre fit | Warp the DOP20 window with the stage-2 transform, then match **many local image features** (keypoints such as SIFT/ORB, or learned matchers) or edges (building outlines, Chamfer distance as in Costea), and fit a homography with RANSAC | about 1–2 DOP pixels, i.e. 0.2–0.4 m, *if the photo is close to nadir and flat terrain* (unsourced) |
| **4. Pose with heights** | Matches + DOM20/DGM1 → full camera pose (x, y, z, roll, pitch, yaw) | Give each matched point its 3D height from DOM20 and solve a perspective-n-point problem. This removes the relief displacement that a flat homography cannot explain ([[orthoimagery]]) | decimetre-level camera position, plus flying height and tilt (unsourced) |

Stage 1–2 answer *"where roughly, how big, which way"*. Stage 3–4 answer *"exactly where, at what height, how tilted"*.

## Why stages 3–4 matter here
- **Relief displacement:** a raw nadir drone frame shows tall objects leaning outward (d = r·h/H). Treating the photo as flat leaves metre-level errors near buildings and in mountainous terrain. DOM20 heights correct this. (unsourced; formula on [[orthoimagery]])
- **Alpine terrain:** in [[oberbayern-sued]] the ground itself is not flat, so a single scale is only valid locally. Stage 4 with DGM1 fixes this; DEM-only localisation is far coarser (about 26–31 m after 2 km in a UAV study, [[rural-geolocalization-search]]).
- **Image vs. map changes:** fine registration against DOP fails where the scene changed (new buildings, snow, season). Use the historical DOP WMS to pick the closest flight year ([[bayern-dop20rgb-detail]]), and rely on stable structures such as building edges and roads. (unsourced)
- **Few anchors:** if stage 1–2 cannot find 3–4 objects (rural tiles), stage 3 can still work *if* a coarse prior exists, for example a neighbouring frame of the same flight. Fine registration needs a starting guess, not many objects. (unsourced)

## What "fine-grained" can mean (pick for the thesis)
1. **Footprint on the map:** stages 1–2 are enough at metre level, which is enough for most use cases ([[gnss-denied-use-cases]]).
2. **Per-object coordinates** (each pool, mast or tree): stage 3 adds sub-metre accuracy.
3. **Drone camera pose** (GNSS replacement, height, tilt): stage 4.

## Implementation notes (unsourced)
- Stage 3 can be prototyped with OpenCV (ORB or SIFT + RANSAC homography) on simulated crops of DOP20, where the truth is known. That extends `sim_geo_match.py`.
- Stage 4 needs DOM20 tiles for the matched area and an approximate camera model (focal length can be estimated if unknown).
- Evaluate each stage separately: success rate and error after stage 2 vs. after stage 3/4.

## Settlement mask as a coarse cue (proposal)
A settlement / no-settlement mask can be predicted stably across districts and flight years ([[settlement-detection]]). Its layout in a photo (where villages and farmsteads lie) is a season-robust shape cue for the retrieval stage, before object RANSAC (unsourced).

## Related
- [[settlement-detection]]
- [[geo-match-prototype]]
- [[osm-fingerprint-geolocalization]]
- [[ransac]]
- [[bayern-dop20rgb-detail]]
- [[gnss-denied-use-cases]]

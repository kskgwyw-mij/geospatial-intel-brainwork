---
title: Terrain-relative navigation (TRN / VTRN)
type: concept
tags: [navigation, geolocalization, gnss-denied, uav]
sources: [author-note-novelty, vtrn-literature-search, costea-2016-aerial-geolocalization, rural-geolocalization-search]
updated: 2026-10-22
---
Estimating a vehicle's position by matching its sensor view of the ground (elevation, or camera images in the visual variant, VTRN) against a georeferenced map, usually fused with inertial sensors. It is the established name for what this thesis does with OSM objects.

## Variants by what is matched
| Sensor view | Map | Examples |
|---|---|---|
| Elevation profile (radar altimeter) | Elevation model | TERCOM, cruise missiles ([[vtrn-literature-search]]) |
| Camera image | Reference image | DSMAC; Mars 2020 LVS; Conte & Doherty 2009; Goforth & Lucey 2019; Kinnari et al. 2022 ([[vtrn-literature-search]]) |
| Camera image | Rendered 3D view | Patel et al. 2020, Google Earth ([[vtrn-literature-search]]) |
| Detected roads / intersections | OSM road graph | Costea & Leordeanu 2016 ([[costea-2016-aerial-geolocalization]]) |
| Semantic layers / vector features | OSM / vector map | OrienterNet (ground level), building-contour matching, SASGeo (synthetic) ([[vtrn-literature-search]]) |
| Detected objects (ground robot) | OSM landmarks, scene graph | Kunz et al. 2021 ([[author-note-novelty]]) |
| Hand-built query graph | Road + building-footprint graph | Shankar et al. 2016, subgraph isomorphism ([[author-note-novelty]]) |
| Indistinguishable landmarks (theory) | Poisson point process | Hu, Dhillon & Buehrer 2024, localizability analysis ([[author-note-novelty]]) |
| Detected objects (this thesis) | OSM objects via Overpass | [[geo-match-prototype]], [[osm-fingerprint-geolocalization]]; planned point-process likelihood ([[thesis-contribution]]) |
| Elevation from images / DEM | DEM | DEM orthoprojection ([[rural-geolocalization-search]]) |

## Typical structure
1. A prior or dead reckoning (IMU, visual odometry) limits the search area.
2. Register the view to the map, to get an absolute fix.
3. Fuse with a filter (EKF, particle filter), which corrects the drift.

Planetary landers, missiles and most UAV systems work this way ([[vtrn-literature-search]]). This thesis's current prototype does step 2 for one photo, without a prior. That is the hardest case: compare the prior scenario in [[localization-improvements]].

## Known weak points
- **Appearance change:** season, snow and lighting make image-to-image VTRN "extremely fragile" ([[vtrn-literature-search]]). Semantic or object maps are less affected (unsourced; plausible because objects persist), which supports our settlement result across flights ([[settlement-test]]).
- **Terrain without structure:** accuracy depends on the terrain's structure (Conte & Doherty 2009). Reviews name regions without clear semantic features as an open problem ([[vtrn-literature-search]]). Measured here: 22 % of random Alpine-edge photos contain no mapped cue ([[localization-levers-test]]).
- **Cross-view gap:** an oblique UAV view differs from the nadir map. This thesis avoids it by using nadir images ([[author-decision-nadir-input]]).

## Related
- [[thesis-contribution]]
- [[vtrn-literature-search]]
- [[gnss-denied-use-cases]]
- [[coarse-to-fine-localization]]
- [[localization-improvements]]
- [[ransac]]

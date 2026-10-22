---
title: Literature search — Visual Terrain-Relative Navigation and UAV absolute visual localisation
type: source
tags: [literature, geolocalization, gnss-denied, navigation, uav]
sources: [vtrn-literature-search]
raw: raw/2026-10-22-vtrn-literature-search.md
updated: 2026-10-22
---
A web-search survey of research on visual terrain-relative navigation (VTRN): from planetary landing and missile guidance, to UAV image-to-orthophoto matching, reviews and datasets, to semantic/vector-map localisation, which is closest to this thesis.

## Summary
VTRN fixes a vehicle's position by registering its camera images to a georeferenced map, usually fused with an IMU. The idea comes
from guided missiles (TERCOM, DSMAC) and planetary landing (Mars 2020 LVS). UAV research mostly matches **imagery to imagery**
(orthophotos, satellite, Google Earth), and its main stated weakness is appearance change (seasons, snow). Matching against
**semantic or vector maps** (OSM, building outlines), which is what this thesis does with objects, is newer and mostly urban, ground-level or synthetic.
All facts below come from search snippets and abstracts; no full text was read.

## Key claims
- **Mars 2020 LVS:** descent images were matched to a map built from orbital imagery and fused with the IMU. Inertial error of up to 3.2 km was reduced to < 40 m, against a 60 m landing requirement ([[vtrn-literature-search]]).
- **Mourikis et al. 2009 (IEEE T-RO 25(2)):** mapped landmarks plus feature tracks in an EKF; 6.4 m position error at touchdown in a rocket test ([[vtrn-literature-search]]).
- **Conte & Doherty 2009 (EURASIP):** UAV navigation through long GPS outages by matching video to a geo-referenced aerial image. Accuracy **depends on the terrain's structure** ([[vtrn-literature-search]]).
- **Goforth & Lucey 2019 (ICRA):** CNN features against satellite imagery, < 8 m mean error at 200 m altitude over 0.85 km ([[vtrn-literature-search]]).
- **Patel et al. 2020 (ICRA):** registration against rendered Google Earth views, < 1 m / 1° RMSE on a 303 m flight ([[vtrn-literature-search]]).
- **Fragoso et al. 2021 (Science Robotics):** VTRN is "extremely fragile" to seasonal effects. A learned transform into a season-invariant domain fixes this ([[vtrn-literature-search]]).
- **Kinnari et al. 2021 and 2022 (arXiv; IEEE RA-L 7(4)):**
  - The 2021 work matches onboard images to orthophotos inside a particle filter; error < 50 m RMS after about 2 km of travel.
  - The 2022 work (RA-L) adds season-invariant CNN matching, with large gains over 6 baselines.

  ([[vtrn-literature-search]])
- **Couturier & Akhloufi 2021 (RAS 135:103666):** a review of absolute visual localisation for UAVs, with a 2024 follow-up review on deep learning ([[vtrn-literature-search]]).
- **Datasets:**
  - University-1652 (ACM MM 2020): drone, satellite and ground views of 1,652 buildings;
  - UAV-VisLoc (2024): 6,742 drone images at 11 locations in China, motivated by earlier sets being small or urban-only.

  ([[vtrn-literature-search]])
- **Semantic-map localisation:**
  - OrienterNet (CVPR 2023) matches ground images to **OpenStreetMap** with sub-metre accuracy;
  - a 2023 vector-map method matches building contours with a particle filter, and a cited shape-matching method reaches 3.6 m over 2.2 km²;
  - SASGeo (arXiv 2026) uses roads, buildings, waterways and intersections, reaching 94.5–95.5 % Recall@1 in synthetic trials only.

  ([[vtrn-literature-search]])
- **Stated open problem:** a 2025 review says methods struggle in **regions lacking clear semantic features, particularly at low altitude** ([[vtrn-literature-search]]).

## Relevance to this wiki
- **The relevance section of the exposé gets peer-reviewed backing.** GNSS-denied UAV localisation is an active field, with reviews, datasets and NASA flight use ([[expose-material]], [[gnss-denied-use-cases]]).
- **The gap this thesis fills becomes concrete:**
  - object/semantic-map matching against **OSM** from **nadir aerial images**;
  - in **rural and Alpine** terrain, the case the reviews name as hard;
  - evaluated on **real** imagery (SASGeo is synthetic only, OrienterNet is ground-level and urban).

  Our measured coverage limits ([[localization-levers-test]]) are exactly the "regions lacking semantic features" problem.
- **It gives baselines to compare against:** image-to-orthophoto matching (Kinnari, Goforth) for lever 7 in [[localization-improvements]].

## Pages touched
[[terrain-relative-navigation]], [[expose-material]], [[gnss-denied-use-cases]], [[localization-improvements]], [[overview]]

## Related
- [[terrain-relative-navigation]]
- [[costea-2016-aerial-geolocalization]]
- [[rural-geolocalization-search]]

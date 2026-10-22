---
title: Author's literature list — visual localisation without GNSS (manual findings)
type: source
tags: [literature, thesis, geolocalization, gnss-denied, uav]
sources: [author-literature-list]
raw: raw/2026-10-22-author-literature-list.rtf
updated: 2026-10-22
---
The author's own, manually researched bibliography of 27 works (28 lines, with one duplicate) on visual and terrain-relative localisation of UAVs and aircraft without GNSS. It is now the exposé bibliography (`expose/literatur.bib`).

## Summary
The list gives full bibliographic data with DOIs. Contents are known here only from titles and the earlier search results ([[vtrn-literature-search]], [[author-note-novelty]]). The author has the papers; the wiki has not read their full texts. It resolves one open point: **arXiv 2608.07835 is SeqLoc** (Zheng et al. 2026), the paper cited in [[author-note-novelty]] that the search could not find.

## Key claims (grouped by theme; titles only unless a page is cited)
- **Reviews:**
  - Couturier & Akhloufi 2021 (RAS 135:103666);
  - Jarraya et al. 2025 (Satellite Navigation 6:9), GNSS-denied UAV navigation: complexity, sensor fusion, localisation methods ([[author-literature-list]]).
- **Terrain-relative navigation, classic and aerospace:**
  - Castleberry & Martin 2021 (SPIE), VTRN at diverse altitudes;
  - Michaelson, Wang & Zanetti 2024 (IEEE TAES 60), TRN with neuro-inspired elevation encoding;
  - Silvestrini et al. 2022 (Aerospace 9:503), implicit EKF for optical TRN with delayed measurements ([[author-literature-list]]).
- **Image-to-orthophoto / satellite matching:**
  - Conte & Doherty 2009; Goforth & Lucey 2019 (ICRA);
  - Kinnari et al. 2021 (ICAR, pp. 555–562), 2022 (RA-L 7), 2023 (LSVL, RAS 168:104497);
  - Yao et al. 2024 (JAG 135:104277), terrain-weighted constraint optimisation;
  - Wang et al. 2026 (ISPRS Archives XLIX-B1);
  - Ye et al. 2026 (arXiv 2610.14945), DSM-free localisation ([[author-literature-list]], [[vtrn-literature-search]]).
- **Map / semantic / vector-map localisation**, closest to this thesis:
  - **Schleiss 2019** (ISPRS Archives XLII-2-W13, 575–580): translating aerial images into street-map-like representations for UAV self-localisation;
  - **Wei, Karakay & Yilmaz 2022** (arXiv 2208.12251): GIS-aided UAS geolocalisation with deep learning;
  - **Ouyang et al. 2024** (Defence Technology 34, 1–10): semantic vector map, building contours with a particle filter;
  - **Yuan et al. 2025, SWA-PF** (arXiv 2509.13795): semantic-weighted adaptive particle filter, 4-DoF;
  - Kunz et al. 2021 (LARS/SBR/WRE), OSM landmarks with a scene graph;
  - Sarlin et al. 2023, OrienterNet;
  - Trukhina & Vashkelis 2026, SASGeo (synthetic);
  - Terlizzi & Fathian 2026, geometric maps, urban;
  - Deng & Sentis 2026, AeroMap3D;
  - Dhaouadi et al. 2025, **OrthoLoC**: 6-DoF localisation and calibration from orthographic geodata ([[author-literature-list]], [[author-note-novelty]]).
- **Feature-sparse scenes and sequences:** **Zheng et al. 2026, SeqLoc** (arXiv 2608.07835): beyond the single frame, cross-view geo-localisation in feature-sparse scenes ([[author-literature-list]]).
- **Particle filters at low altitude:** Jurevičius 2019, Vilnius University ([[author-literature-list]]).
- **Datasets:** Xu et al. 2024, UAV-VisLoc ([[author-literature-list]]).

## Relevance to this wiki
- It is the verified literature base for the exposé ([[expose-material]], `expose/literatur.bib`). Earlier unverified candidates moved to `expose/kandidaten.bib`.
- Schleiss 2019, Wei 2022, Ouyang 2024 and SWA-PF are the nearest neighbours to object/semantic-map matching from nadir images. The novelty claim in [[thesis-contribution]] must be checked against their full texts.
- SeqLoc targets **feature-sparse scenes with multiple frames**, which is lever 4 (multi-frame accumulation) in [[localization-improvements]], and a direct comparison point for the coverage limit.

## Pages touched
[[author-note-novelty]], [[thesis-contribution]], [[expose-material]], [[terrain-relative-navigation]], [[localization-improvements]], [[overview]]

## Related
- [[author-note-novelty]]
- [[vtrn-literature-search]]
- [[thesis-contribution]]

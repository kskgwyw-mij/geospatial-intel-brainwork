---
title: Costea & Leordeanu 2016 — aerial geolocalisation via roads & intersections in OSM
type: source
tags: [geolocalization, osm, roads, matching, paper]
sources: [costea-2016-aerial-geolocalization]
raw: raw/2026-10-21-aerial-geolocalization-osm-search.md
updated: 2026-10-21
---
Published precedent for locating an aerial image by detecting objects (road intersections) and matching them to OSM, then aligning geometrically; plus evidence that object-level descriptors match about 648× faster than pixel features.

## Summary
Costea & Leordeanu (BMVC 2016, arXiv:1605.08323) detect roads and intersections in aerial
images, describe each intersection with a high-level descriptor, match it to OSM intersections
to find the candidate region, then refine by aligning the detected road network with the OSM
roads. Lin et al. (SPIE) match semantic object descriptors from UAV images to satellite imagery.
Details come from search snippets only.

## Key claims
- Stage 1, recognition: roads and intersections. Stage 2, retrieval: intersection descriptor matched to OSM. Stage 3, verification: geometric road-map alignment.
- Generalises across cities: trained on one European city, tested on another, accurately localised despite poor image quality.
- Semantic-level descriptors are orders of magnitude fewer than pixel descriptors, and matching was 648× faster (Lin et al.).

## Relevance to this wiki
This is the method template for [[osm-fingerprint-geolocalization]]: detected OSM-class objects become
a searchable fingerprint, then a geometric check confirms the match.

## Pages touched
[[osm-fingerprint-geolocalization]], [[overview]]

## Related
- [[osm-fingerprint-geolocalization]]

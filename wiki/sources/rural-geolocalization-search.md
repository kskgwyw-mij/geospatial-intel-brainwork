---
title: Rural / road-sparse geolocalisation (search notes)
type: source
tags: [geolocalization, rural, dem, land-cover, boundaries]
sources: [rural-geolocalization-search]
raw: raw/2026-10-21-rural-geolocalization-search.md
updated: 2026-10-21
---
Search-snippet evidence on locating aerial images where roads are sparse: DEM-based orthoprojection, land-cover boundary matching, and a rural benchmark subset.

## Summary
Three alternative cue families exist: **terrain (DEM)**, **land-cover boundaries** (fields,
rivers, vegetation edges) matched as simplified boundary maps, and **rural benchmark data**.

## Key claims
- DEM-orthoprojected UAV localisation: mean error about 26–31 m after 2 km of travel on three flights (idealised DEM).
- Natural land-cover edges are rarely smooth or continuous and are often hidden by trees and bushes (MVA 2007).
- Cadastral geolocation (2025): segment into land-cover classes, simplify to boundary maps, template-match against large maps; code is public.
- AirZoo-Real has a 190-image rural (agricultural) subset with satellite references.

## Relevance to this wiki
Gives the non-road cues for rural fingerprints in [[osm-fingerprint-geolocalization]]. The boundary-map
idea fits OSM `landuse`, `natural=wood` and `waterway` polygons and lines.

## Pages touched
[[osm-fingerprint-geolocalization]]

## Related
- [[osm-fingerprint-geolocalization]]
- [[author-note-rural-roads]]

---
title: OpenStreetMap
type: entity
tags: [osm, data]
sources: [thesis-goal]
updated: 2026-10-20
---
The crowd-sourced world map whose features define the object classes in this thesis.

- The thesis targets objects that already exist in OSM ([[thesis-goal]]).
- OSM data is nodes, ways and relations, each carrying key=value tags such as `building=yes` or `amenity=parking`. Tags are the natural source of class labels. (unsourced)
- Coverage and geometric accuracy vary by region and feature type, which matters when OSM is used as training labels; see [[osm-weak-labels]]. (unsourced)
- Data is licensed under ODbL. (unsourced)

## Related
- [[overpass-api]]
- [[overpass-turbo]]
- [[osm-weak-labels]]

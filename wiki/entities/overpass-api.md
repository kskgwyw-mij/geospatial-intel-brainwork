---
title: Overpass API
type: entity
tags: [osm, api, data]
sources: [settlement-overpass-labels, thesis-goal]
updated: 2026-10-21
---
Read-only query API for OpenStreetMap data; it is the backend that Overpass Turbo calls.

- Queries are written in Overpass QL and can filter by tag, bounding box or area. Output can be JSON, XML or geometry. (unsourced)
- Public instances enforce rate limits and timeouts, so large training-data pulls should be batched, cached, or run against a self-hosted instance. (unsourced)
- In the thesis pipeline it supplies the vector geometries of the target classes ([[thesis-goal]], [[thesis-poc-pipeline]]).

Element types, primary keys and query templates: [[osm-object-catalog]].

Pair-proximity queries (`around.<set>:<m>`) for fingerprint search: [[osm-fingerprint-geolocalization]].

## Settlement layer
`tools/overpass_settlements.py` turns one area query (buildings with `out center tags`, plus `place=*` nodes) into a 100 m grid of settlement / inhabited / built-only cells. Garmisch: 10,315 cells in one request. Busy mirrors answer 504, so retry with backoff ([[settlement-overpass-labels]], [[settlement-overpass]]).

## Related
- [[settlement-overpass]]
- [[osm-fingerprint-geolocalization]]
- [[osm-object-catalog]]
- [[overpass-turbo]]
- [[openstreetmap]]
- [[thesis-poc-pipeline]]

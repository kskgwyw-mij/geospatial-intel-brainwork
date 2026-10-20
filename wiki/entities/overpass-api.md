---
title: Overpass API
type: entity
tags: [osm, api, data]
sources: [thesis-goal]
updated: 2026-10-20
---
Read-only query API for OpenStreetMap data; it is the backend that Overpass Turbo calls.

- Queries are written in Overpass QL and can filter by tag, bounding box or area. Output can be JSON, XML or geometry. (unsourced)
- Public instances enforce rate limits and timeouts, so large training-data pulls should be batched, cached, or run against a self-hosted instance. (unsourced)
- In the thesis pipeline it supplies the vector geometries of the target classes ([[thesis-goal]], [[thesis-poc-pipeline]]).

## Related
- [[overpass-turbo]]
- [[openstreetmap]]
- [[thesis-poc-pipeline]]

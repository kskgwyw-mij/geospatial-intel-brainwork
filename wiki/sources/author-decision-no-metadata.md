---
title: Author decision — photo only, no metadata
type: source
tags: [scope, decision, geolocalization]
sources: [author-decision-no-metadata]
raw: raw/2026-10-21-author-decision-no-metadata.md
updated: 2026-10-21
---
Scope decision by the author: the method uses only the nadir photo itself; no GPS, heading, height or camera metadata.

## Summary
The input is a nadir photo with no usable metadata. Location, scale (GSD) and orientation (north) are all
unknown at inference time and must be recovered from image content.

## Key claims
- Only the photo is used, without metadata.

## Relevance to this wiki
- **Geolocation becomes a core step**, not an option: detect objects → find where (and at what scale and rotation)
  they match OSM → only then project OSM labels or report geo-objects ([[osm-fingerprint-geolocalization]]).
- Fingerprints must be **scale- and rotation-invariant**, or scale and rotation must be estimated from the image.
- `tools/osm_overlay.py --nadir` (which uses metadata) is no longer the inference path. It, and the orthophoto
  modes, remain useful for **building training data**, where georeferenced imagery is allowed.
- It amends [[author-decision-nadir-input]] and [[thesis-goal]].

## Pages touched
[[osm-fingerprint-geolocalization]], [[thesis-poc-pipeline]], [[poc-platform]], [[thesis-goal]], [[overview]], [[thesis-timeline]]

## Related
- [[author-decision-nadir-input]]
- [[osm-fingerprint-geolocalization]]

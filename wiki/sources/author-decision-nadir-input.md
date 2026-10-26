---
title: Author decision — nadir images suffice, ortho optional
type: source
tags: [scope, decision, imagery]
sources: [author-decision-nadir-input]
raw: raw/2026-10-21-author-decision-nadir-input.md
updated: 2026-10-21
---
Scope decision by the author: the method needs only nadir images; orthoimages would be ideal but are not required.

## Summary
The input requirement is relaxed from orthoimagery to **nadir images**: straight-down photos such as
drone frames or single aerial survey photos, without orthorectification. Orthophotos remain the ideal case.

## Key claims
- A nadir image is sufficient input. An orthoimage would be "perfect" but is not needed.

## Relevance to this wiki
It amends the input stated in [[thesis-goal]] ("orthoimagery"). Consequences:
- Approximate georeference must come from camera metadata (GPS position, heading, height, focal length). `tools/osm_overlay.py --nadir` handles this under a flat-ground assumption.
- Relief displacement and camera tilt remain in the image, so OSM labels shift more than on orthophotos ([[orthoimagery]], [[osm-weak-labels]]).
- Images without metadata need [[osm-fingerprint-geolocalization]], which becomes more central.

> [!note] Follow-up
> The peer review asks why the exposé focuses on nadir images only, since drones can also take oblique images or record metadata (A5, [[peer-review-expose]]). The exposé needs a short reason; points in [[expose-revision]].

## Pages touched
[[thesis-goal]], [[orthoimagery]], [[osm-weak-labels]], [[poc-platform]], [[thesis-poc-pipeline]], [[osm-fingerprint-geolocalization]], [[overview]]

## Related
- [[thesis-goal]]
- [[orthoimagery]]

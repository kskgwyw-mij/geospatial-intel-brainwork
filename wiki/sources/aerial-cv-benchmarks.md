---
title: Aerial CV benchmarks (DOTA, ISPRS, Inria)
type: source
tags: [computer-vision, datasets, benchmarks]
sources: [aerial-cv-benchmarks]
raw: raw/2026-10-20-aerial-cv-benchmarks-search.md
updated: 2026-10-20
---
Search-result facts about three standard aerial-imagery CV benchmarks: what classes they detect or segment, and at what resolution.

## Summary
DOTA (detection), ISPRS Potsdam/Vaihingen (semantic segmentation) and Inria (building
segmentation) show which object types computer vision is routinely benchmarked on in
aerial imagery. Facts come from search snippets, not the full papers.

## Key claims
- **DOTA v1.0**: 15 classes: plane, ship, storage tank, baseball diamond, tennis court, basketball court, ground track field, soccer-ball field, harbor, bridge, large vehicle, small vehicle, helicopter, roundabout, swimming pool. Uses oriented bounding boxes.
- **DOTA v1.5** adds container crane and objects under 10 px (402,089 instances). **v2.0** has 18 classes (adds airport, helipad), 11,268 images and 1,793,658 instances.
- **ISPRS Potsdam** (5 cm GSD, 38 tiles of 6000×6000 px) and **Vaihingen** (9 cm, near-infrared/red/green): 6 classes: impervious surface, building, low vegetation, tree, car, clutter.
- **Inria**: 30 cm RGB, 360 tiles of 5000×5000 px, 10 cities, building footprint masks.

## Relevance to this wiki
These are the reference points for which OSM classes are realistic in [[orthoimagery]]. Many
DOTA classes map one-to-one to OSM tags; see [[cv-detectability]]. They are also candidates for
pre-training before fine-tuning on [[osm-weak-labels]].

## Pages touched
[[cv-detectability]], [[object-detection]], [[semantic-segmentation]], [[osm-object-catalog]]

## Related
- [[cv-detectability]]
- [[object-detection]]
- [[semantic-segmentation]]

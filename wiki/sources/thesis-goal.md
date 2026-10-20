---
title: Thesis goal statement
type: source
tags: [thesis, scope]
sources: [thesis-goal]
raw: raw/2026-10-20-thesis-goal.md
updated: 2026-10-20
---
The author's own statement of the master thesis goal: an ML/DL method that recognises and classifies objects known to OpenStreetMap (via Overpass Turbo) in orthoimagery, shown in a proof-of-concept platform.

## Summary

The thesis, written in the [[hok-dsia-master]], has two deliverables:
1. A **recognition and classification method** (ML or DL) for objects that already exist in
   [[openstreetmap]] and can be queried with [[overpass-turbo]] / [[overpass-api]].
2. A **proof of concept** that applies the method to [[orthoimagery]] uploaded to a
   [[poc-platform]].

## Key claims

- The target objects are "Overpass Turbo existent objects": OSM features, so the classes come from OSM tags.
- The input imagery is orthoimagery (orthorectified aerial or satellite images).
- The task covers both *recognition* (finding/localising objects) and *classification* (assigning a class).
- Imagery is *uploaded* to the PoC platform, so the system has to run inference on images that users supply.

## Relevance to this wiki

This is the anchor for the whole wiki: every algorithm comparison should be judged against
these deliverables. See [[thesis-poc-pipeline]] for the working design.

## Open interpretation points

- Does "recognition" mean bounding boxes ([[object-detection]]), pixel masks ([[semantic-segmentation]]), or both?
- Is OSM used to **train** (as labels, see [[osm-weak-labels]]), to **verify** (compare predictions with OSM), or both?
- Which object classes, which region, which imagery provider and resolution?

## Pages touched
[[overview]], [[hok-dsia-master]], [[openstreetmap]], [[overpass-turbo]], [[overpass-api]],
[[orthoimagery]], [[poc-platform]], [[object-detection]], [[semantic-segmentation]],
[[osm-weak-labels]], [[thesis-poc-pipeline]]

## Related
- [[overview]]
- [[thesis-poc-pipeline]]

---
title: OSM as weak labels
type: concept
tags: [labels, weak-supervision, osm]
sources: [thesis-goal, maggiori-osm-imperfect-labels]
updated: 2026-10-20
---
Using OSM geometries pulled through Overpass as (noisy) training labels for orthoimagery, instead of annotating by hand.

- The thesis targets objects that exist in OSM, so OSM can serve as the label source ([[thesis-goal]]).
- Polygons become segmentation masks or instance masks; their bounding boxes become detection labels; points (for example `power=tower`) need a box size or a point-based method. (unsourced)
- Known noise sources: misalignment between OSM and the imagery (offsets of a few metres), missing objects (false negatives in the labels), objects that are outdated relative to the image date, and inconsistent tagging. (unsourced)
- Published precedent: pretrain an FCN on large imperfect OSM labels, then refine on a small accurate set. OSM alone teaches only rough locations because of misregistration and omissions ([[maggiori-osm-imperfect-labels]]).
- Common mitigations: pick regions known to be well mapped, check a sample by hand to estimate label quality, keep a small hand-corrected test set, and use loss functions or training schemes that tolerate noise. (unsourced)

## Related
- [[maggiori-osm-imperfect-labels]]
- [[openstreetmap]]
- [[orthoimagery]]
- [[object-detection]]
- [[semantic-segmentation]]
- [[thesis-poc-pipeline]]

---
title: Semantic segmentation
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal]
updated: 2026-10-20
---
Assigning a class to every pixel; the other reading of "recognition" in the thesis, best for area features.

- Fits areal or linear OSM features (buildings, roads, water, land use), where a box is a poor description ([[thesis-goal]]).
- Candidate models: U-Net and its variants, DeepLabv3+, SegFormer; geospatial foundation-model backbones can be fine-tuned. (unsourced)
- Masks can be vectorised (polygonised) back into GeoJSON for the [[poc-platform]] and for comparison with OSM. (unsourced)
- Usual metrics: IoU and F1 per class; for buildings, also object-level metrics after polygonisation. (unsourced)

## Related
- [[object-detection]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

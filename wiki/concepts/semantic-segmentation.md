---
title: Semantic segmentation
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal, aerial-cv-benchmarks, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-20
---
Assigning a class to every pixel; the other reading of "recognition" in the thesis, best for area features.

- Fits areal or linear OSM features (buildings, roads, water, land use), where a box is a poor description ([[thesis-goal]]).
- **Recognition vs. localisation:** pooling buys robustness but loses boundary precision. Architectures that address this are dilation, deconvolution/unpooling, skip, and multi-resolution feature fusion ("MLP"). The MLP net reaches 88.92 % OA / 86.58 mean F1 on Vaihingen and was 2nd of 29 on the ISPRS test (OA 89.5), with a small 4-block FCN on a 4 GB GPU ([[maggiori-2017-hr-semantic-labeling]]).
- **Combine features, not class scores,** across resolutions, and use context at coarse resolution far from the pixel and fine resolution near it ([[maggiori-2017-hr-semantic-labeling]]).
- Adding a DSM as an extra input band is straightforward ([[maggiori-2017-hr-semantic-labeling]]).
- Report mean F1 next to overall accuracy: on Vaihingen, car F1 ranges 69–78 across architectures while OA moves only 88.6–88.9 ([[maggiori-2017-hr-semantic-labeling]]).
- Candidate models: U-Net and its variants, DeepLabv3+, SegFormer; geospatial foundation-model backbones can be fine-tuned. (unsourced)
- Masks can be vectorised (polygonised) back into GeoJSON for the [[poc-platform]] and for comparison with OSM. (unsourced)
- Benchmarks: ISPRS Potsdam (5 cm) and Vaihingen (9 cm) with 6 classes (impervious surface, building, low vegetation, tree, car, clutter); Inria (30 cm) for building footprints ([[aerial-cv-benchmarks]]).
- Usual metrics: IoU and F1 per class; for buildings, also object-level metrics after polygonisation. (unsourced)

## Related
- [[maggiori-2017-hr-semantic-labeling]]
- [[cv-detectability]]
- [[object-detection]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

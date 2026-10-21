---
title: Semantic segmentation
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal, aerial-cv-benchmarks, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-20
---
Assigning a class to every pixel; the other reading of "recognition" in the thesis, best for area features.

- Fits areal or linear OSM features (buildings, roads, water, land use), where a box is a poor description ([[thesis-goal]]).
- **Recognition vs. localisation:** classification CNNs give up spatial precision; aerial labelling needs both. Maggiori et al. combine FCN features from several resolutions with an MLP and beat FCN, unpooling and skip variants on Vaihingen and Potsdam ([[maggiori-2017-hr-semantic-labeling]]).
- Report mean F1 next to overall accuracy, because accuracy hides minority classes ([[maggiori-2017-hr-semantic-labeling]]).
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

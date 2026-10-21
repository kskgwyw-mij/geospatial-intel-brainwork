---
title: Maggiori et al. 2017 — High-Resolution Semantic Labeling with CNNs
type: source
tags: [semantic-segmentation, cnn, multi-scale, paper]
sources: [maggiori-2017-hr-semantic-labeling]
raw: raw/2026-10-21-maggiori-papers-search.md
updated: 2026-10-21
---
A paper proposing a CNN for per-pixel labelling of aerial imagery that learns features at several resolutions and combines them with an MLP, to get both recognition and precise boundaries.

## Summary
Maggiori, Tarabalka, Charpiat and Alliez, IEEE TGRS 55(12):7092–7103, 2017 (arXiv:1611.01962).
Classification CNNs are designed to tolerate small deformations, which costs the spatial
precision that dense labelling needs. The paper starts from a fully convolutional network
(FCN), extracts features at several resolutions, and learns how to combine them with a
multi-layer perceptron. That gives global context and fine localisation together.
Details were taken from search snippets only; the full text was not read.

## Key claims
- Task = dense semantic labelling: one class per pixel ([[semantic-segmentation]]).
- Four variants were compared: base FCN, unpooling, skip connections, and the proposed **MLP** multi-scale combination.
  The MLP network is best "in almost every case" on the ISPRS Vaihingen and Potsdam validation sets
  ([[aerial-cv-benchmarks]]), while being simpler and smaller than many competing methods.
- Training: the variants are initialised from a pretrained base FCN and retrained jointly (lr 0.01; 30k / 65k iterations for Vaihingen / Potsdam).
- Metrics: overall accuracy plus **mean F1**, because accuracy hides minority classes in imbalanced data.
- Exact accuracy numbers: not yet retrieved.

## Relevance to this wiki
- It is a direct method candidate for the segmentation branch of the thesis: buildings, land
  use, roads, trees. The output is a class per pixel; because [[orthoimagery]] is
  georeferenced, every labelled pixel has coordinates and can be polygonised into GeoJSON for
  the [[poc-platform]] and compared with OSM.
- It does **not** find where an unknown image was taken (image geolocalisation). It labels what is at each location in an already georeferenced image.
- The multi-scale idea is now standard in U-Net, FPN and DeepLab-type models. A modern
  equivalent should be the main model, with this paper cited as the motivation. (unsourced)
- The same group trained CNNs on OSM labels; see [[maggiori-osm-imperfect-labels]].

## Pages touched
[[semantic-segmentation]], [[cv-detectability]], [[thesis-poc-pipeline]], [[overview]]

## Related
- [[semantic-segmentation]]
- [[maggiori-osm-imperfect-labels]]
- [[aerial-cv-benchmarks]]

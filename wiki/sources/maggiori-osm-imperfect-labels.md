---
title: Maggiori et al. — CNNs for large-scale classification with imperfect OSM labels
type: source
tags: [weak-supervision, osm, cnn, paper]
sources: [maggiori-osm-imperfect-labels]
raw: raw/2026-10-21-maggiori-papers-search.md
updated: 2026-10-21
---
A paper that trains a fully convolutional network on large, inaccurate OpenStreetMap labels, then refines it on a small accurate set: the closest published precedent to this thesis's label strategy.

## Summary
Maggiori, Tarabalka, Charpiat and Alliez, IEEE TGRS (2016/2017), "Convolutional Neural
Networks for Large-Scale Remote-Sensing Image Classification". Pixelwise satellite-image
classification with an end-to-end FCN, trained in two steps: **pretrain on large imperfect OSM
labels, then fine-tune on a small, manually corrected set**. Details come from search snippets only.

## Key claims
- Two-step training (pretrain on noisy OSM, refine on accurate labels) handles label noise.
- OSM gives free global coverage, but misregistrations and omissions are common, so CNNs trained on OSM alone learn only rough object locations.
- Related: Kaiser et al. found noisy large-scale OSM training data reaches satisfying building and road segmentation. Comandur & Kak (2021) used noisy OSM labels for large-area building and road labelling.

## Relevance to this wiki
This is the precedent for [[osm-weak-labels]] and a template for the thesis method and
research question: *how much does a small hand-corrected set improve a model pretrained on
Overpass-derived labels?*

## Pages touched
[[osm-weak-labels]], [[thesis-poc-pipeline]], [[thesis-timeline]], [[overview]]

## Related
- [[osm-weak-labels]]
- [[maggiori-2017-hr-semantic-labeling]]

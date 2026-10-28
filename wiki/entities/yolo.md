---
title: YOLO (You Only Look Once)
type: entity
tags: [object-detection, deep-learning, single-shot-detector, oriented-boxes]
sources: [sojasingarayar-2022-detector-comparison, pretrained-models-search, real-e2e-test, aerial-cv-benchmarks]
updated: 2026-10-28
---
The single-shot detector family that predicts boxes and classes for the whole image in one pass over a grid; its current Ultralytics version YOLO11-OBB, with oriented boxes and DOTA weights, is the thesis's detector for pools, tanks and pitches.

## How it works
- The image is split into a grid. Each cell predicts the boxes whose centre falls inside it (x, y, width, height, confidence) and class probabilities, all in one look at the image ([[sojasingarayar-2022-detector-comparison]]).
- No separate proposal stage, hence fast. Claimed strengths: real-time speed and few background errors ([[sojasingarayar-2022-detector-comparison]]).

## Numbers
- **Original YOLO (2016), Pascal VOC 2007:** 45 fps in the blog text, "Fast YOLO" 155 fps. The comparison chart gives 66 % mAP at 21 fps with a VGG16 backbone, below Faster R-CNN (73 %) and SSD300 (74 %) ([[sojasingarayar-2022-detector-comparison]]).

  > [!warning] Contradiction (within the source)
  > 45 fps in the text vs 21 fps in the chart of [[sojasingarayar-2022-detector-comparison]]; probably different backbones (unsourced). Use the original paper for exact numbers.

- **YOLO11-OBB (Ultralytics), DOTAv1 test at 1024 px:** nano 78.4 mAP50 (2.7 M parameters), large 81.0 mAP50 (about 26 M parameters); the weights download automatically ([[pretrained-models-search]]). DOTA uses oriented boxes and includes storage tanks, swimming pools, tennis courts and other pitches ([[aerial-cv-benchmarks]]).
- **YOLO11s-OBB in this project, zero-shot on real DOP20 crops:** precision 0.49 and recall 0.62 against OSM at 40 sites near mapped objects; small pools and some courts are missed ([[real-e2e-test]]).

## Relevance to this thesis
- Chosen detector for the point classes, fine-tuned from the DOTA weights on OSM labels ([[pretrained-models]], [[methods-10-25cm]]). Reasons in the wiki: the classes already exist in DOTA, oriented boxes fit top-down imagery, and the model is fast (about 8 s per photo on CPU including the WMS download, [[real-e2e-test]]).
- The 2016 comparison shows the original YOLO trading accuracy for speed ([[sojasingarayar-2022-detector-comparison]]). Whether that still holds for YOLO11 against two-stage oriented detectors on DOTA is not in the wiki's sources (gap); the exposé should justify the choice with current numbers, not the 2016 chart.
- Original paper: Redmon, Divvala, Girshick & Farhadi, *You Only Look Once: Unified, Real-Time Object Detection*, CVPR 2016, 779–788; metadata verified via Crossref, entry `redmon2016yolo` in `expose/ergaenzungen.bib`, content not read. Software: `ultralytics2024yolo11` in `expose/kandidaten.bib`.

## Related
- [[object-detection]]
- [[faster-r-cnn]]
- [[ssd-detector]]
- [[pretrained-models]]
- [[real-e2e-test]]
- [[sojasingarayar-2022-detector-comparison]]

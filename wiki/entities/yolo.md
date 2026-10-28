---
title: YOLO (You Only Look Once)
type: entity
tags: [object-detection, deep-learning, single-shot-detector, oriented-boxes]
sources: [sojasingarayar-2022-detector-comparison, pretrained-models-search, real-e2e-test, aerial-cv-benchmarks, yolo-small-aerial-search]
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

- **YOLO11-OBB (Ultralytics), DOTAv1 test at 1024 px:** nano 78.4 mAP50 (2.7 M parameters), large 81.0 mAP50 (about 26 M parameters); the weights download automatically ([[pretrained-models-search]]). Speed per 1024 px tile: n 4.4 ms on a T4 GPU (TensorRT) and 117.6 ms on CPU (ONNX); x 81.3 mAP50 at 28.6 ms. The newest YOLO26n-obb: 78.9 mAP50 at 2.8 ms (T4). For comparison, the two-stage Oriented R-CNN: 75.87 % mAP at about 66 ms on an RTX 2080Ti (vendor docs vs peer-reviewed; [[yolo-small-aerial-search]]). DOTA uses oriented boxes and includes storage tanks, swimming pools, tennis courts and other pitches ([[aerial-cv-benchmarks]]).
- **Drone imagery, VisDrone-DET2019 (peer-reviewed):** YOLO11 n–x 32.0–46.1 % mAP@0.5 at 330–38 FPS; YOLO11s 42 FPS on an embedded Jetson Orin NX ([[yolo-small-aerial-search]]).
- **Limit:** current YOLOs reach only single-digit to low-teen AP on very tiny objects in AI-TOD (mean size about 12.8 px). Objects under about 16 px are the documented weak spot (preprints; [[yolo-small-aerial-search]]).
- **YOLO11s-OBB in this project, zero-shot on real DOP20 crops:** precision 0.49 and recall 0.62 against OSM at 40 sites near mapped objects; small pools and some courts are missed ([[real-e2e-test]]).

## Relevance to this thesis
- Chosen detector for the point classes, fine-tuned from the DOTA weights on OSM labels ([[pretrained-models]], [[methods-10-25cm]]). Reasons in the wiki: the classes already exist in DOTA, oriented boxes fit top-down imagery, and the model is fast (about 8 s per photo on CPU including the WMS download, [[real-e2e-test]]).
- The 2016 comparison shows the original YOLO trading accuracy for speed ([[sojasingarayar-2022-detector-comparison]]). That no longer holds: on DOTA, YOLO-OBB is faster and at least as accurate as a two-stage oriented detector, and the thesis classes (pools 15–60 px, tanks 15–200 px at 0.2 m) lie above the tiny-object range where YOLO fails ([[yolo-small-aerial-search]]). Decision, evidence levels and citations: [[detector-choice]].
- Original paper: Redmon, Divvala, Girshick & Farhadi, *You Only Look Once: Unified, Real-Time Object Detection*, CVPR 2016, 779–788; metadata verified via Crossref, entry `redmon2016yolo` in `expose/ergaenzungen.bib`, content not read. Software: `ultralytics2024yolo11` in `expose/kandidaten.bib`.

## Related
- [[detector-choice]]
- [[yolo-small-aerial-search]]
- [[object-detection]]
- [[faster-r-cnn]]
- [[ssd-detector]]
- [[pretrained-models]]
- [[real-e2e-test]]
- [[sojasingarayar-2022-detector-comparison]]

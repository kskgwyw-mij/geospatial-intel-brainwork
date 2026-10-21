---
title: Pretrained models for aerial imagery (search notes)
type: source
tags: [pretrained, foundation-models, transfer-learning]
sources: [pretrained-models-search]
raw: raw/2026-10-21-pretrained-models-search.md
updated: 2026-10-21
---
Search-snippet facts on three families of ready-to-use pretrained weights for aerial imagery: TorchGeo/SatlasPretrain backbones, Ultralytics YOLO11-OBB detectors pretrained on DOTA, and the DINOv3 satellite backbone.

## Summary
Pretrained aerial-imagery weights exist for backbones (Satlas Swin V2 and ResNet), detectors (YOLO11-OBB
on DOTAv1) and self-supervised foundation features (DINOv3 SAT-493M, Maxar 0.6 m).

## Key claims
- TorchGeo ships Satlas **Swin V2-B NAIP RGB** weights (single-image and multi-image). SatlasPretrain also offers Swin-v2-Tiny, ResNet50 and ResNet152 backbones. No NAIP ResNet was found in TorchGeo.
- **YOLO11-OBB** weights pretrained on DOTAv1 download automatically: nano 78.4 mAP50 (2.7 M params), large 81.0 mAP50 (about 26 M params) on the DOTAv1 test set at 1024 px.
- **DINOv3 SAT-493M:** a self-supervised backbone trained on 493 M Maxar RGB orthophoto crops at **0.6 m**; sizes from 21 M to 6.7 B params; strong on GEO-Bench.

## Relevance to this wiki
These are the starting points for fine-tuning in [[pretrained-models]]. None is trained at
10–25 cm, so fine-tuning on local imagery stays necessary ([[methods-10-25cm-search]]).

## Pages touched
[[pretrained-models]], [[methods-10-25cm]], [[osm-fingerprint-geolocalization]]

## Related
- [[pretrained-models]]

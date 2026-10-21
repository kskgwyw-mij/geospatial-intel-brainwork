---
title: Pretrained CNNs & foundation models for the thesis
type: analysis
tags: [pretrained, transfer-learning, foundation-models, decision]
sources: [pretrained-models-search, methods-10-25cm-search, maggiori-2017-hr-semantic-labeling, aerial-cv-benchmarks]
updated: 2026-10-21
---
Which pretrained networks exist for each part of the thesis (detection, segmentation, classification, geolocation), what they were trained on, and how to fine-tune them on Overpass-labelled 10–25 cm orthophotos.

## Why pretrained
Training from scratch needs large labelled sets. Fine-tuning pretrained weights needs far fewer
labels and less GPU time, which suits a part-time thesis. Even the 2017 aerial-labelling work found
pretrained initialisation better than training from scratch ([[maggiori-2017-hr-semantic-labeling]]).

## Catalogue by role

| Role | Pretrained model | Trained on | Ready for | Evidence |
|---|---|---|---|---|
| **Detector (oriented boxes)** | Ultralytics **YOLO11-OBB** (n…x) | DOTAv1: planes, ships, **storage tanks**, **swimming pools**, **tennis, basketball and soccer pitches**, track fields, vehicles… | Pools, tanks, pitches. The nano model scores 78.4 mAP50 with 2.7 M params | [[pretrained-models-search]], [[aerial-cv-benchmarks]] |
| **Tree detector** | **DeepForest** (RetinaNet) | More than 30 M auto-generated + 10k hand-labelled crowns, airborne RGB | Single trees | [[methods-10-25cm-search]] |
| **Zero-shot segmenter** | **SAM / SAM2**, **Grounded-SAM** (text → boxes → masks) | Natural images | Mask refinement from boxes; label cleaning; baseline. Grounded-SAM: F1 0.83 on WHU buildings | [[methods-10-25cm-search]] |
| **Aerial backbone** | **SatlasPretrain** Swin V2-B/T, ResNet50/152 (via TorchGeo) | Sentinel-2 + NAIP aerial RGB | Encoder for U-Net/FPN segmentation (buildings, PV, land use) | [[pretrained-models-search]] |
| **Foundation features** | **DINOv3 SAT-493M** (ViT 21 M–6.7 B, ConvNeXt) | 493 M Maxar RGB orthophoto crops at 0.6 m, self-supervised | Frozen features for segmentation or classification; **retrieval descriptors for fingerprints** | [[pretrained-models-search]] |
| **Generic CNNs** | ImageNet ResNet, EfficientNet, ConvNeXt (torchvision, timm) | Natural photos | Roof-shape and sport crop classifiers; U-Net encoders | (unsourced) |
| **Segmentation frameworks** | segmentation_models_pytorch (U-Net/DeepLab with pretrained encoders), SegFormer | ImageNet / ADE20K | Quick U-Net baselines | (unsourced) |

## Per thesis task
- **Buildings & solar (segmentation):** a U-Net or FPN with a SatlasPretrain Swin or DINOv3-satellite encoder; plain ImageNet ResNet as the cheap baseline. Fine-tune on Overpass masks ([[osm-weak-labels]]).
- **Pools, tanks, pitches (detection):** fine-tune **YOLO11-OBB from the DOTA weights**. These classes are already in DOTA, so it is the smallest step from pretrained model to thesis model.
- **Trees:** DeepForest as is, then fine-tune on local crowns.
- **Roof shape and sport (classification):** an ImageNet EfficientNet or ResNet on crops; the domain-pretrained variant is in [[methods-10-25cm-search]].
- **Geolocation fingerprint:** use **DINOv3-satellite embeddings** of the neighbourhood as the retrieval descriptor, instead of training an AlexNet descriptor as in [[costea-2016-aerial-geolocalization]]. Verify geometrically as before ([[osm-fingerprint-geolocalization]]). (unsourced)

## Caveat: resolution mismatch
None of these was trained at 10–25 cm:
- DINOv3-sat uses 0.6 m Maxar imagery ([[pretrained-models-search]]);
- DOTA images come at mixed resolutions (unsourced);
- models do not transfer across resolutions without fine-tuning ([[methods-10-25cm-search]]).

Options: fine-tune at your GSD, or resample tiles so objects have their pretraining pixel size
(for example 25 cm imagery downsampled ×2 to about 0.5 m for a 0.6 m backbone; small objects suffer). (unsourced)

## Suggested minimal stack
1. YOLO11-OBB (DOTA weights), fine-tuned on Overpass pools, tanks and pitches.
2. U-Net with a Satlas or DINOv3 encoder, fine-tuned on Overpass buildings.
3. An EfficientNet crop classifier for `roof:shape`.
4. SAM2 for box-to-mask refinement and label cleaning.

All are open and PyTorch-based; check each licence before using it in the [[poc-platform]]. (unsourced)

## Related
- [[methods-10-25cm]]
- [[osm-fingerprint-geolocalization]]
- [[object-detection]]
- [[semantic-segmentation]]
- [[pretrained-models-search]]

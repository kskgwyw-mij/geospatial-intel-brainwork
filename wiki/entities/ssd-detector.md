---
title: SSD (Single Shot MultiBox Detector)
type: entity
tags: [object-detection, deep-learning, single-shot-detector]
sources: [sojasingarayar-2022-detector-comparison]
updated: 2026-10-28
---
A single-shot object detector that predicts classes and box offsets for default boxes directly on several feature maps of different scales; in the 2016 comparison it was the only detector above 70 % mAP at real-time speed (74 % at 46 fps).

## How it works
- No separate region-proposal network: boxes and classes come from feature maps in one pass ([[sojasingarayar-2022-detector-comparison]]).
- Two parts: extract feature maps, then apply small convolution filters that predict class scores and offsets to **default boxes** ([[sojasingarayar-2022-detector-comparison]]).
- Separate filters per aspect ratio, and **multi-scale feature maps**, so objects of different sizes are detected on different layers ([[sojasingarayar-2022-detector-comparison]]).
- Trained end to end; makes more predictions with better coverage of location, scale and aspect ratio ([[sojasingarayar-2022-detector-comparison]]).

## Numbers
- **SSD300, Pascal VOC 2007 test** (VGG16, batch size 1, Titan X): 74 % mAP at 46 fps, 6.6× faster than Faster R-CNN (73 %, 7 fps) and more accurate than YOLO (66 %) ([[sojasingarayar-2022-detector-comparison]]).

## Relevance to this thesis
- Its multi-scale feature maps address the same issue as small objects in DOP20: a 6 m pool covers about 30 px at 0.2 m (unsourced estimate, see [[cv-detectability]]). Modern YOLO versions also predict at several scales (unsourced).
- Not a candidate in the wiki's current plan, which uses YOLO11-OBB because of its DOTA weights and oriented boxes ([[pretrained-models]]). It belongs in the exposé only as background for the single-shot family.
- Original paper: Liu, Anguelov, Erhan, Szegedy, Reed, Fu & Berg, *SSD: Single Shot MultiBox Detector*, ECCV 2016, LNCS 9905, 21–37; metadata verified via Crossref, entry `liu2016ssd` in `expose/ergaenzungen.bib`, content not read.

## Related
- [[object-detection]]
- [[yolo]]
- [[faster-r-cnn]]
- [[cv-detectability]]
- [[sojasingarayar-2022-detector-comparison]]

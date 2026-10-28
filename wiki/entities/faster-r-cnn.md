---
title: Faster R-CNN
type: entity
tags: [object-detection, deep-learning, two-stage-detector]
sources: [sojasingarayar-2022-detector-comparison, methods-10-25cm-search]
updated: 2026-10-28
---
The classic two-stage object detector: a Region Proposal Network suggests where objects may be, and a Fast R-CNN head classifies each proposal and refines its box; accurate but slower than single-shot detectors.

## How it works
- Two modules on one shared CNN feature map ([[sojasingarayar-2022-detector-comparison]]):
  1. **Region Proposal Network (RPN):** proposes candidate regions;
  2. **Fast R-CNN head:** extracts features from each proposal and outputs the bounding box and class label.
- The RPN works like an attention mechanism for the head. It replaced the slow external proposal step of its predecessors and gives the model its name ([[sojasingarayar-2022-detector-comparison]]).
- Lineage: R-CNN → Fast R-CNN → Faster R-CNN. Many later models reuse its RPN or its head, including segmentation and 3D detectors ([[sojasingarayar-2022-detector-comparison]]); Mask R-CNN, which [[methods-10-25cm]] lists for building footprints, is one such extension (unsourced).

## Numbers
Pascal VOC 2007 test, VGG16 backbone, batch size 1, Titan X ([[sojasingarayar-2022-detector-comparison]]):

| Model | mAP | fps |
|---|---|---|
| R-CNN | 66 % | 0.02 |
| Fast R-CNN | 70 % | 0.4 |
| **Faster R-CNN** | **73 %** | **7** |
| SSD300 (single-shot, for comparison) | 74 % | 46 |

## Relevance to this thesis
- A candidate alternative to the YOLO-type detector for pools, pitches and tanks ([[methods-10-25cm]]). On the 2016-era comparison, the single-shot [[ssd-detector]] matched its accuracy at 6.6× the speed, so speed alone does not argue for it.
- Oriented-box variants for aerial imagery and DOTA results are not in the wiki's sources yet (gap). The thesis currently uses YOLO11-OBB ([[pretrained-models]], [[real-e2e-test]]).
- Original paper: Ren, He, Girshick & Sun, *Faster R-CNN: Towards Real-Time Object Detection with Region Proposal Networks*, IEEE TPAMI 39(6), 1137–1149, 2017 (NeurIPS version 2015); metadata verified via Crossref, entry `ren2017fasterrcnn` in `expose/ergaenzungen.bib`, content not read.

## Related
- [[object-detection]]
- [[yolo]]
- [[ssd-detector]]
- [[methods-10-25cm]]
- [[sojasingarayar-2022-detector-comparison]]

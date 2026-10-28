---
title: Object detection
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal, aerial-cv-benchmarks, methods-10-25cm-search, sojasingarayar-2022-detector-comparison, pretrained-models-search, real-e2e-test, yolo-small-aerial-search]
updated: 2026-10-28
---
Finding each object in an image and returning a bounding box plus a class; one reading of "recognition and classification" in the thesis.

- **Definition:** localisation (where each object is) plus classification (which class it belongs to) ([[sojasingarayar-2022-detector-comparison]]).
- Fits countable, compact objects such as vehicles, pools, wind turbines and storage tanks ([[thesis-goal]] asks for recognition and classification).

## Detector families
- **Two-stage:** a proposal step suggests regions, a second network classifies them and refines the boxes. Line: R-CNN → Fast R-CNN → [[faster-r-cnn]], whose Region Proposal Network made proposals part of the network ([[sojasingarayar-2022-detector-comparison]]).
- **Single-shot:** boxes and classes in one pass, no proposal stage. [[yolo]] predicts per grid cell; [[ssd-detector]] predicts offsets to default boxes on several feature maps of different scales ([[sojasingarayar-2022-detector-comparison]]).
- **Speed vs accuracy, Pascal VOC 2007** (VGG16, batch size 1, Titan X; [[sojasingarayar-2022-detector-comparison]]):

  | Detector | Type | mAP | fps |
  |---|---|---|---|
  | R-CNN | two-stage | 66 % | 0.02 |
  | Fast R-CNN | two-stage | 70 % | 0.4 |
  | Faster R-CNN | two-stage | 73 % | 7 |
  | YOLO | single-shot | 66 % | 21 |
  | SSD300 | single-shot | 74 % | 46 |

  In this 2016-era comparison, single-shot SSD matched two-stage accuracy at 6.6× the speed. The numbers come from a blog that quotes the SSD authors; YOLO's speed is inconsistent within it (45 fps in the text, 21 fps in the chart), see [[yolo]].
- **Today, on aerial imagery:** YOLO11-OBB (78.4–81.3 mAP50 on DOTA, 4.4–28.6 ms per 1024 px tile on a T4) is faster and at least as accurate as the two-stage Oriented R-CNN (75.87 % mAP, about 66 ms), so the 2016 trade-off no longer holds ([[yolo-small-aerial-search]], [[detector-choice]]).
- Other families: RetinaNet (one-stage with focal loss) and transformer detectors (DETR variants) (unsourced).
- **Small objects:** COCO counts objects under 32² px as small; current YOLOs fail mainly on very tiny objects under about 16 px (AI-TOD) ([[yolo-small-aerial-search]]). At 0.2 m the thesis classes are larger ([[detector-choice]]).
- **Oriented boxes:** rotated-box variants suit top-down imagery; DOTA labels oriented boxes ([[aerial-cv-benchmarks]]). The thesis uses YOLO11-OBB with DOTA weights: nano 78.4 mAP50 on DOTAv1 ([[pretrained-models-search]]); zero-shot on DOP20 precision 0.49, recall 0.62 against OSM ([[real-e2e-test]]).
- Instance segmentation (Mask R-CNN and similar) produces boxes and masks together, which suits buildings (unsourced).

## Data, metrics, tools
- Benchmark: DOTA uses oriented boxes over 15 classes (v1.0) to 18 (v2.0), including storage tanks, swimming pools, tennis courts and vehicles; v2.0 has 1,793,658 instances ([[aerial-cv-benchmarks]]). The VOC 2007 numbers above are from ground-level photos, not aerial imagery, so they do not transfer directly (unsourced).
- Trees: DeepForest is a pretrained RetinaNet crown detector. Detector boxes also work as prompts for SAM2 masks ([[methods-10-25cm-search]]). Per-class choice: [[methods-10-25cm]].
- Usual metrics: mAP at IoU 0.5 and mAP over IoU 0.5:0.95 (unsourced).

## Related
- [[detector-choice]]
- [[faster-r-cnn]]
- [[yolo]]
- [[ssd-detector]]
- [[methods-10-25cm]]
- [[pretrained-models]]
- [[cv-detectability]]
- [[semantic-segmentation]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

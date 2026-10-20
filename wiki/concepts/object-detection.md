---
title: Object detection
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal, aerial-cv-benchmarks]
updated: 2026-10-20
---
Finding each object in an image and returning a bounding box plus a class; one reading of "recognition and classification" in the thesis.

- Fits countable, compact objects such as vehicles, pools, wind turbines and storage tanks ([[thesis-goal]] asks for recognition and classification).
- Candidate families: one-stage detectors (the YOLO family, RetinaNet), two-stage detectors (Faster R-CNN), transformer detectors (DETR variants). Rotated-box variants help for top-down imagery. (unsourced)
- Instance segmentation (Mask R-CNN and similar) produces boxes and masks together, which suits buildings. (unsourced)
- Benchmark: DOTA uses oriented boxes over 15 classes (v1.0) to 18 (v2.0), including storage tanks, swimming pools, tennis courts and vehicles; v2.0 has 1,793,658 instances ([[aerial-cv-benchmarks]]).
- Usual metrics: mAP at IoU 0.5 and mAP over IoU 0.5:0.95. (unsourced)

## Related
- [[cv-detectability]]
- [[semantic-segmentation]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

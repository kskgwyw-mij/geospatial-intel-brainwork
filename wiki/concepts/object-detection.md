---
title: Object detection
type: concept
tags: [deep-learning, computer-vision]
sources: [thesis-goal]
updated: 2026-10-20
---
Finding each object in an image and returning a bounding box plus a class; one reading of "recognition and classification" in the thesis.

- Fits countable, compact objects such as vehicles, pools, wind turbines and storage tanks ([[thesis-goal]] asks for recognition and classification).
- Candidate families: one-stage detectors (the YOLO family, RetinaNet), two-stage detectors (Faster R-CNN), transformer detectors (DETR variants). Rotated-box variants help for top-down imagery. (unsourced)
- Instance segmentation (Mask R-CNN and similar) produces boxes and masks together, which suits buildings. (unsourced)
- Usual metrics: mAP at IoU 0.5 and mAP over IoU 0.5:0.95. (unsourced)

## Related
- [[semantic-segmentation]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

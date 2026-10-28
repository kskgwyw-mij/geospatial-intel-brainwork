---
title: Detector choice — why YOLO-OBB for small objects in DOP20, and its limits
type: analysis
tags: [object-detection, yolo, decision, small-objects, evaluation]
sources: [yolo-small-aerial-search, sojasingarayar-2022-detector-comparison, pretrained-models-search, real-e2e-test, aerial-cv-benchmarks, methods-10-25cm-search]
updated: 2026-10-28
---
A decision guide for FF1: the evidence that a current YOLO-OBB detects the thesis classes in 0.2 m orthophotos fast and accurately enough, what each piece of evidence is worth, where the method is known to fail, and which sources the exposé can cite.

## Decision
Keep **YOLO11-OBB** (or its successor YOLO26-OBB) with DOTA weights, fine-tuned on OSM labels, as the detector for pools, tennis and soccer pitches, tracks and tanks ([[pretrained-models]]). Buildings need a separate segmentation model, because DOTA has no building class ([[aerial-cv-benchmarks]]).

## Evidence
### 1. Speed at DOTA-level accuracy
| Detector | Type | DOTA mAP(50) | Time per 1024 px tile | Hardware | Evidence |
|---|---|---|---|---|---|
| YOLO11n-obb | single-shot, oriented | 78.4 | 4.4 ms GPU / 117.6 ms CPU | T4 TensorRT10 / CPU ONNX | vendor docs |
| YOLO11s-obb | single-shot, oriented | 79.5 | 5.1 ms / 219.4 ms | T4 / CPU | vendor docs |
| YOLO11x-obb | single-shot, oriented | 81.3 | 28.6 ms / 1408.6 ms | T4 / CPU | vendor docs |
| YOLO26n-obb | single-shot, oriented | 78.9 | 2.8 ms / 97.7 ms | T4 / CPU | vendor docs |
| Oriented R-CNN (R50) | two-stage, oriented | 75.87 | about 66 ms (15.1 FPS) | RTX 2080Ti | peer-reviewed (ICCV 2021) |

Sources: [[yolo-small-aerial-search]]. The YOLO numbers use multiscale testing, Oriented R-CNN single-scale, on different GPUs. The comparison shows the order of magnitude, not an exact ranking.

**Per photo (assistant's estimate):** a 500 × 375 m DOP20 crop is 2,500 × 1,875 px, i.e. 6 tiles of 1,024 px without overlap, or about 12 with overlap. With YOLO11n-obb that is about 26–53 ms on a T4 GPU or 0.7–1.4 s on CPU per photo. The pilot measured about 8 s per photo on CPU, including the WMS download ([[real-e2e-test]]); detection is therefore not the bottleneck.

### 2. Object sizes in DOP20 vs where YOLO fails
- **Thesis classes at 0.2 m:** pools 15–60 px; tanks 15–200 px; pitches 50–500 px ([[methods-10-25cm]]); a 6 m pool is about 30 px (unsourced arithmetic).
- **COCO size classes:** small < 32² px area, medium up to 96², large above ([[yolo-small-aerial-search]]). Most thesis objects are small to large, not tiny.
- **Documented YOLO weakness:** objects under about 16 px. On AI-TOD (mean size about 12.8 px) current YOLOs reach only single-digit to low-teen AP for very tiny objects. Objects of 2–8 px carry too little visual evidence (preprints, [[yolo-small-aerial-search]]).
- **Consequence:** only the smallest residential pools and small tanks approach this limit at 0.2 m. That matches the pilot, where small pools and some courts were missed zero-shot (recall 0.62, [[real-e2e-test]]).

### 3. Small objects in drone imagery
On VisDrone-DET2019 (many tiny people and vehicles), YOLO11n–x reach 32.0–46.1 % mAP@0.5 at 330–38 FPS. YOLO11s runs at 42 FPS on an embedded Jetson Orin NX (peer-reviewed, Journal of Imaging 2026; [[yolo-small-aerial-search]]). VisDrone objects are much smaller relative to the image than the thesis classes, so this is a conservative reference.

### 4. Class-specific precedents
- **Pools with OSM labels:**
  - YOLO11n trained for only 3 epochs on OSM `leisure=swimming_pool` labels over about 0.44 m/px imagery reaches mAP@0.5 0.742 in another region (tutorial, not peer-reviewed). Same label source as this thesis, but coarser imagery than DOP20.
  - A peer-reviewed ECCV 2022 workshop paper reports 44.4 % AP for pools in VHR orthomosaics. The metric is not checked, so the two numbers are not comparable ([[yolo-small-aerial-search]]).
- **Tanks:** circular terrain and traces cause false positives in large images. Spatial-layout post-processing helps (peer-reviewed, Remote Sensing 2024; [[yolo-small-aerial-search]]). This is the same failure family as the tank-farm mismatch in [[real-e2e-test]], which the likelihood is meant to handle.

### 5. The 2016 comparison is outdated
On Pascal VOC, the original YOLO was faster but less accurate than Faster R-CNN (66 % vs 73 % mAP) ([[sojasingarayar-2022-detector-comparison]]). On DOTA today, YOLO-OBB is both faster and at least as accurate as a two-stage oriented detector (section 1). Do not use the 2016 chart to justify the choice.

## Evidence levels
| Level | Items |
|---|---|
| Peer-reviewed | Oriented R-CNN (ICCV 2021); YOLO11s-UAV with YOLO11 baselines (J. Imaging 2026); AI-TOD dataset (ICPR 2020); YOLOv7-OT tanks (Remote Sensing 2024); YOLOv8 on DOTA-v1.5 (Remote Sensing 2024); ResnetYolo on orthomosaics (ECCVW 2022) |
| Vendor documentation | Ultralytics OBB tables for YOLOv8, YOLO11 and YOLO26: reproducible commands are given, but not independently reviewed |
| Preprints, tutorials | AI-TOD YOLO results (ScopeMamba-, HDMamba-YOLO); YOLO Evolution; satellite small-object study; pool tutorial with OSM labels |

## For the exposé (FF1)
- Cite the peer-reviewed items for the claims, and the Ultralytics software and DOTA for the model:
  - Xie et al. 2021 for the two-stage oriented baseline;
  - Mi et al. 2026 for YOLO11 speed and accuracy on drone imagery;
  - Wang et al. 2021 (AI-TOD) for where small becomes too small;
  - Wan et al. 2024 for tank false positives.
- Bibliographic data are verified in `expose/ergaenzungen.bib`; read the papers before citing.
- One sentence is enough: a single-shot detector with oriented boxes reaches DOTA-level accuracy within milliseconds per tile, and the thesis classes are large enough in 0.2 m imagery.

## Open risks (to measure in FF1)
- Recall on small pools after fine-tuning; the pilot's zero-shot recall was 0.62 ([[real-e2e-test]]).
- False positives from circular structures (tanks) and unmapped real objects (OSM gaps, [[osm-weak-labels]]).
- Tile borders: objects cut by tiles need overlap or re-stitching (the YOLOv7-OT paper names this problem; [[yolo-small-aerial-search]]).
- Transfer between regions and flight years, measured by the cross-region design ([[thesis-contribution]]).

## Related
- [[yolo]]
- [[object-detection]]
- [[pretrained-models]]
- [[faster-r-cnn]]
- [[methods-10-25cm]]
- [[real-e2e-test]]
- [[yolo-small-aerial-search]]
- [[expose-revision]]

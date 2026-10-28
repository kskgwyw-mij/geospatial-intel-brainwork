---
title: Search — newer YOLO versions for fast small-object detection in bird's-eye imagery
type: source
tags: [object-detection, yolo, small-objects, aerial, benchmark]
sources: [yolo-small-aerial-search]
raw: raw/2026-10-28-yolo-small-aerial-search.md
updated: 2026-10-28
---
Search evidence that current YOLO versions detect small objects in aerial and drone imagery fast: YOLO11-OBB reaches 78.4–81.3 mAP50 on DOTA at 4.4–28.6 ms per 1024 px tile (T4), above a two-stage oriented baseline at 66 ms; limits appear only for objects under about 16 px, which is below the size of the thesis classes at 0.2 m.

## Summary
Web searches and fetched pages from 28.10.2026: the Ultralytics OBB tables (YOLOv8, YOLO11, YOLO26 on DOTAv1), a peer-reviewed VisDrone study with YOLO11 at all scales, the AI-TOD tiny-object benchmark, COCO's size classes, pool and tank detection papers, and a few general comparisons. Bibliographic data of the key papers were checked via Crossref; their full texts were not read. Each item carries its evidence level: peer-reviewed, preprint, vendor documentation or tutorial.

## Key claims
- **YOLO11-OBB on DOTAv1 (vendor docs, 1024 px, multiscale test):**

  | Model | mAP50 | CPU ONNX | T4 TensorRT10 | Params |
  |---|---|---|---|---|
  | YOLO11n-obb | 78.4 | 117.6 ms | 4.4 ms | 2.7 M |
  | YOLO11s-obb | 79.5 | 219.4 ms | 5.1 ms | 9.7 M |
  | YOLO11m-obb | 80.9 | 562.8 ms | 10.1 ms | 20.9 M |
  | YOLO11l-obb | 81.0 | 712.5 ms | 13.5 ms | 26.2 M |
  | YOLO11x-obb | 81.3 | 1408.6 ms | 28.6 ms | 58.8 M |

  YOLOv8-OBB is similar in accuracy (78.0–81.36) but slower on CPU (204.8 ms for n). The newest YOLO26n-obb reaches 78.9 mAP50 at 2.8 ms (T4) and 97.7 ms (CPU) ([[yolo-small-aerial-search]]).
- **Two-stage oriented baseline (peer-reviewed):** Oriented R-CNN (ICCV 2021, ResNet50) reaches 75.87 % mAP on DOTA at 15.1 FPS, i.e. about 66 ms per 1024 × 1024 tile on an RTX 2080Ti ([[yolo-small-aerial-search]]).
- **Drone imagery (peer-reviewed, Journal of Imaging 2026):** on VisDrone-DET2019, YOLO11 n/s/m/l/x reach 32.0/38.2/42.7/44.4/46.1 % mAP@0.5 at 330/192/144/98/38 FPS (hardware not stated). On an embedded Jetson Orin NX, YOLO11s runs at 42 FPS (640 × 480). An improved YOLO11s reaches 46.0 % with 4.2 M parameters ([[yolo-small-aerial-search]]).
- **Where small becomes too small:**
  - COCO counts objects under 32² px area as "small" ([[yolo-small-aerial-search]]).
  - AI-TOD (ICPR 2020) has a mean object size of about 12.8 px, and 86 % of objects are under 16 px. On it, YOLO11s, YOLOv8 and YOLOv10s reach only single-digit to low-teen AP for very tiny objects. Objects of 2–8 px carry "extremely limited visual evidence"; improvements come mainly at 8–32 px (preprints) ([[yolo-small-aerial-search]]).
- **Pools:**
  - A tutorial trains YOLO11n for 3 epochs on OSM `leisure=swimming_pool` labels over Mapbox imagery at zoom 18 (about 0.44 m/px in Galicia). It reaches precision 0.785, recall 0.756 and mAP@0.5 0.742 in another region (Viana do Castelo). A YOLO11m reference model reaches 0.700 (tutorial, not peer-reviewed).
  - In VHR aerial orthomosaics, a ResNet50-YOLO detector reaches 44.4 % AP for pools and 78.5 % for solar panels (ECCV 2022 workshop; metric and GSD not checked) ([[yolo-small-aerial-search]]).
- **Tanks (peer-reviewed, Remote Sensing 2024):** circular terrain and circular traces of human activity cause many false tank detections in large images. Spatial-layout post-processing removes them: 90 % detection accuracy, 95.9 % precision on a self-built dataset ([[yolo-small-aerial-search]]).
- **YOLOv8 on DOTA-v1.5 small objects (peer-reviewed, Remote Sensing 2024):** pre-processing for small objects gives 66.7 % overall mAP, with a focus on efficiency ([[yolo-small-aerial-search]]).
- **General comparisons (preprints, weak):** YOLO11 has the best accuracy/efficiency balance across YOLOv3–v12. On satellite small objects, YOLOv11 is balanced and Faster R-CNN gives steadier coverage. YOLOv4 beats Faster R-CNN on small aircraft, and Faster R-CNN wins on large ones ([[yolo-small-aerial-search]]).

> [!warning] Not comparable as given
> The pool numbers diverge: mAP@0.5 0.742 in the tutorial vs 44.4 % AP in the ECCV workshop paper. Metric definitions (IoU 0.5 vs averaged IoU), imagery and labels differ, and the workshop paper's GSD was not checked. Neither shows the other wrong. Likewise, the YOLO-OBB and Oriented R-CNN numbers come from different hardware and test protocols (multiscale vs single-scale).

## Relevance to this wiki
- It closes most of the gap named in [[yolo]] and [[pretrained-models]]. A current YOLO-OBB matches or beats a peer-reviewed two-stage oriented detector on DOTA accuracy, at a fraction of the time per tile. The 2016-era trade-off from [[sojasingarayar-2022-detector-comparison]] no longer holds for current models.
- At 0.2 m, the thesis classes are mostly "small" to "large" in COCO terms, not "tiny" in AI-TOD terms. Pools are 15–60 px, tanks 15–200 px ([[methods-10-25cm]]). The documented YOLO weakness concerns objects under about 16 px.
- The decision and its limits are worked out in [[detector-choice]].

## Pages touched
[[detector-choice]], [[yolo]], [[object-detection]], [[pretrained-models]], [[overview]]

## Related
- [[detector-choice]]
- [[yolo]]
- [[faster-r-cnn]]
- [[object-detection]]
- [[pretrained-models]]
- [[real-e2e-test]]
- [[aerial-cv-benchmarks]]

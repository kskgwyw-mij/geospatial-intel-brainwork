# Search notes: newer YOLO versions for fast small-object detection in bird's-eye imagery (2026-10-28)

Web searches, fetched pages and bibliographic lookups by the AI assistant on the author's request
("We need more proof for fast small detection with newer YOLO version in birds eye imagery").
Facts as found; full texts were NOT read unless stated. Status: [peer-reviewed], [preprint], [vendor docs], [tutorial].

## Ultralytics OBB model tables (DOTAv1) [vendor docs]
- Source YOLO11/YOLOv8: https://raw.githubusercontent.com/ultralytics/ultralytics/v8.3.200/docs/en/tasks/obb.md and .../v8.3.0/docs/en/tasks/obb.md
- Source YOLO26: https://docs.ultralytics.com/tasks/obb/ (current page shows only YOLO26)
- Notes in docs: mAP = single-model multiscale on DOTAv1 test; speed averaged over DOTAv1 val images, batch 1,
  CPU via ONNX; GPU via TensorRT (YOLO11/YOLO26: NVIDIA T4, TensorRT10; YOLOv8 table: A100 TensorRT on EC2 P4d).
- YOLO11-OBB, 1024 px (mAP50 test | CPU ONNX ms | T4 TensorRT10 ms | params M | FLOPs B):
  - YOLO11n-obb 78.4 | 117.6 ± 0.8 | 4.4 ± 0.0 | 2.7 | 17.2
  - YOLO11s-obb 79.5 | 219.4 ± 4.0 | 5.1 ± 0.0 | 9.7 | 57.5
  - YOLO11m-obb 80.9 | 562.8 ± 2.9 | 10.1 ± 0.4 | 20.9 | 183.5
  - YOLO11l-obb 81.0 | 712.5 ± 5.0 | 13.5 ± 0.6 | 26.2 | 232.0
  - YOLO11x-obb 81.3 | 1408.6 ± 7.7 | 28.6 ± 1.0 | 58.8 | 520.2
- YOLOv8-OBB, 1024 px (mAP50 | CPU ONNX ms | A100 TensorRT ms | params | FLOPs):
  n 78.0 | 204.77 | 3.57 | 3.1 | 23.3; s 79.5 | 424.88 | 4.07 | 11.4 | 76.3; m 80.5 | 763.48 | 7.61 | 26.4 | 208.6;
  l 80.7 | 1278.42 | 11.83 | 44.5 | 433.8; x 81.36 | 1759.10 | 13.23 | 69.5 | 676.7
- YOLO26-OBB, 1024 px (mAP50-95 e2e | mAP50 e2e | CPU ONNX ms | T4 TensorRT10 ms | params | FLOPs):
  n 52.4 | 78.9 | 97.7 ± 0.9 | 2.8 ± 0.0 | 2.4 | 14.8; s 54.8 | 80.9 | 218.0 ± 1.4 | 4.9 ± 0.1 | 9.8 | 56.7;
  m 55.3 | 81.0 | 579.2 ± 3.8 | 10.2 ± 0.3 | 21.2 | 184.9; l 56.2 | 81.6 | 735.6 ± 3.1 | 13.0 ± 0.2 | 25.6 | 232.4;
  x 56.7 | 81.7 | 1485.7 ± 11.5 | 30.5 ± 0.9 | 57.6 | 520.1

## Two-stage oriented baseline: Oriented R-CNN [peer-reviewed]
- Xie, Cheng, Wang, Yao, Han. Oriented R-CNN for Object Detection. ICCV 2021, 3500–3509, doi 10.1109/ICCV48922.2021.00350 (Crossref).
- Abstract (arXiv 2108.05699): ResNet50, "DOTA (75.87% mAP) and HRSC2016 (96.50% mAP)", "15.1 FPS with the image size of 1024×1024 on a single RTX 2080Ti".

## Drone imagery, VisDrone-DET2019: YOLO11s-UAV [peer-reviewed]
- Mi, Chao, Chen, Zhang, Lai. YOLO11s-UAV: An Advanced Algorithm for Small Object Detection in UAV Aerial Imagery.
  Journal of Imaging 12(2), 69, 2026, doi 10.3390/jimaging12020069 (Crossref). Page: https://pmc.ncbi.nlm.nih.gov/articles/PMC12942582/
- Table 1, YOLO11 scales on VisDrone-DET2019 (mAP@0.5 | mAP@0.5:0.95 | params M | GFLOPs | FPS):
  n 32.0 | 18.5 | 2.6 | 6.3 | 330; s 38.2 | 22.7 | 9.4 | 21.3 | 192; m 42.7 | 26.1 | 20.0 | 67.7 | 144;
  l 44.4 | 27.4 | 25.3 | 86.6 | 98; x 46.1 | 28.6 | 56.8 | 194.5 | 38. FPS hardware not stated; training at 640×640.
- Table 7 (selection): YOLOv8s 38.6 / 115 FPS; YOLOv10s 38.2 / 247 FPS; YOLOv12s 38.2 / 78 FPS; YOLOv13s 36.1 / 95 FPS.
- Proposed model: 46.0 mAP@0.5 (val), 37.3 (test), 4.2 M params. Jetson Orin NX SUPER 8 GB, 640×480, batch 1, PyTorch:
  proposed 33 FPS (30.5 ms); YOLO11s baseline 42 FPS (23.6 ms).
- Abstract names the challenges: objects occupying few pixels, complex backgrounds, limited onboard compute.

## Tiny objects: AI-TOD [peer-reviewed dataset paper; results from preprints]
- Wang, Yang, Guo, Zhang, Xia. Tiny Object Detection in Aerial Images. ICPR 2020 (publ. 2021), 3791–3798, doi 10.1109/ICPR48806.2021.9413340 (Crossref).
- Search snippets: AI-TOD has 700,621 instances, 8 categories, 28,036 images, mean object size about 12.8 px; v2 states 86 % of objects < 16 px.
- Snippets from preprints (arXiv 2609.10156 ScopeMamba-YOLO; arXiv 2609.23061 HDMamba-YOLO): very-tiny AP of YOLO11s, YOLOv8, YOLOv10s is in the single digits to low teens; objects of 2–8 px "provide extremely limited visual evidence"; gains mainly in the 8–32 px range.
- ESL-YOLO (Remote Sensing, Nov 2024; snippet): +10 % mAP over YOLOv8s on AI-TOD. ARSOD-YOLO (YOLOv8-based; snippet): 47.8 % mAP50 on AI-TOD.

## COCO size classes [reference implementation]
- pycocotools cocoeval.py (https://github.com/cocodataset/cocoapi): areaRng = [[0², 1e5²], [0², 32²], [32², 96²], [96², 1e5²]], labels all / small / medium / large. Small = area < 32² px.

## Swimming pools
- Hands-on GeoAI 2026, Lecture 4 tutorial "Pool Detection with YOLO" [tutorial]: https://handson-geoai.readthedocs.io/en/latest/tutorials/L4_2-PoolDetection.html
  - Data: Hugging Face mozilla-ai/osm-swimming-pools; labels from OSM `leisure=swimming_pool` (indoor discarded); Mapbox satellite imagery, zoom 18, 512 × 512 px; train Galicia (6.91k images), validation Viana do Castelo (455 images).
  - YOLO11n, 3 epochs, imgsz 512: precision 0.785, recall 0.756, mAP@0.5 0.742, mAP@0.5:0.95 0.354 (conf 0.25).
  - Reference Mozilla.ai swimming-pool-detector (YOLO11m, 20.0 M params): 0.82 / 0.748 / 0.700 / 0.368.
  - Graz transfer: qualitative only. Caveat in the page: "OSM-derived labels can be incomplete or noisy".
  - Assistant's calculation: zoom 18 at 42.5° N ≈ 0.44 m/px (156543.03 · cos φ / 2^18).
- Ophoff, Van Beeck, Goedemé. Improving Object Detection in VHR Aerial Orthomosaics. ECCV 2022 Workshops, LNCS, 268–282, Springer 2023, doi 10.1007/978-3-031-25082-8_18 (Crossref) [peer-reviewed workshop]
  - ResnetYolo (ResNet50 backbone), patch NMS, IoA filtering, colour + elevation fusion, aerial orthomosaics; solar panels 78.5 % AP, swimming pools 44.4 % AP (two abstract summaries agree on this assignment; one search snippet was ambiguous); > 15 % AP over baselines. GSD not stated in the abstract.
- Older/other: YOLOv3 on drone/satellite images for pools as mosquito breeding sites (UFES master's thesis); DETR for illegal pools in Catalonia (UAB bachelor thesis, difficulty with small/partly visible pools).

## Storage tanks
- Wan, Zhan, Ren, Fan, Liu, Li. Storage Tank Target Detection for Large-Scale Remote Sensing Images Based on YOLOv7-OT. Remote Sensing 16(23), 4510, 2024, doi 10.3390/rs16234510 [peer-reviewed]
  - Abstract (OpenAlex): circular terrain and circular traces of human activity cause a high false-detection rate for tanks in large-scale images; edge re-stitching pre-processing, CBAM in the backbone for small targets, post-processing with the spatial distribution of tanks; self-built dataset: detection accuracy 90 %, precision 95.9 %, better than three classic detectors.

## DOTA small objects with YOLOv8
- Al-Hababi, Habib, Thabit, Liu. A Novel Pre-Processing Approach and Benchmarking Analysis for Faster, Robust, and Improved Small Object Detection Methods. Remote Sensing 16(20), 3753, 2024, doi 10.3390/rs16203753 [peer-reviewed]
  - Abstract: one-stage methods, YOLOv8, pre-processing (formatting, noise handling, normalisation) for small objects; DOTA-v1.5 overall class mAP 66.7 %; claims a new benchmark in computational efficiency and speed.

## General comparisons (weak evidence)
- Jegham et al. YOLO Evolution, arXiv 2411.00201 v4 (Mar 2025) [preprint]: YOLOv3–YOLOv12 benchmark; YOLO11 "strong accuracy-efficiency balance"; YOLOv12 underperforms relative to its complexity. No DOTA/OBB numbers on the abstract page.
- Yuan et al. An Empirical Study of Methods for Small Object Detection from Satellite Imagery, arXiv 2502.03674 v2 [preprint]: four methods on cars (urban) and bee boxes (farmland); snippet: YOLOv11 balanced, Faster R-CNN consistent coverage, anchor size matters for small objects.
- FlightScope, arXiv 2404.02877 [preprint]: YOLOv4 better on small airplanes, Faster R-CNN on larger ones (snippet).
- Sapkota et al. YOLO26, arXiv 2509.25164 v5 [preprint]: ProgLoss and Small-Target-Aware Label Assignment (STAL); edge benchmarks on Jetson Nano/Orin; no numbers on the abstract page.
- VisDrone numbers vary widely by setup: a preprint (preprints.org 202603.0990) reports YOLOv8l at 1280 px only 15.9 % mAP50 at ~8 FPS; an arXiv review (2608.07571) lists YOLOv8s 43.0 mAP50 / 245 FPS and YOLO11s 41.6 / 228 FPS.

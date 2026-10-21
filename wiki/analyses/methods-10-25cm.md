---
title: Detector & classifier approaches for 10–25 cm orthophotos
type: analysis
tags: [methods, decision, detection, segmentation, classification]
sources: [methods-10-25cm-search, maggiori-2017-hr-semantic-labeling, maggiori-osm-imperfect-labels, aerial-cv-benchmarks, author-note-industrial-colour]
updated: 2026-10-21
---
A rethink of which detector, segmenter and classifier approaches fit each thesis class (buildings and roof shapes, pools, solar arrays, trees, pitches, tanks) at state-orthophoto resolution, and how they combine into one pipeline.

## 1. The four approach families

| Family | How it works | Role in the thesis |
|---|---|---|
| **A. Classical ML** | Pixel- or segment-based features (colour, texture, nDSM height, shape) → random forest or gradient boosting | Baseline; justifies DL ([[spectral-texture-features]]) |
| **B. Task-specific deep learning** | Semantic segmentation (U-Net, DeepLab, SegFormer), instance segmentation (Mask R-CNN, YOLO-seg), detection (YOLO, RetinaNet, Faster R-CNN; oriented boxes), patch classification (ResNet, EfficientNet) | Main method, trained on [[osm-weak-labels]] |
| **C. Two-stage pipelines** | Find the object first, then classify a crop of it (for example building → roof shape, pitch → sport) | Turns OSM attribute tags into classification targets |
| **D. Foundation / zero-shot** | SAM/SAM2 masks from box or point prompts; Grounding DINO + SAM from text prompts | Label refiner and comparison point; not the main model |

Classical baseline details are sourced in [[spectral-texture-features]]. The family
descriptions are a synthesis. (unsourced)

## 2. Per-class choice

| Class (OSM) | Geometry / size at 10–25 cm | Best framing | Primary model | Classification layer | Evidence |
|---|---|---|---|---|---|
| **Buildings** `building=*` | Polygons, 30–1000+ px | Semantic or instance segmentation | U-Net (sharp boundaries) or Mask R-CNN (separates instances, better recall, but misses big buildings); fuse both or add a DSM (≈ +3.6 % IoU) | — | [[methods-10-25cm-search]], [[maggiori-2017-hr-semantic-labeling]] (building F1 ≈ 95 on ISPRS) |
| **Roof shape** `roof:shape` | Attribute of a building | Two-stage: footprint → roof crop → CNN classifier | EfficientNet/ResNet on crops; 6 classes (flat, hip, half-hip, gable, pyramid, complex) shown at 10 cm | Yes; this is the classifier | [[methods-10-25cm-search]] |
| **Pools** `leisure=swimming_pool` | Compact, 15–60 px, strong colour cue | Detection (oriented boxes) or instance segmentation | YOLO / RetinaNet; it is a DOTA class | Optional: indoor/outdoor, shape | [[aerial-cv-benchmarks]] |
| **Solar arrays** `power=generator` + `generator:source=solar` | Thin rectangles on roofs, often < 10 px wide | Semantic segmentation | U-Net: F1 up to 91.75 % at 10 cm; IoU > 85 % on a 0.1 m dataset; **retrain or fine-tune per resolution** | Optional: rooftop vs. ground-mounted | [[methods-10-25cm-search]] |
| **Trees** `natural=tree`, `natural=wood` | Crowns 10–80 px; points in OSM | Point or box detection for single trees; segmentation for wood/forest | DeepForest (pretrained RetinaNet crown detector); SAM2 prompted by detections for crown masks | Optional: deciduous vs. conifer (OSM `leaf_type`) | [[methods-10-25cm-search]] |
| **Pitches** `leisure=pitch` + `sport=*` | Rectangles 50–500 px with markings | Detection, then a sport classifier (two-stage) | YOLO / Faster R-CNN; DOTA has tennis, basketball, soccer, track and baseball classes | Yes: `sport=tennis\|soccer\|…` | [[aerial-cv-benchmarks]] |
| **Tanks** `man_made=storage_tank` | Circles, 15–200 px | Detection | YOLO / RetinaNet; a DOTA class | Optional: `content=*` is invisible; skip | [[aerial-cv-benchmarks]] |
| **Industrial land use** `landuse=industrial` | Large areas | Tile classification or segmentation | CNN tile classifier versus a colour/texture random forest | Yes: industrial / commercial / residential | [[author-note-industrial-colour]] |

Pixel sizes are estimates for 10–25 cm GSD. (unsourced)

## 3. Recommended architecture: one pipeline, three heads

1. **Segmentation head** (U-Net or DeepLab, RGB(+NIR)(+nDSM)) for buildings, solar, wood and
   water. It uses the multi-resolution fusion idea from [[maggiori-2017-hr-semantic-labeling]]. Masks are polygonised into GeoJSON.
2. **Detection head** (one YOLO-type detector with oriented boxes) for pools, tanks, pitches and single trees
   (DeepForest as a pretrained start for trees).
3. **Crop classifier** for attributes: roof shape on building crops, sport on pitch crops.
   This is the "classification" half of the thesis title.
4. **Optional SAM2 refinement:** use boxes from step 2 as prompts to turn boxes into
   masks. Detector-prompted SAM works well for trees and PV ([[methods-10-25cm-search]]).

Training labels come from Overpass ([[osm-weak-labels]]). Pretrain on noisy OSM labels, then
fine-tune on a small hand-checked set ([[maggiori-osm-imperfect-labels]]). Compare against
the classical random-forest baseline and a zero-shot Grounded-SAM baseline (F1 0.83 on WHU
buildings), which gives a three-way comparison for the research question.

Pretrained starting points for each head (YOLO11-OBB on DOTA, DeepForest, Satlas/DINOv3 encoders, SAM2): [[pretrained-models]].

## 4. What to scope down to
A full three-head system is too much for one part-time thesis. (unsourced) Realistic cuts:
- **Minimum:** buildings (segmentation) plus roof shape (classifier). One object, both "recognition" and "classification", rich OSM labels.
- **Plus one detector class:** pools or solar, chosen by how well your region is mapped. Check counts with Overpass first ([[osm-object-catalog]]).
- Leave trees and pitches as future work unless the region has good OSM coverage.

## 5. Pitfalls that cut across classes
- **Resolution shift:** models do not transfer across GSDs without fine-tuning ([[methods-10-25cm-search]]). Resample all imagery to one GSD.
- **Minority and small objects:** report per-class F1 and mean F1 next to accuracy ([[maggiori-2017-hr-semantic-labeling]]).
- **Leaning buildings** in standard (not true) orthophotos shift roofs away from OSM footprints. Expect label offsets ([[osm-weak-labels]]). (unsourced)
- **Tile borders:** use overlapping tiles at inference ([[maggiori-2017-hr-semantic-labeling]]).

## Related
- [[pretrained-models]]
- [[cv-detectability]]
- [[osm-object-catalog]]
- [[semantic-segmentation]]
- [[object-detection]]
- [[spectral-texture-features]]
- [[thesis-poc-pipeline]]
- [[methods-10-25cm-search]]

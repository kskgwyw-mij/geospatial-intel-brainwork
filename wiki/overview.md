---
title: Overview
type: overview
tags: [meta]
sources: [thesis-goal, dsia-studienordnung-2027, hok-dsia-program-listings, maggiori-osm-imperfect-labels, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-20
---
Current big-picture understanding of ML/DL algorithm selection for recognising OSM/Overpass objects in orthoimagery, for the HOK master thesis.

## Scope

The master thesis in the [[hok-dsia-master]] aims at an ML/DL **recognition and
classification** method for objects that exist in [[openstreetmap]] (defined via
[[overpass-turbo]]), applied to [[orthoimagery]], with a proof of concept in which imagery is
uploaded to a [[poc-platform]] ([[thesis-goal]]).

## Current understanding

- **Labels come almost for free from OSM.** Because orthoimagery is georeferenced, OSM
  geometries from the [[overpass-api]] can be turned straight into training masks or boxes.
  The price is label noise: misalignment, missing objects, and outdated objects
  ([[osm-weak-labels]]). There is published precedent: pretrain on noisy OSM labels, then refine on a small accurate set ([[maggiori-osm-imperfect-labels]]).
- **The choice of method depends on the object classes.** Compact, countable objects suit
  [[object-detection]]; areal or linear features suit [[semantic-segmentation]]. Instance
  segmentation covers both cases for things like buildings. (unsourced)
- **What CV can see** is bounded by object size in pixels (about 10–20 px minimum), visibility from above, and occlusion. Detectable OSM classes overlap with the DOTA/ISPRS benchmark classes ([[cv-detectability]], [[aerial-cv-benchmarks]]). Coarse land use is also visible: industrial areas differ in colour and texture ([[author-note-industrial-colour]], [[spectral-texture-features]]).
- **Per-pixel labelling** of high-resolution aerial imagery works best when multi-resolution CNN features are combined, which gives recognition plus precise boundaries. A small FCN plus MLP reached 88.9 % OA on Vaihingen on a 4 GB GPU, beating larger models ([[maggiori-2017-hr-semantic-labeling]]). Because the imagery is georeferenced, pixel labels become geo-polygons.
- **Method per class** ([[methods-10-25cm]]): segmentation (U-Net/DeepLab) for buildings and solar; detection (YOLO-type, DeepForest) for pools, tanks, pitches and trees; crop classifiers for roof shape and sport; SAM2 as a label and mask refiner. Suggested minimum scope: buildings plus roof-shape classification.
- **The working design** is in [[thesis-poc-pipeline]]: Overpass → labels → model → PoC.
- **Programme constraints** come from the official regulation ([[dsia-studienordnung-2027]]):
  the thesis is 20 ECTS + a 2-ECTS committee exam in semester 4, the exposé is approved by the
  programme director, and the colloquium examines the research question and method. The
  curriculum teaches CNNs and image-based object recognition but **nothing geospatial**, so
  the thesis must bring its own GIS foundations. Milestones are in [[thesis-timeline]].

## Open questions

- Which object classes and study region? This drives every other choice. Candidates: [[osm-object-catalog]].
- Detection, segmentation, or both? Proposed answer: both, per class ([[methods-10-25cm]]).
- Which orthoimagery source (resolution, date, licence)?
- Does the PoC platform exist already, or is building it part of the thesis?
- How should spatial leakage be handled in train/test splits? (unsourced)
- Which regulation version applies to the author? The one ingested covers cohorts starting WS 2027/28.
- What is the research question for the exposé? A PoC alone is not one; see [[thesis-timeline]].
- Formal thesis guidelines (length, citation style, deadlines) are not in the regulation.

## Related
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[thesis-timeline]]
- [[index]]
- [[log]]

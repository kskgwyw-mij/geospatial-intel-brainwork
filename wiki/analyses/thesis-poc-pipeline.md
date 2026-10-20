---
title: Thesis PoC pipeline (working design)
type: analysis
tags: [thesis, architecture, decision]
sources: [thesis-goal, dsia-studienordnung-2027]
updated: 2026-10-20
---
Working end-to-end design for the thesis: Overpass → labels → model → PoC platform. It is a draft built on the goal statement; most design choices are not sourced yet.

## Pipeline

1. **Define classes in [[overpass-turbo]]**: one documented Overpass QL query per class (tag filter + area).
2. **Pull geometries via the [[overpass-api]]** for the training regions; cache them as GeoJSON with the OSM timestamp.
3. **Get matching [[orthoimagery]]**: same extent, known resolution and acquisition date.
4. **Build labels** ([[osm-weak-labels]]): rasterise polygons into masks and/or derive boxes; tile to fixed-size chips; split train/val/test **by region**, not randomly, to avoid spatial leakage. (unsourced)
5. **Train and compare models**: [[object-detection]] and/or [[semantic-segmentation]], with a classical ML baseline (for example a random forest on pixel or object features) to justify using DL. Both families are taught: random forests and ensembles in Statistical Learning 1/2, CNNs in ML & Deep Learning ([[dsia-studienordnung-2027]]).
6. **Evaluate** on a hand-checked test set, since the OSM labels are noisy. (unsourced)
7. **PoC on the [[poc-platform]]**: upload GeoTIFF → tile → infer → merge → GeoJSON output, optionally compared with current OSM to report agreement, objects missing from OSM, and possibly outdated ones.

## Fit with the programme
The regulation expects an end-to-end ML project and an exposé that aligns problem, research question and method ([[dsia-studienordnung-2027]]). This pipeline is the method; the research question still has to be fixed (see [[thesis-timeline]]).

## Decisions still open
- Detection vs. segmentation vs. both: this depends on the chosen object classes.
- Object classes and study region (candidate shortlist in [[osm-object-catalog]]).
- Imagery source, resolution, and licence.
- Whether the PoC platform exists already or must be built.

## Related
- [[thesis-goal]]
- [[overview]]
- [[poc-platform]]
- [[thesis-timeline]]

---
title: Overview
type: overview
tags: [meta]
sources: [thesis-goal, hok-dsia-program-listings]
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
  ([[osm-weak-labels]]). (unsourced)
- **The choice of method depends on the object classes.** Compact, countable objects suit
  [[object-detection]]; areal or linear features suit [[semantic-segmentation]]. Instance
  segmentation covers both cases for things like buildings. (unsourced)
- **The working design** is in [[thesis-poc-pipeline]]: Overpass → labels → model → PoC.
- Programme facts so far come only from third-party listings ([[hok-dsia-program-listings]]).

## Open questions

- Which object classes and study region? This drives every other choice.
- Detection, segmentation, or both?
- Which orthoimagery source (resolution, date, licence)?
- Does the PoC platform exist already, or is building it part of the thesis?
- How should spatial leakage be handled in train/test splits? (unsourced)
- What are the official thesis requirements (deadline, format, evaluation)?

## Related
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[index]]
- [[log]]

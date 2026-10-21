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
uploaded to a [[poc-platform]] ([[thesis-goal]]). **Input decision:** a nadir photo **without metadata** ([[author-decision-nadir-input]], [[author-decision-no-metadata]]). Location, scale and north are unknown, so the method must detect objects, then locate the photo by matching them to OSM. **Search region:** [[oberbayern-sued]], provisionally the Alpine-edge districts only (GAP, TÖL, MB, WM, RO, TS, BGL; about 7,800 km²) ([[author-decision-search-region]]), with open Bavarian DOP20 imagery ([[bayern-dop-regions-search]]) and further Bavarian open data: DGM1 (1 m) for terrain, DOM20 (20 cm) for an nDSM, and official labels from LoD2 (roof shapes), Hausumringe (footprints), Einzelbäume (trees) and ALKIS land use. DOP20 comes as 1 km GeoTIFF tiles in EPSG:25832 at about 50 MB each (up to 126 GB per district), so sample tiles; a historical-DOP WMS adds older flight years ([[bayern-opengeodata]], [[bayern-dop20rgb-detail]]). Copernicus DEM GLO-30 is only a fallback outside Bavaria ([[copernicus-browser]]).

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
- **Geolocation by fingerprint** ([[osm-fingerprint-geolocalization]]): a pair of rare, stable, detectable OSM classes plus their distance and bearing forms a key you can search in Overpass. With bearing, chance matches drop by orders of magnitude. Precedent: neighbourhood-of-intersections fingerprints plus geometric alignment locate about 90 % of intersections within 2.5 m at 1 m/px ([[costea-2016-aerial-geolocalization]]). Lesson: use a neighbourhood constellation, retrieve then verify. Roads fail in sparse countryside ([[author-note-rural-roads]]); there, use shape anchors (forest edges, watercourses, field mosaic, hedges, farm buildings, pylons) as boundary maps plus terrain ([[rural-geolocalization-search]]).
- **Application framing: GNSS-denied visual localisation** of drones and aerial photos ([[gnss-denied-use-cases]], [[author-note-use-cases-gnss-denied]]). Use cases: GPS outage, jamming and spoofing; Alpine signal shading; search and rescue; locating imagery after the fact; sub-metre GPS refinement; infrastructure inspection; OSM maintenance. Dual-use, so it needs an ethics section.
- **Geolocation prototype** ([[geo-match-prototype]]): in simulation at the size of the search region, "confident" matches were 100 % correct, with sub-metre position, < 0.1 % scale and < 0.1° heading error. Photos need about 8 detected anchors; 3–4 fail, so rural photos need more anchor types.
- **Pretrained models exist for every head** ([[pretrained-models]]): YOLO11-OBB on DOTA (pools, tanks, pitches), DeepForest (trees), SatlasPretrain and DINOv3-satellite encoders (segmentation, retrieval), SAM2 (masks). None was trained at 10–25 cm, so fine-tune locally.
- **The working design** is in [[thesis-poc-pipeline]]: Overpass → labels → model → PoC.
- **Programme constraints** come from the official regulation ([[dsia-studienordnung-2027]]):
  the thesis is 20 ECTS + a 2-ECTS committee exam in semester 4, the exposé is approved by the
  programme director, and the colloquium examines the research question and method. The
  curriculum teaches CNNs and image-based object recognition but **nothing geospatial**, so
  the thesis must bring its own GIS foundations. Milestones are in [[thesis-timeline]].

## Open questions

- Which object classes and study region? This drives every other choice. Candidates: [[osm-object-catalog]].
- Detection, segmentation, or both? Proposed answer: both, per class ([[methods-10-25cm]]).
- Imagery: proposed Bavarian DOP20 for training and testing, split by district, with simulated metadata-free test crops ([[imagery-sources]]).
- Does the PoC platform exist already, or is building it part of the thesis?
- How should spatial leakage be handled in train/test splits? (unsourced)
- Which regulation version applies to the author? The one ingested covers cohorts starting WS 2027/28.
- Geolocation is now part of the method ([[author-decision-no-metadata]]). The search region is fixed ([[oberbayern-sued]]). Provisional choice: Alpine-edge districts only; the area may change later, so keep it parameterised. How is scale recovered (metric anchors such as tennis courts)?
- Research question: a preferred candidate exists (GNSS-denied localisation from OSM objects; see [[thesis-timeline]]). Open: confirm it with the supervisor, and back the use-case claims with literature.
- Contradiction: Copernicus access with vs. without registration ([[geopera-free-satellite-germany]] vs. [[copernicus-browser]]). The official docs are taken as correct.
- Formal thesis guidelines (length, citation style, deadlines) are not in the regulation.

## Related
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[thesis-timeline]]
- [[index]]
- [[log]]

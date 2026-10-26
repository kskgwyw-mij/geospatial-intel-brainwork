---
title: Overview
type: overview
tags: [meta]
sources: [thesis-goal, dsia-studienordnung-2027, hok-dsia-program-listings, maggiori-osm-imperfect-labels, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-22
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
- **Scope: detection + localisation.** Recognition and classification of OSM objects is part of the thesis ([[author-decision-detection-in-scope]]); localisation builds on the detections. Two sub-questions: FF1 detection quality, FF2 localisation from real detections ([[thesis-timeline]]).
- **Application framing: GNSS-denied visual localisation** of drones and aerial photos ([[gnss-denied-use-cases]], [[author-note-use-cases-gnss-denied]]). Use cases: GPS outage, jamming and spoofing; Alpine signal shading; search and rescue; locating imagery after the fact; sub-metre GPS refinement; infrastructure inspection; OSM maintenance. Dual-use, so it needs an ethics section. After the peer review, the author treats drones as one use case among several, not as the frame ([[peer-review-expose]]).
- **Geolocation prototype** ([[geo-match-prototype]]): in simulation at the size of the search region, "confident" matches were 100 % correct, with sub-metre position, < 0.1 % scale and < 0.1° heading error. Photos need about 8 detected anchors; 3–4 fail, so rural photos need more anchor types.
- **Real-data check** ([[osm-real-test]]): on real OSM anchors (11,599, about 1.5/km²), confident matches stay correct (30/30), but randomly placed photos are located only **1 %** of the time. Buildings (about 55/km² in Miesbach) give ≥ 8 objects in about 23 % of photos, and **51 % of photos contain no building at all**. Earlier synthetic results were optimistic on coverage.
- **Real end-to-end test** ([[real-e2e-test]]): real DOP20 + pretrained DOTA detector (precision about 0.5, recall about 0.6 vs OSM) + real OSM located 6/40 photos near anchors and 0/40 random ones. **One confident match was wrong** (a repetitive tank farm), so the confidence rule must become density-aware.
- **Settlement detection is stable** ([[settlement-detection]], [[settlement-test]]): 1-ha settlement cells are recognised with AUC 0.98–0.995 from a frozen DOTA embedding plus logistic regression, across Miesbach → Garmisch and the 2024 → 2018 flights. Isolated huts and barns are the main miss, and OSM buildings ≠ inhabitants. In Overpass terms, "inhabited" = dwelling (residential type or house number, not an outbuilding). Against that label the detector reaches AUC 0.984 (0.973 on 2018), and Overpass becomes the training-label source, the localisation reference and the completeness baseline ([[settlement-overpass]]).
- **Framework and scope** ([[author-decision-framework-scope]]): Design Science Research (Hevner 2004, Peffers 2007). Regions are compared by object density; the study is not restricted to feature-poor areas.
- **Working title** ([[author-decision-title]]): „Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen: Eine Generalisierungsstudie über Regionen“. Generalisation is across regions only: no cross-provider test and no GSD axis ([[author-decision-generalisation-axes]]).
- **Literature base:** the author's own list of 30 works ([[author-literature-list]]) is now the exposé bibliography. Nearest neighbours to check in full text are Schleiss 2019, Wei 2022, Ouyang 2024, SWA-PF 2025 and SeqLoc 2026 (= arXiv 2608.07835).
- **Contribution** ([[thesis-contribution]], [[author-note-novelty]]): every ingredient exists (OSM landmark matching for ground robots, subgraph matching, point-process localizability theory, ground-level OSM localisation, synthetic SASGeo); the combination does not. That combination is POI classes from nadir imagery, a detector-error model in a point-process likelihood, a calibrated heatmap with a null hypothesis, and cross-region/cross-provider tests on real data. The likelihood replaces inlier counting in the matcher.
- **Improving localisation** ([[localization-improvements]], [[localization-levers-test]]): coverage is the bottleneck. Random-photo ceilings are 0.1–1.6 % with point anchors, 34 % adding buildings and junctions, and 78 % adding roads, water and forest edges; 22 % show no mapped cue. The class-diversity rule fixes the wrong confident match (now 2/2). A 5 km region + scale prior makes all confident and probable answers correct but only raises located photos from 6 to 10 of 40.
- **Feasibility** ([[feasibility]]): with ≥ 4 agreeing objects, false matches are very rare in about 7,800 km², since each extra inlier multiplies the risk by about 10⁻⁴. The bottleneck is **anchor availability**: rare objects (about 2/km²) almost never give ≥ 4 per photo, so dense anchors (buildings, trees, intersections) are required. Precision is about σ/√n, and OSM error passes through (1.8 m at 2 m OSM noise). About 100 test photos per condition give ±10 pp CIs.
- **Fine-grained localisation is coarse-to-fine** ([[coarse-to-fine-localization]]): region prior → object fingerprint retrieval → RANSAC object alignment (metre level) → dense registration against DOP20 (sub-metre) → camera pose with DOM20/DGM1 heights (removes relief displacement).
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
- Formal rules are now known: 10–15k words, ≥ 6 months processing, exposé due 23.10.2026, registration 31.10.2026, AI share ≤ 50 % ([[hok-aspo-2026]], [[wa-course-expose]]; checklist in [[expose-guide]]). Still missing: the HOK thesis guide (citation style) and confirmation of the cohort and regulation version.
- Is a scale prior (known drone type) compatible with "no metadata"? It is needed for the prior scenario in [[localization-improvements]].
- Contradiction: confident matches 30/30 correct with simulated detections ([[osm-real-test]]) vs 3/4 with real detections ([[real-e2e-test]]). Cause: repetitive single-class clusters; fix the scoring.
- Literature for the exposé: the relevance now has candidate peer-reviewed sources (VTRN / absolute visual localisation: reviews, Mars 2020 LVS, UAV orthophoto matching, OSM-based OrienterNet), found by search only; full texts must be read ([[vtrn-literature-search]]). The gap stated in the literature is regions without clear semantic features, which is this thesis's setting.
- Evaluation design gaps found in the exposé review ([[expose-review]]): no fixed success radius or primary endpoint; test crops never vary scale although scale is "unknown"; no out-of-region negative images to test abstention; the null-hypothesis threshold needs a calibrated null distribution; search-space size and candidate generation are unspecified; detector errors measured against OSM mix in map incompleteness.
- Peer review of the exposé ([[peer-review-expose]]): why OSM only and not orthophotos as an extra reference (A2), why nadir and no metadata (A5), and the apparent contradiction between settlement objects and the Alpine edge (A6) need a reason in the exposé. Answers drafted in [[expose-revision]]; the author drops the pre-test example.

## Related
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[thesis-timeline]]
- [[expose-guide]]
- [[index]]
- [[log]]

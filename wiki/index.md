# Index

Catalog of every wiki page. One line each: `[[page]] — one-sentence summary`.
Updated on every ingest, filed query, or rename. Read this first when answering a question.

## Overview
- [[overview]] — Current big-picture understanding of ML/DL algorithm selection for recognising OSM/Overpass objects in orthoimagery, for the HOK master thesis.

## Sources
- [[thesis-goal]] — The author's own statement of the master thesis goal: an ML/DL method that recognises and classifies OSM objects (via Overpass Turbo) in orthoimagery, shown in a PoC platform.
- [[hok-aspo-2026]] — HOK general study & exam regulation (amended 8 Jun 2026): thesis 10–15k words, exposé approved by semester 3, ≥ 6 months processing, defence 50 %, unfair AI use counts as fraud.
- [[wa-course-expose]] — Scientific-writing course notes: exposé structure, due 23.10.2026 (name-free PDF + AI documentation, ≤ 50 % AI), registration by 31.10.2026.
- [[hok-ki-leitlinie]] — HOK AI & study guideline: AI supports but must not replace own work; disclose use; no uploading of copyrighted teaching material.
- [[dsia-studienordnung-2027]] — Official 83-page study regulation (from WS 2027/28): curriculum, thesis rules (exposé, 20+2 ECTS), relevant courses, admission.
- [[aerial-cv-benchmarks]] — Search-result facts on DOTA (detection, 15–18 classes), ISPRS Potsdam/Vaihingen (6-class segmentation, 5/9 cm) and Inria (30 cm buildings).
- [[author-note-industrial-colour]] — Author observation: industrial areas have a distinct colour in orthoimagery.
- [[maggiori-2017-hr-semantic-labeling]] — Maggiori et al. 2017 (TGRS, full text): CNN architecture analysis plus a multi-resolution MLP net; 88.92 % OA on Vaihingen, 2nd of 29 on ISPRS.
- [[maggiori-osm-imperfect-labels]] — Maggiori et al.: FCN pretrained on imperfect OSM labels, then refined on a small accurate set; precedent for this thesis.
- [[methods-10-25cm-search]] — Search evidence: PV U-Net (F1 91.75 % at 10 cm), DeepForest trees, roof-type CNNs, U-Net vs. Mask R-CNN footprints, Grounded-SAM zero-shot.
- [[costea-2016-aerial-geolocalization]] — Costea & Leordeanu 2016 (full text): intersection-neighbourhood fingerprints matched to OSM plus RANSAC/Chamfer alignment; about 90 % of intersections located within 2.5 m at 1 m/px.
- [[author-note-rural-roads]] — Author observation: roads alone will not work in sparse countryside.
- [[rural-geolocalization-search]] — Search evidence for road-sparse geolocalisation: DEM orthoprojection, land-cover boundary-map matching, rural benchmark subset.
- [[pretrained-models-search]] — Search facts: TorchGeo/Satlas Swin V2 NAIP weights, YOLO11-OBB on DOTAv1 (78.4 mAP50 nano), DINOv3 SAT-493M (Maxar 0.6 m).
- [[author-decision-nadir-input]] — Author decision: nadir images are the required input; orthoimagery ideal but optional.
- [[author-decision-no-metadata]] — Author decision: the photo is used without any metadata, so location, scale and north must come from the image.
- [[geopera-free-satellite-germany]] — Vendor blog (full clip): 10 free sources for Germany; free satellite data is 10–30 m, paid satellite at best 30 cm; contradiction on Copernicus registration.
- [[german-dop-search]] — Search facts: German state orthophotos DOP20/40 nationwide, DOP10 in some Länder (NRW 10 cm, 3-year cycle).
- [[author-decision-search-region]] — Author decision: the search region is Oberbayern Süd.
- [[bayern-dop-regions-search]] — Search facts: Bavarian DOP20 (20 cm RGB+CIR) open under CC BY 4.0; Oberland 3,956 km² + Südostoberbayern 5,225 km².
- [[copernicus-browser]] — Copernicus Browser (CDSE): free Sentinel data and mosaics, Copernicus DEM (GLO-30 free, EEA-10 restricted), VHR2024 (download restricted); useful mainly as a terrain DEM.
- [[author-note-use-cases-gnss-denied]] — Author note (German): eight use cases for GNSS-denied drone localisation, simulation limits, proposed research question.
- [[bayern-opengeodata]] — Bavarian OpenGeoData catalogue (full clip): DOP20 RGB/CIR, DGM1, DOM20, LiDAR, LoD2, Einzelbäume, Hausumringe, ATKIS, ALKIS land use, parcels and districts.
- [[bayern-dop20rgb-detail]] — DOP20 RGB product page: 1 km GeoTIFF tiles in EPSG:25832, about 50 MB per tile, up to 126 GB per district, WMS (incl. historical DOP) and WMTS, CC BY 4.0.
- [[author-decision-detection-in-scope]] — Author decision: detection and classification are part of the thesis, alongside metadata-free localisation.
- [[vtrn-literature-search]] — Literature search on visual terrain-relative navigation and UAV absolute visual localisation: Mars 2020 LVS, Conte & Doherty, Goforth & Lucey, Kinnari, Fragoso, reviews, datasets, OSM/semantic-map methods.
- [[localization-levers-test]] — Real-data lever tests: cue coverage ceilings (point anchors 0.1–1.6 %, +buildings/junctions 34 %, +lines 78 %), class-diversity rule (confident 2/2), priors (6 → 10/40).
- [[settlement-overpass-labels]] — Overpass building tags (75 % `building=yes`, 35–43 % house numbers), dwelling rule; detector AUC 0.984 for inhabited, 0.999 for settlement; live Garmisch grid.
- [[settlement-test]] — Real test, 1,100 DOP20 hectares (Miesbach, Garmisch; 2024 and 2018 flights): settlement cells AUC 0.98–0.995 with a frozen DOTA embedding; misses are isolated huts.
- [[real-e2e-test]] — Real end-to-end test (DOP20 + DOTA YOLO11-OBB + real OSM): detection precision 0.49 / recall 0.62; located 6/40 near anchors, 0/40 random; first wrong confident match (tank farm).
- [[osm-real-test]] — Real OSM test: 11,599 anchors (about 1.5/km²), Miesbach 47k buildings (about 55/km²); random photos located 1 % with point anchors; half of footprints have no building.
- [[hok-dsia-program-listings]] — Third-party listing facts about the part-time MSc programme; the official page could not be fetched.

## Entities
- [[hok-dsia-master]] — The DSIA master's programme at HOK Kufstein Tirol (part-time form) in which the thesis is written.
- [[openstreetmap]] — The crowd-sourced world map whose features define the object classes.
- [[overpass-api]] — Read-only query API for OSM data; the backend Overpass Turbo calls.
- [[overpass-turbo]] — Web IDE for writing and visualising Overpass queries; defines which OSM objects count.
- [[oberbayern-sued]] — Search region and study area: provisionally the Alpine-edge districts GAP, TÖL, MB, WM, RO, TS, BGL (about 7,800 km²), DOP20 imagery, Overpass area query.
- [[poc-platform]] — The proof-of-concept platform where orthoimagery is uploaded and detections are shown.

## Concepts
- [[orthoimagery]] — Orthorectified aerial or satellite images that line up with map coordinates; the input data.
- [[osm-weak-labels]] — Using OSM geometries from Overpass as noisy training labels instead of hand annotation.
- [[object-detection]] — Bounding box plus class per object; suits compact, countable features.
- [[semantic-segmentation]] — A class for every pixel; suits areal and linear features.
- [[terrain-relative-navigation]] — (Visual) terrain-relative navigation: locating a vehicle by matching its view to a georeferenced map; variants, typical structure, weak points; the established name for this thesis's task.
- [[ransac]] — Random Sample Consensus: robustly fits a transform (shift, rotation, scale) despite many wrong matches; the core of the geolocation matcher.
- [[spectral-texture-features]] — Colour, texture and shape cues that reveal land use (e.g. industrial areas) and power a classical ML baseline.

## Analyses
- [[thesis-poc-pipeline]] — Working end-to-end design: Overpass → labels → model → PoC platform.
- [[osm-object-catalog]] — Element types, primary OSM keys with main values, visibility in orthoimagery, thesis class shortlist, query templates.
- [[cv-detectability]] — What CV can and cannot recognise in orthoimagery, by task, object size and GSD, mapped to OSM tags.
- [[methods-10-25cm]] — Per-class detector/segmenter/classifier choice at 10–25 cm, three-head pipeline, scope cuts.
- [[osm-fingerprint-geolocalization]] — Two-factor fingerprint (anchor + neighbourhood constellation) to locate images via Overpass; uniqueness maths, urban vs. rural anchors, search procedure.
- [[geo-match-prototype]] — Matcher prototype (geo_match.py) and simulation: confident matches always correct; about 8 anchors needed at regional scale.
- [[coarse-to-fine-localization]] — Four stages from region prior to decimetre camera pose: fingerprint retrieval, RANSAC object alignment, dense DOP20 registration, pose with DOM20 heights.
- [[feasibility]] — Technical and statistical feasibility: false-match maths (≥ 4 inliers), anchor availability (the bottleneck), error propagation, OSM-noise simulation, test-set sizes.
- [[pretrained-models]] — Pretrained CNNs and foundation models per thesis task, resolution caveat, minimal fine-tuning stack.
- [[imagery-sources]] — Imagery for training (German DOP10/20, Tyrolean orthophotos) and testing (simulated metadata-free nadir crops); Sentinel-2 ruled out for objects.
- [[gnss-denied-use-cases]] — Application framing: GNSS-denied visual localisation, use-case table with prototype fit and evidence, research question, dual-use ethics.
- [[localization-improvements]] — Ranked levers to improve localisation: more cues (buildings, junctions, lines), better detector, multi-frame, priors, verification, terrain/DOP for the rest.
- [[settlement-overpass]] — Bridge between settlement detector and Overpass: dwelling tag rule + 100 m grid, query, use for labels, localisation and OSM completeness checks.
- [[settlement-detection]] — How stably inhabited areas can be detected in DOP20: settlements yes (stable across districts and years), single huts no; label caveats and thesis use.
- [[expose-material]] — Exposé material in German: bullet points, numbers and literature candidates per required section, plus a fact list for the AI-use documentation (no prose).
- [[expose-guide]] — Exposé checklist: required sections, deadlines, AI documentation, and which wiki pages supply each section.
- [[thesis-timeline]] — Thesis milestones per part-time semester and which courses feed the thesis.

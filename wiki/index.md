# Index

Catalog of every wiki page. One line each: `[[page]] — one-sentence summary`.
Updated on every ingest, filed query, or rename. Read this first when answering a question.

## Overview
- [[overview]] — Current big-picture understanding of ML/DL algorithm selection for recognising OSM/Overpass objects in orthoimagery, for the HOK master thesis.

## Sources
- [[thesis-goal]] — The author's own statement of the master thesis goal: an ML/DL method that recognises and classifies OSM objects (via Overpass Turbo) in orthoimagery, shown in a PoC platform.
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
- [[geopera-free-satellite-germany]] — Vendor blog (snippets): 10 free imagery sources for Germany; Sentinel-2 10 m; official German DOP10/20/40 orthophotos (NRW 10 cm, 3-year cycle).
- [[author-decision-search-region]] — Author decision: the search region is Oberbayern Süd.
- [[bayern-dop-regions-search]] — Search facts: Bavarian DOP20 (20 cm RGB+CIR) open under CC BY 4.0; Oberland 3,956 km² + Südostoberbayern 5,225 km².
- [[hok-dsia-program-listings]] — Third-party listing facts about the part-time MSc programme; the official page could not be fetched.

## Entities
- [[hok-dsia-master]] — The DSIA master's programme at HOK Kufstein Tirol (part-time form) in which the thesis is written.
- [[openstreetmap]] — The crowd-sourced world map whose features define the object classes.
- [[overpass-api]] — Read-only query API for OSM data; the backend Overpass Turbo calls.
- [[overpass-turbo]] — Web IDE for writing and visualising Overpass queries; defines which OSM objects count.
- [[oberbayern-sued]] — Search region and study area: planning regions Oberland + Südostoberbayern (about 9,181 km²), DOP20 imagery, Overpass area query.
- [[poc-platform]] — The proof-of-concept platform where orthoimagery is uploaded and detections are shown.

## Concepts
- [[orthoimagery]] — Orthorectified aerial or satellite images that line up with map coordinates; the input data.
- [[osm-weak-labels]] — Using OSM geometries from Overpass as noisy training labels instead of hand annotation.
- [[object-detection]] — Bounding box plus class per object; suits compact, countable features.
- [[semantic-segmentation]] — A class for every pixel; suits areal and linear features.
- [[ransac]] — Random Sample Consensus: robustly fits a transform (shift, rotation, scale) despite many wrong matches; the core of the geolocation matcher.
- [[spectral-texture-features]] — Colour, texture and shape cues that reveal land use (e.g. industrial areas) and power a classical ML baseline.

## Analyses
- [[thesis-poc-pipeline]] — Working end-to-end design: Overpass → labels → model → PoC platform.
- [[osm-object-catalog]] — Element types, primary OSM keys with main values, visibility in orthoimagery, thesis class shortlist, query templates.
- [[cv-detectability]] — What CV can and cannot recognise in orthoimagery, by task, object size and GSD, mapped to OSM tags.
- [[methods-10-25cm]] — Per-class detector/segmenter/classifier choice at 10–25 cm, three-head pipeline, scope cuts.
- [[osm-fingerprint-geolocalization]] — Two-factor fingerprint (anchor + neighbourhood constellation) to locate images via Overpass; uniqueness maths, urban vs. rural anchors, search procedure.
- [[pretrained-models]] — Pretrained CNNs and foundation models per thesis task, resolution caveat, minimal fine-tuning stack.
- [[imagery-sources]] — Imagery for training (German DOP10/20, Tyrolean orthophotos) and testing (simulated metadata-free nadir crops); Sentinel-2 ruled out for objects.
- [[thesis-timeline]] — Thesis milestones per part-time semester and which courses feed the thesis.

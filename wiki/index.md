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
- [[hok-dsia-program-listings]] — Third-party listing facts about the part-time MSc programme; the official page could not be fetched.

## Entities
- [[hok-dsia-master]] — The DSIA master's programme at HOK Kufstein Tirol (part-time form) in which the thesis is written.
- [[openstreetmap]] — The crowd-sourced world map whose features define the object classes.
- [[overpass-api]] — Read-only query API for OSM data; the backend Overpass Turbo calls.
- [[overpass-turbo]] — Web IDE for writing and visualising Overpass queries; defines which OSM objects count.
- [[poc-platform]] — The proof-of-concept platform where orthoimagery is uploaded and detections are shown.

## Concepts
- [[orthoimagery]] — Orthorectified aerial or satellite images that line up with map coordinates; the input data.
- [[osm-weak-labels]] — Using OSM geometries from Overpass as noisy training labels instead of hand annotation.
- [[object-detection]] — Bounding box plus class per object; suits compact, countable features.
- [[semantic-segmentation]] — A class for every pixel; suits areal and linear features.
- [[spectral-texture-features]] — Colour, texture and shape cues that reveal land use (e.g. industrial areas) and power a classical ML baseline.

## Analyses
- [[thesis-poc-pipeline]] — Working end-to-end design: Overpass → labels → model → PoC platform.
- [[osm-object-catalog]] — Element types, primary OSM keys with main values, visibility in orthoimagery, thesis class shortlist, query templates.
- [[cv-detectability]] — What CV can and cannot recognise in orthoimagery, by task, object size and GSD, mapped to OSM tags.
- [[thesis-timeline]] — Thesis milestones per part-time semester and which courses feed the thesis.

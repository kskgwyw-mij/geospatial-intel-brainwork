---
title: Thesis timeline & course fit
type: analysis
tags: [thesis, planning]
sources: [dsia-studienordnung-2027, thesis-goal, maggiori-osm-imperfect-labels]
updated: 2026-10-20
---
How the thesis goal maps onto the part-time DSIA semesters: when each thesis milestone happens and which course supplies what.

## Milestones (part-time form)

| Sem | Regulation says | What to do for this thesis |
|---|---|---|
| 1 | Statistical Learning 1, Data Engineering, Software Dev 1 ([[dsia-studienordnung-2027]]) | Learn Overpass QL and pull a first OSM sample for a candidate class (unsourced) |
| 2 | **ML & Deep Learning** (CNNs, end-to-end ML projects) ([[dsia-studienordnung-2027]]) | Use the portfolio assignments to try a small CNN on orthoimage chips labelled from OSM, if allowed (unsourced) |
| 3 | **Scientific Writing → exposé draft**; **Praxisprojekt**; AI (visual object recognition); DS for Eng. & Nat. Sci. (object recognition from images) ([[dsia-studienordnung-2027]]) | Write the exposé (problem, research question, method) and get it approved by the programme director. Use the Praxisprojekt as a pilot of [[thesis-poc-pipeline]] (unsourced) |
| 4 | **Thesis (20 ECTS) + committee exam (2 ECTS)**; colloquium presenting question, outline and method ([[dsia-studienordnung-2027]]) | Full experiments, the PoC on the [[poc-platform]], writing, defence |

Semester dates: winter KW 40 – KW 5, summer KW 11 – KW 28 ([[dsia-studienordnung-2027]]).
For a cohort starting WS 2027/28, semester 4 is summer 2029. Confirm the author's actual cohort. (unsourced)

## What the regulation implies for scoping
- The exposé must align the **problem, research question and method**
  ([[dsia-studienordnung-2027]]). "Build a PoC" alone is not a research question. A candidate:
  *How accurately can models trained only on OSM-derived weak labels recognise and classify
  class X in orthoimagery, compared with a classical ML baseline?* (unsourced) A sourced variant: *how much does a small hand-corrected set improve a model pretrained on Overpass labels?*, following the two-step scheme in [[maggiori-osm-imperfect-labels]].
- With metadata-free photos as input ([[author-decision-no-metadata]]), geolocation is part of the method. A natural research question: *how reliably can a metadata-free nadir photo be located, scaled and oriented from detected OSM objects, and how many objects are needed?*; see [[osm-fingerprint-geolocalization]].
- No geospatial courses exist in the curriculum ([[dsia-studienordnung-2027]]), so the
  thesis must cover the GIS basics itself: coordinate reference systems, rasters vs. vectors,
  [[overpass-api]] and [[orthoimagery]] sources.
- ETHR.1 covers GDPR and the AI Act ([[dsia-studienordnung-2027]]). High-resolution orthoimagery
  can show private property, so add a short legal and licence section. (unsourced)

## Related
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[hok-dsia-master]]

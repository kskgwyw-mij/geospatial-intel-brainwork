---
title: Thesis timeline & course fit
type: analysis
tags: [thesis, planning]
sources: [author-decision-title, hok-aspo-2026, wa-course-expose, dsia-studienordnung-2027, thesis-goal, maggiori-osm-imperfect-labels, author-note-use-cases-gnss-denied, author-decision-detection-in-scope]
updated: 2026-10-22
---
How the thesis goal maps onto the part-time DSIA semesters: when each thesis milestone happens and which course supplies what.

## Working title (author decision)
„Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen: Eine Generalisierungsstudie über Regionen und Bodenauflösungen“ ([[author-decision-title]]).

## Milestones (part-time form)

| Sem | Regulation says | What to do for this thesis |
|---|---|---|
| 1 | Statistical Learning 1, Data Engineering, Software Dev 1 ([[dsia-studienordnung-2027]]) | Learn Overpass QL and pull a first OSM sample for a candidate class (unsourced) |
| 2 | **ML & Deep Learning** (CNNs, end-to-end ML projects) ([[dsia-studienordnung-2027]]) | Use the portfolio assignments to try a small CNN on orthoimage chips labelled from OSM, if allowed (unsourced) |
| 3 | **Scientific Writing → exposé draft**; **Praxisprojekt**; AI (visual object recognition); DS for Eng. & Nat. Sci. (object recognition from images) ([[dsia-studienordnung-2027]]) | Write the exposé (problem, research question, method) and get it approved by the programme director. Use the Praxisprojekt as a pilot of [[thesis-poc-pipeline]] (unsourced) |
| 4 | **Thesis (20 ECTS) + committee exam (2 ECTS)**; colloquium presenting question, outline and method ([[dsia-studienordnung-2027]]) | Full experiments, the PoC on the [[poc-platform]], writing, defence |

Semester dates: winter KW 40 – KW 5, summer KW 11 – KW 28 ([[dsia-studienordnung-2027]]).

## Actual dates (cohort inferred from the course schedule)
The scientific-writing course with the exposé assignment runs in autumn 2026 ([[wa-course-expose]]), so the author is
most likely in **semester 3 = WS 2026/27**, and semester 4 is **SS 2027** (inference; confirm). The ingested
programme regulation applies to cohorts from WS 2027/28, so the author's own curriculum version may differ in detail.

| Date | Milestone |
|---|---|
| 23.10.2026 | Exposé + AI-documentation PDF due in the WA course ([[wa-course-expose]]) |
| 24.10.2026 | WA session: peer review and rebuttal ([[wa-course-expose]]) |
| 31.10.2026 | Thesis registration (form + exposé) on Moodle ([[wa-course-expose]]) |
| by end of WS 2026/27 | Exposé approved, supervisor assigned → processing time starts ([[hok-aspo-2026]]) |
| ≥ 6 months later, with ≥ 10 weeks in SS 2027 | Earliest submission, e.g. about May–July 2027 if approval comes in Nov–Dec 2026 ([[hok-aspo-2026]]; the dates are an inference) |
| ≤ 6 weeks after the processing time | Reviews by both reviewers ([[hok-aspo-2026]]) |
| afterwards | Committee exam: presentation 10 %, defence 50 %, curriculum questions 40 % ([[hok-aspo-2026]]) |

Formal limits: 10,000–15,000 words ±10 %, single-author, sworn declaration of independent work ([[hok-aspo-2026]]).
Exposé structure and checklist: [[expose-guide]].

## What the regulation implies for scoping
- The exposé must align the **problem, research question and method**
  ([[dsia-studienordnung-2027]]). "Build a PoC" alone is not a research question. A candidate:
  *How accurately can models trained only on OSM-derived weak labels recognise and classify
  class X in orthoimagery, compared with a classical ML baseline?* (unsourced) A sourced variant: *how much does a small hand-corrected set improve a model pretrained on Overpass labels?*, following the two-step scheme in [[maggiori-osm-imperfect-labels]].
- With metadata-free photos as input ([[author-decision-no-metadata]]), geolocation is part of the method. A natural research question: *how reliably can a metadata-free nadir photo be located, scaled and oriented from detected OSM objects, and how many objects are needed?*; see [[osm-fingerprint-geolocalization]].
- **Current preferred research question** ([[author-note-use-cases-gnss-denied]]): *"Wie zuverlässig lässt sich eine Drohnenaufnahme ohne Metadaten allein anhand erkannter OSM-Objekte lokalisieren, skalieren und ausrichten, und wie viele Objekte sind dafür in alpinen und ländlichen Gebieten nötig?"* Application framing: GNSS-denied visual localisation ([[gnss-denied-use-cases]]).
- **Detection is part of the thesis** ([[author-decision-detection-in-scope]]), so the question splits into two connected sub-questions (proposal, unsourced):
  - **FF1 (Erkennung):** How well can OSM-class anchor objects (pools, tennis courts, tanks, pylons, buildings…) be detected and classified in 20 cm nadir images when trained on OSM and official Bavarian labels? Metrics: per-class precision, recall, mAP and F1.
  - **FF2 (Lokalisierung):** How reliably can a metadata-free photo be located, scaled and oriented from *these real detections*, and how many objects are needed in Alpine and rural areas? Metrics: success rate, position, scale and heading error vs. number and type of anchors.
  - The link: FF1's measured recall, false-alarm rate and confusion matrix feed directly into the FF2 simulation and the end-to-end test ([[geo-match-prototype]]).
- No geospatial courses exist in the curriculum ([[dsia-studienordnung-2027]]), so the
  thesis must cover the GIS basics itself: coordinate reference systems, rasters vs. vectors,
  [[overpass-api]] and [[orthoimagery]] sources.
- ETHR.1 covers GDPR and the AI Act ([[dsia-studienordnung-2027]]). The method is dual-use (GNSS-independent navigation), so the ethics section must state the civilian scope ([[gnss-denied-use-cases]]). High-resolution orthoimagery
  can show private property, so add a short legal and licence section. (unsourced)

## Related
- [[feasibility]]
- [[thesis-goal]]
- [[thesis-poc-pipeline]]
- [[hok-dsia-master]]
- [[expose-guide]]
- [[hok-aspo-2026]]

---
title: Exposé guide — requirements and where the material is
type: analysis
tags: [thesis, expose, planning, ai-use]
sources: [wa-course-expose, hok-aspo-2026, hok-ki-leitlinie, dsia-studienordnung-2027, author-note-use-cases-gnss-denied, osm-real-test]
updated: 2026-10-22
---
A checklist of what the master exposé must contain and deliver, with pointers to the wiki pages holding the material for each section. It is deliberately not exposé text: the exposé must be the author's own writing.

## Deliverables and deadlines
| What | When | Rule |
|---|---|---|
| Exposé PDF (WA course, first version) | **23.10.2026**, Moodle | No author name in the document ([[wa-course-expose]]) |
| AI-documentation PDF | with the exposé | Tools used and for which tasks, plus an estimated AI share in %; **> 50 % not allowed** ([[wa-course-expose]]) |
| Thesis registration: form + exposé | **31.10.2026**, Moodle | The programme director approves the topic; propose a supervisor after talking to them ([[wa-course-expose]]) |
| Exposé approval | by the end of semester 3 at the latest | Otherwise a topic is assigned ([[hok-aspo-2026]]) |
| Review and rebuttal session | 24.10.2026 | Peer reviews of exposés ([[wa-course-expose]]); review received: [[peer-review-expose]] |

## Section checklist → wiki material
| Required section ([[wa-course-expose]]) | What the course asks for | Material in the wiki |
|---|---|---|
| **Arbeitstitel** | Simple, no abbreviations, ≤ about 8–12 words, one line, makes the reader curious | The research-question candidates in [[thesis-timeline]]. Avoid "OSM", "GNSS" and "DOP" unexplained in the title. |
| **Ausgangssituation und Problemstellung** | Starting situation and problem, with prior work | Problem: metadata-free photo → where, what scale, which heading ([[author-decision-no-metadata]], [[osm-fingerprint-geolocalization]]). Prior work: [[costea-2016-aerial-geolocalization]], [[maggiori-2017-hr-semantic-labeling]], [[maggiori-osm-imperfect-labels]], [[aerial-cv-benchmarks]]. Real-data finding that anchors are sparse: [[osm-real-test]] |
| **Relevanz** | Theoretical (knowledge gap) and practical (a real problem) | Practical: GNSS-denied drone localisation ([[gnss-denied-use-cases]], [[author-note-use-cases-gnss-denied]]); open Bavarian data makes it reproducible ([[bayern-opengeodata]]). Theoretical gap: rural and Alpine areas with few anchors ([[author-note-rural-roads]], [[feasibility]]). The use-case claims still need literature (see *Gaps*) |
| **Zielsetzung und Ergebnisse** | Scientific goals, practical goals, expected results (e.g. prototype), the derived research question | FF1 detection + FF2 localisation ([[thesis-timeline]]). Expected results: detector metrics per class, a localisation success-rate curve against anchor count, the PoC ([[poc-platform]], [[thesis-poc-pipeline]]) |
| **Vorgehensweise und Methoden** | Theoretical framework, steps, method per step | Pipeline: [[thesis-poc-pipeline]], [[coarse-to-fine-localization]]. Detection: [[methods-10-25cm]], [[pretrained-models]], [[object-detection]]. Matching: [[ransac]], [[geo-match-prototype]]. Data: [[imagery-sources]], [[bayern-dop20rgb-detail]], [[oberbayern-sued]]. Evaluation design and sample size: [[feasibility]] |
| **Literatur** | Prior work, relevance, existing results, method references | Source pages under *Sources* in [[index]]. Peer-reviewed references are still thin (see *Gaps*) |

## Scheme for the research question
The course's ladder is **Thema → Problem → Problembereich → Forschungsfrage** ([[wa-course-expose]]). The wiki's material fills it like this; the author's own wording is still needed:
- Thema: object recognition in aerial imagery with OpenStreetMap ([[thesis-goal]]).
- Problem: locating a photo without metadata ([[author-decision-no-metadata]]).
- Problembereich: drones without GNSS in rural and Alpine areas, where distinctive objects are scarce ([[gnss-denied-use-cases]], [[osm-real-test]]).
- Forschungsfrage: the current FF1/FF2 candidate in [[thesis-timeline]]; fix it with the supervisor ([[wa-course-expose]]).

## Consistency checks before submission
- The goals, the research question and the methods must line up ([[dsia-studienordnung-2027]]); every method step should serve FF1 or FF2.
- The scope fits ≥ 6 months of processing time with ≥ 10 weeks in semester 4, and 10–15k words ([[hok-aspo-2026]]). Keep the Alpine-edge region and a handful of anchor classes; buildings plus descriptors is the main extension ([[feasibility]]).
- Ethics and law: dual use (GNSS-independent navigation), DOP20 under CC BY 4.0, OSM under ODbL ([[gnss-denied-use-cases]], [[bayern-dop20rgb-detail]]).
- Name-free PDF; check the metadata (author field) too (unsourced).

## AI documentation — what to list
The course requires an exact list of tools and tasks ([[wa-course-expose]]); HOK requires transparent disclosure ([[hok-ki-leitlinie]]). In this project an AI assistant did the following, recorded in [[log]] and the git history:
- built and maintains this wiki: summaries of sources, cross-links, decision pages;
- wrote the prototype code in `tools/` (overlay, matcher, simulation, real-data test) and ran the simulations and the real-data test;
- did web searches and summarised papers and data portals.

The author decides how to rate this in the % estimate. The course's own guidance: AI for structure, feedback and literature is the "extension" level, while AI for data collection and analysis is discouraged ([[wa-course-expose]]). The experiments in the thesis itself should therefore be run, checked and understood by the author, who must be able to defend every decision; that is also the purpose of the defence, worth 50 % of the final exam ([[hok-aspo-2026]]).

## Gaps
- The use-case and relevance claims rest on an author note, not on literature: find 3–5 peer-reviewed sources on visual localisation of UAVs without GNSS.
- There are few method references for object-based geolocation beyond [[costea-2016-aerial-geolocalization]].
- The HOK master-thesis guide (Leitfaden: citation style, formatting) has not been ingested.
- Confirm which programme regulation applies to the author's cohort ([[dsia-studienordnung-2027]] is for cohorts from WS 2027/28).

## Related
- [[expose-review]]
- [[peer-review-expose]]
- [[expose-revision]]
- [[expose-material]]
- [[thesis-timeline]]
- [[hok-dsia-master]]
- [[wa-course-expose]]
- [[hok-aspo-2026]]
- [[hok-ki-leitlinie]]
- [[feasibility]]

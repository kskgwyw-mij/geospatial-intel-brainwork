---
title: How to improve localisation — ranked levers
type: analysis
tags: [geolocalization, planning, evaluation, thesis]
sources: [author-note-novelty, vtrn-literature-search, localization-levers-test, real-e2e-test, osm-real-test, settlement-test, settlement-overpass-labels, costea-2016-aerial-geolocalization, maggiori-osm-imperfect-labels, author-note-use-cases-gnss-denied, bayern-opengeodata]
updated: 2026-10-22
---
A ranked plan for raising localisation performance, ordered by the failure each lever fixes as measured on real data. **Coverage of map cues is the bottleneck**, detection quality is second, and priors and verification fix reliability.

## Where we are (real data)
| | Photos near anchors | Random photos |
|---|---|---|
| Located correctly (< 50 m) | 6/40 | 0/40 ([[real-e2e-test]]) |
| Unlocatable because < 2 detections | 18/40 | 36/40 have no anchor at all |
| Reliability of "confident" | 2/2 after the class-diversity fix (was 3/4) ([[localization-levers-test]]) | — |

## The levers, ranked
| # | Lever | Fixes | Evidence / expected gain | Effort |
|---|---|---|---|---|
| 1 | **More map cues: buildings + road junctions** as anchors | Coverage | Ceiling from 0.1–1.6 % to **34 %** of random photos ([[localization-levers-test]]). Junction constellations work in Costea: 90 % within 2.5 m ([[costea-2016-aerial-geolocalization]]). Buildings need descriptors (size, orientation, dwelling vs. outbuilding), since 75 % are `building=yes` ([[settlement-overpass-labels]]) | Medium: building segmentation + junction detection |
| 2 | **Line and area matching**: roads/tracks, water, forest edges, settlement mask | Coverage | Ceiling to **78 %** ([[localization-levers-test]]). Settlement masks are stable across years (AUC 0.98+, [[settlement-test]]). Method: segment the photo into road, water, forest and settlement; render OSM for a hypothesis; score by chamfer / IoU (unsourced) | High: needs a search strategy (retrieval) over x, y, scale, rotation |
| 3 | **Better detector** (fine-tune on DOP20 with OSM + ALKIS labels; add frequent local classes: barns and huts, power pylons, chapels, bridges) | Too few detections (18/40 sites have < 2) | Zero-shot DOTA: precision 0.49, recall 0.62 ([[real-e2e-test]]). Pretrain on OSM, then refine on a small clean set ([[maggiori-osm-imperfect-labels]]). Barn/hut-only hectares are 6,158 in Garmisch alone ([[settlement-overpass-labels]]) | Medium; this is FF1 anyway |
| 4 | **Multi-frame accumulation**: a flight yields many overlapping frames; chain them (visual odometry) into a strip of 1–2 km and match the strip | Coverage + uniqueness | Several overlapping photos cover several times the area, so cue counts rise and cues add up across frames (unsourced; follows from the coverage table) | Medium |
| 5 | **Priors from the use case**: last GNSS fix → region radius; known drone/camera → GSD band | Reliability, search cost | 5 km + scale prior: confident 4/4, probable 4/4, located 6 → 10/40 ([[localization-levers-test]]). GPS outage is a listed use case ([[author-note-use-cases-gnss-denied]]) | Low |
| 6 | **Verification and confidence**: point-process likelihood with measured detector errors + null hypothesis, as a calibrated heatmap ([[thesis-contribution]]); class-diversity rule (done, heuristic stand-in); render-and-compare check of the hypothesis against the photo's segmentation; size-consistency check against OSM polygons | False confident matches | The tank-farm error is caught by the class rule; density-aware chance scoring would not catch it ([[localization-levers-test]]) | Low–medium |
| 7 | **Terrain and imagery for the remaining 22 %** | No mapped cue | 22.2 % of random photos have no OSM cue ([[localization-levers-test]]). Options: dense registration against DOP20 (learned matchers) and DOM20/DGM1 relief ([[coarse-to-fine-localization]], [[bayern-opengeodata]]) | High; it is stage 3–4 of the pipeline |

## Recommendation for the thesis (proposal)
1. **Now, cheap:** keep the class-diversity rule, add the GSD/region priors as an explicit *scenario* (drone with a last-known fix vs. completely unknown photo), and report both.
2. **FF1 work that directly feeds FF2:** fine-tune detection and segmentation for buildings (+ dwelling/outbuilding), junctions and settlement masks (levers 1 and 3). This is where the measured ceiling moves from about 1 % to about 34 %.
3. **One coverage experiment beyond objects:** road/water/forest mask matching with chamfer scoring on the same real benchmark (lever 2), to show the path to about 78 %.
4. **State the limit honestly:** about a fifth of random Alpine-edge photos carry no mapped structure. Object-based OSM localisation cannot solve them; that is the boundary of the method, and a finding in itself.
5. **Keep the benchmark fixed:** the same seeds and saved detections (`dets_px` in the JSONL), so every matcher change is re-scored offline in seconds ([[localization-levers-test]]).

## Open questions
- Is a scale prior allowed within "no metadata" ([[author-decision-no-metadata]])? Knowing the drone type is not image metadata, but it should be decided explicitly.
- Should DOP20 imagery be used as a reference (image-to-image) or only OSM? A DOP-only baseline would be an informative comparison (unsourced).

## Related
- [[thesis-contribution]]
- [[terrain-relative-navigation]]
- [[localization-levers-test]]
- [[geo-match-prototype]]
- [[feasibility]]
- [[coarse-to-fine-localization]]
- [[settlement-overpass]]
- [[real-e2e-test]]

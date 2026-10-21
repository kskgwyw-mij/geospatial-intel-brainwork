---
title: Localisation levers — coverage ceilings, class-diversity rule, priors
type: source
tags: [real-data, evaluation, geolocalization, coverage]
sources: [localization-levers-test]
raw: raw/2026-10-21-localization-levers-notes.md
raw_data: [raw/2026-10-21-localization-coverage-gap.json, raw/2026-10-21-localization-priors-offline.json, raw/2026-10-21-real-e2e-anchor-v2.jsonl]
updated: 2026-10-21
---
Three measurements on real data that rank the ways to improve localisation. They cover how much of a random photo each map cue could cover, a matcher fix for repetitive single-class clusters, and region and scale priors replayed on saved real detections.

## Summary
- **Coverage:** 2,000 random 500 × 375 m footprints in Garmisch-Partenkirchen, scored against real OSM point anchors, buildings, junctions, roads, waterways, forest edges and power lines.
- **Matcher fix:** a class-diversity requirement for "confident". The 40 real anchor sites from [[real-e2e-test]] were rerun with identical sites and detections, and the detections are now saved.
- **Priors:** region and scale priors evaluated offline on those detections.

## Key claims
- **Point anchors cover almost nothing:** ≥ 4 DOTA-detectable anchors in **0.1 %** of random photos, and ≥ 4 of any anchor type in 1.6 % ([[localization-levers-test]]).
- **Buildings and junctions raise coverage to 34 %:** buildings ≥ 8 cover 16.2 %, road junctions ≥ 3 cover 31.6 %, and settlement cells appear in 8.0 % ([[localization-levers-test]]).
- **Line features raise it to 78 %:** visible roads/tracks ≥ 200 m are in 63.0 % of photos, waterways ≥ 100 m in 49.5 %, and forest edges ≥ 200 m in 18.0 % (a lower bound: forest multipolygons were not fetched). Any object or line cue appears in **77.8 %** ([[localization-levers-test]]).
- **22.2 % of random photos contain no mapped cue at all** (meadow, forest interior, rock), so only terrain or image texture can help there ([[localization-levers-test]]).
- **Class-diversity rule:** requiring ≥ 2 inlier classes for "confident" turns 3/4 into **2/2** correct. It demotes the wrong tank-farm match (63.5 km off) and one correct court-only match ([[localization-levers-test]]).
- **Density-aware chance scoring would not have caught it:** a regular tank lattice matched a denser one at 1.76× scale with 68 inliers ([[localization-levers-test]]).
- **Priors make answers trustworthy but barely add coverage:** a 5 km region prior plus a 0.16–0.25 m GSD prior gives confident 4/4, probable 4/4, and **10/40** located (from 6/40). 18/40 sites have < 2 detections and stay unlocatable ([[localization-levers-test]]).

## Relevance to this wiki
These are the numbers behind the ranked plan in [[localization-improvements]]: coverage first, then detection, with priors and verification for reliability.

## Pages touched
[[localization-improvements]], [[geo-match-prototype]], [[real-e2e-test]], [[feasibility]], [[overview]]

## Related
- [[real-e2e-test]]
- [[osm-real-test]]
- [[localization-improvements]]

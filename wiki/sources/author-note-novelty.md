---
title: Author note — novelty of the thesis combination (with verification)
type: source
tags: [thesis, literature, novelty, geolocalization]
sources: [author-note-novelty]
raw: raw/2026-10-22-author-note-novelty.md
updated: 2026-10-22
---
The author's novelty assessment: every ingredient exists in prior work, but their combination does not. The combination is POI-level classes detected in nadir imagery, a detector-error model inside a point-process likelihood, a calibrated heatmap with a null hypothesis, and a spatially blocked cross-region and cross-provider test. The cited works were checked by search; all but one are confirmed.

## Summary
The note lists four strands of prior work and states the gap as their combination. Search verification: Kunz et al. 2021, Shankar et al. 2016,
Hu & Dhillon 2024, MapLocNet, OSMLoc and SASGeo are confirmed. **arXiv 2608.07835 could not be found**, so do not cite it until it has been seen.

## Key claims
- **Object-to-OSM landmark matching with a scene graph exists for ground robots:** Kunz, Vierling, Wolf & Berns, SBR/LARS 2021, pp. 228–233 ([[author-note-novelty]]).
- **Subgraph matching against road and building-footprint graphs exists for urban image localisation:** Shankar et al., Electronic Imaging 28(15), 2016. The user builds the query graph by hand; uncertainty drops by up to 90 % in many cases over 2–47 km² ([[author-note-novelty]]).
- **Point-process models of indistinguishable landmarks exist as analysis, not as a pipeline:** Hu, Dhillon & Buehrer, arXiv 2409.09525 (2024). Localizability tends to 1 as landmark intensity grows; a marked-PPP follow-up is arXiv 2501.18758 ([[author-note-novelty]]).
- **OSM-based visual localisation exists at ground level:** OrienterNet (CVPR 2023), MapLocNet (arXiv 2407.08561), OSMLoc (arXiv 2411.08665). SASGeo adds ambiguity rejection but is synthetic only ([[author-note-novelty]], [[vtrn-literature-search]]).
- **The claimed gap is the combination**:
  - POI-level classes detected in **nadir** imagery;
  - an **explicit detector-error model** (recall, false alarms, confusion, position noise) inside a **point-process likelihood**;
  - a **calibrated heatmap with a null hypothesis**;
  - a **spatially blocked cross-region and cross-provider** test on real data.

  ([[author-note-novelty]])

## Relevance to this wiki
It defines the thesis contribution and changes the planned matcher, from inlier counting to a likelihood. See [[thesis-contribution]].

## Pages touched
[[thesis-contribution]], [[geo-match-prototype]], [[localization-improvements]], [[expose-material]], [[terrain-relative-navigation]], [[overview]]

## Related
- [[thesis-contribution]]
- [[vtrn-literature-search]]
- [[terrain-relative-navigation]]

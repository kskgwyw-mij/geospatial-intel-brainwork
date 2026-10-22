---
title: Thesis contribution — what is new, what exists, what it means for the method
type: analysis
tags: [thesis, novelty, geolocalization, method, evaluation]
sources: [author-literature-list, author-note-novelty, vtrn-literature-search, real-e2e-test, localization-levers-test, settlement-test, costea-2016-aerial-geolocalization]

updated: 2026-10-22
---
The thesis contribution is a combination that no prior work found so far contains: POI-level OSM classes detected in nadir imagery, matched through a point-process likelihood with an explicit detector-error model, giving a calibrated location heatmap with a null hypothesis, and evaluated on real data with spatially blocked cross-region and cross-provider tests. Each ingredient exists separately ([[author-note-novelty]]).

## Prior work per ingredient
| Ingredient | Exists in | Difference from this thesis |
|---|---|---|
| Detected objects matched to OSM landmarks | Kunz et al. 2021, scene graph ([[author-note-novelty]]) | Ground robot, urban, GNSS-supported |
| Graph / subgraph matching on roads and buildings | Shankar et al. 2016; Costea & Leordeanu 2016 ([[author-note-novelty]], [[costea-2016-aerial-geolocalization]]) | The query graph is built by hand (Shankar) or uses roads and intersections only (Costea); urban |
| Point-process model of indistinguishable landmarks | Hu, Dhillon & Buehrer 2024 ([[author-note-novelty]]) | Analysis of localizability, not a pipeline; no detector errors |
| OSM as a localisation reference, probabilistic filters | OrienterNet, MapLocNet, OSMLoc ([[author-note-novelty]], [[vtrn-literature-search]]) | Ground-level cameras, cities |
| Rejecting ambiguous fixes | SASGeo ([[vtrn-literature-search]]) | Synthetic proof of concept only; says real-flight validation is missing |
| Aerial image → map-like representation; vector/semantic map + particle filter | Schleiss 2019; Wei et al. 2022; Ouyang et al. 2024; SWA-PF 2025 ([[author-literature-list]]) | Titles only so far: **read the full texts to confirm the novelty boundary**, especially for detector-error modelling and null hypotheses |
| Multi-frame localisation in feature-sparse scenes | SeqLoc 2026 ([[author-literature-list]]) | Cross-view and sequence-based; relevant to the coverage limit and multi-frame lever |
| Image-to-orthophoto VTRN on UAVs | Conte & Doherty 2009; Goforth & Lucey 2019; Kinnari et al. 2022 ([[vtrn-literature-search]]) | Appearance matching, fragile across seasons; a candidate baseline |

## The four novel parts, concretely
1. **POI-level classes in nadir imagery.** Pools, courts, tanks, pylons and buildings (with footprint area and orientation as descriptors), detected from above, not road graphs or ground views. Measured so far: zero-shot precision 0.49 and recall 0.62 for point classes ([[real-e2e-test]]); settlement hectares AUC 0.98+ ([[settlement-test]]).
2. **A detector-error model inside a point-process likelihood (proposal).** For a pose hypothesis *h* (position, heading, scale), project the OSM objects into the photo. Then score:
   - each OSM object of class *c*: detected with recall *r_c*, labelled *c′* with confusion *P(c′|c)*, displaced by position noise *σ*;
   - each detection not explained by the map: a false alarm, drawn from a Poisson clutter process with intensity *λ_c′*.

   Log-likelihood:
   log L(h) = Σ_matched [log r_c + log P(c′|c) + log 𝒩(d; σ)] + Σ_undetected OSM log(1 − r_c) + Σ_unexplained detections log λ_c′.

   *r*, *P* and *λ* come from the FF1 measurements, not from guesses. This links FF1 to FF2 formally.
3. **A calibrated heatmap with a null hypothesis.** Evaluate log L(h) − log L₀ over a grid of poses. L₀ means "all detections are clutter, the photo is not locatable", and it is the null hypothesis. This gives a heatmap rather than one answer, and the method **abstains** when nothing beats L₀. Calibration: the probability mass inside a radius must match the empirical hit rate, checked with reliability diagrams (proposal, unsourced).
4. **Spatially blocked cross-region and cross-provider evaluation.**
   - Cross-region: train and tune in one district, test in another (as Miesbach → Garmisch in [[settlement-test]]).
   - Cross-provider: imagery from a different source, e.g. another state's orthophotos or real drone photos (unsourced; data still to be chosen, see [[imagery-sources]]).
   - Cross-year as a third axis: 2018 vs 2024 flights.


## Why the likelihood should beat the current inlier counting (testable hypothesis)
The current matcher counts inliers ([[geo-match-prototype]]). Its measured failure was a tank farm matched to a denser tank cluster 63.5 km away at 1.76× scale ([[real-e2e-test]]). Inlier counting rewards that pose: more objects lie nearby. The likelihood also charges **every OSM object in the hypothesised footprint that was not detected** (the log(1 − r) term). At 1.76× scale the footprint is about 3× larger and holds a denser cluster, so many objects go unexplained.

[[localization-levers-test]] found that a *density-aware chance score* would not have caught this case. The undetected-object term is a different mechanism, so the two findings do not contradict each other.

The current fix (≥ 2 inlier classes for "confident") is a heuristic stand-in. The likelihood is the principled version. It can be tested offline in seconds on the saved real detections (`dets_px` in `raw/2026-10-21-real-e2e-anchor-v2.jsonl`).

## What still has to be shown (open)
- That a likelihood with *measured* r, P, λ and σ is better calibrated than the inlier rule on the fixed real benchmark.
- A cross-provider data source: which second orthophoto or drone dataset, and under which licence.
- The coverage limit stays. About 22 % of random Alpine-edge photos contain no mapped cue ([[localization-levers-test]]). The null hypothesis turns these into honest abstentions instead of wrong answers, and that rate is itself a result.

## Buildings: geometric descriptors instead of dwelling/outbuilding split (decided)
The author agreed to drop the dwelling/outbuilding classification from the core scope. Reasons:
- **Noisy labels:** 74–76 % of buildings are `building=yes`, so the split rests on house numbers; shops and workshops have addresses, and unaddressed houses would count as outbuildings ([[settlement-overpass-labels]]).
- **Weak visual separability:** from nadir, a house and a large barn are both a roof, so high confusion would eat the information gain.
- **Scope pressure.**
- **The alternative is better:** footprint **area and orientation**, derived from OSM polygons, are reliable, visible from above and more discriminative for matching. [[osm-real-test]] already concluded that matching needs per-building descriptors because the class carries little information. This also matches the title's "Objektmerkmale".

The dwelling/outbuilding split remains possible as an outlook, and for settlement mapping ([[settlement-overpass]]).

## Scope reduction: FF3 folded into the evaluation design (applied in the exposé draft)
The author found the scope too large, especially FF3, which would re-measure detection, localisation, calibration and abstention in both regions. In the draft:
- only **FF1** (detection and error model) and **FF2** (likelihood vs inlier counting, including calibration) remain;
- transfer is an **evaluation design**: develop and tune in Miesbach, test only in Garmisch-Partenkirchen. The main question ends "… in einer nicht zur Entwicklung genutzten Region".

This keeps the title ("Generalisierungsstudie über Regionen") consistent at almost no extra cost, since a spatially separate test region is needed anyway. Further cuts if needed: optional classes (pylons, junctions), and a minimal prototype.

## Link to the research question
The four parts map onto FF1 (detection and error model), FF2 (likelihood, heatmap, calibration) and a possible FF3 (limits / abstention rate across regions and providers) in [[thesis-timeline]]. The research question itself is the author's to phrase ([[expose-material]]).

## Related
- [[author-literature-list]]
- [[author-note-novelty]]
- [[vtrn-literature-search]]
- [[terrain-relative-navigation]]
- [[geo-match-prototype]]
- [[localization-improvements]]
- [[expose-material]]

---
title: Thesis contribution — what is new, what exists, what it means for the method
type: analysis
tags: [thesis, novelty, geolocalization, method, evaluation]
sources: [settlement-overpass-labels, osm-real-test, author-decision-generalisation-axes, author-decision-title, author-literature-list, author-note-novelty, vtrn-literature-search, real-e2e-test, localization-levers-test, settlement-test, costea-2016-aerial-geolocalization]
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
1. **POI-level classes in nadir imagery.** Pools, courts, tanks, pylons, buildings and dwellings, detected from above, not road graphs or ground views. Measured so far: zero-shot precision 0.49 and recall 0.62 for point classes ([[real-e2e-test]]); settlement hectares AUC 0.98+ ([[settlement-test]]).
2. **A detector-error model inside a point-process likelihood (proposal).** For a pose hypothesis *h* (position, heading, scale), project the OSM objects into the photo. Then score:
   - each OSM object of class *c*: detected with recall *r_c*, labelled *c′* with confusion *P(c′|c)*, displaced by position noise *σ*;
   - each detection not explained by the map: a false alarm, drawn from a Poisson clutter process with intensity *λ_c′*.

   Log-likelihood:
   log L(h) = Σ_matched [log r_c + log P(c′|c) + log 𝒩(d; σ)] + Σ_undetected OSM log(1 − r_c) + Σ_unexplained detections log λ_c′.

   *r*, *P* and *λ* come from the FF1 measurements, not from guesses. This links FF1 to FF2 formally.
3. **A calibrated heatmap with a null hypothesis.** Evaluate log L(h) − log L₀ over a grid of poses. L₀ means "all detections are clutter, the photo is not locatable", and it is the null hypothesis. This gives a heatmap rather than one answer, and the method **abstains** when nothing beats L₀. Calibration: the probability mass inside a radius must match the empirical hit rate, checked with reliability diagrams (proposal, unsourced).
4. **Spatially blocked cross-region evaluation** (cross-provider dropped, [[author-decision-generalisation-axes]]).
   - Cross-region: train and tune in one district, test in another (as Miesbach → Garmisch in [[settlement-test]]).
   - Cross-provider: imagery from a different source, e.g. another state's orthophotos or real drone photos (unsourced; data still to be chosen, see [[imagery-sources]]).
   - Cross-year as a third axis: 2018 vs 2024 flights.

## Generalisation axes in the chosen title
> [!note] Decided
> Generalisation is across **regions only**: no cross-provider test, and GSD is not a study axis ([[author-decision-generalisation-axes]]). The notes below record how that decision was reached.

The first working title named **regions and ground sampling distances (GSD)** as the generalisation axes ([[author-decision-title]]).
- **Cross-region:** spatially blocked, e.g. Miesbach ↔ Garmisch.
- **Cross-GSD (Bodenauflösung):** test at ground sampling distances other than those used for tuning, e.g. DOP20 (0.2 m) resampled to 0.4 / 0.8 m, or imagery from different flight altitudes (proposal). Altitude-dependent VTRN is studied by Castleberry & Martin 2021 ([[author-literature-list]]).
- **Recommendation if one axis must go (assistant's view, awaiting the author's decision): keep regions, demote GSD.**
  - Spatial blocking is needed anyway against autocorrelation, the data exists, and Alpine vs pre-Alpine feature density *is* the method's limit ([[settlement-test]], [[localization-levers-test]]).
  - A realistic GSD shift needs real drone flights at several altitudes; downsampling DOP20 is only a proxy.
  - Small objects fall below detectability: a 6 m pool shrinks from about 30 px at 0.2 m to 7–8 px at 0.8 m.
  - Each GSD needs its own detector error rates and calibration.
  - Scale is estimated anyway in the metadata-free setting, so a fixed realistic band (e.g. 0.1–0.3 m) plus one or two resampled levels as a labelled robustness check is enough.
  - Exception: with real multi-altitude drone imagery, GSD becomes the more interesting axis; keep a minimal two-region block regardless.
- **Cross-provider** (from [[author-note-novelty]]) is not in the title. Decide whether it stays as a secondary test or is dropped.

## Object classes (proposal applied in the exposé draft)
| Group | Classes | Why | Evidence |
|---|---|---|---|
| Core A | swimming pools, tennis courts, soccer pitches, running tracks | DOTA zero-shot baseline exists; standardised sizes help the scale estimate | region counts 934 / 681 / 812 / 299 ([[osm-real-test]]); zero-shot P 0.49, R 0.62 ([[real-e2e-test]]) |
| Core B | storage tanks | in DOTA; clustered, so they test the lattice failure | 782 tanks; tank-farm error ([[real-e2e-test]]) |
| Core C | buildings, split into dwelling vs outbuilding | main coverage lever; the split comes from Overpass tags | about 43–55 /km²; ≥ 8 buildings in 16–23 % of photos ([[osm-real-test]], [[localization-levers-test]], [[settlement-overpass-labels]]) |
| Optional | power pylons, road junctions | most frequent point anchor / proven fingerprint (Costea), but they need new training or road segmentation | 3,780 pylons; ≥ 3 junctions in 32 % of photos ([[localization-levers-test]]) |

## Why the likelihood should beat the current inlier counting (testable hypothesis)
The current matcher counts inliers ([[geo-match-prototype]]). Its measured failure was a tank farm matched to a denser tank cluster 63.5 km away at 1.76× scale ([[real-e2e-test]]). Inlier counting rewards that pose: more objects lie nearby. The likelihood also charges **every OSM object in the hypothesised footprint that was not detected** (the log(1 − r) term). At 1.76× scale the footprint is about 3× larger and holds a denser cluster, so many objects go unexplained.

[[localization-levers-test]] found that a *density-aware chance score* would not have caught this case. The undetected-object term is a different mechanism, so the two findings do not contradict each other.

The current fix (≥ 2 inlier classes for "confident") is a heuristic stand-in. The likelihood is the principled version. It can be tested offline in seconds on the saved real detections (`dets_px` in `raw/2026-10-21-real-e2e-anchor-v2.jsonl`).

## What still has to be shown (open)
- That a likelihood with *measured* r, P, λ and σ is better calibrated than the inlier rule on the fixed real benchmark.
- A cross-provider data source: which second orthophoto or drone dataset, and under which licence.
- The coverage limit stays. About 22 % of random Alpine-edge photos contain no mapped cue ([[localization-levers-test]]). The null hypothesis turns these into honest abstentions instead of wrong answers, and that rate is itself a result.

## Link to the research question
The four parts map onto FF1 (detection and error model), FF2 (likelihood, heatmap, calibration) and a possible FF3 (limits / abstention rate across regions and providers) in [[thesis-timeline]]. The research question itself is the author's to phrase ([[expose-material]]).

## Related
- [[author-decision-generalisation-axes]]
- [[author-literature-list]]
- [[author-note-novelty]]
- [[vtrn-literature-search]]
- [[terrain-relative-navigation]]
- [[geo-match-prototype]]
- [[localization-improvements]]
- [[expose-material]]

---
title: Detecting inhabited areas stably in DOP20
type: analysis
tags: [settlement, land-use, classification, segmentation, evaluation]
sources: [settlement-overpass-labels, settlement-test, maggiori-2017-hr-semantic-labeling, methods-10-25cm-search, bayern-opengeodata, osm-real-test]
updated: 2026-10-21
---
How possible stable detection of inhabited areas is in the search region. **Very possible for settlements** (AUC ≈ 0.98–0.995 across districts and across six years). **Not possible for isolated single buildings** with a tile classifier: these are mostly huts and barns, which also say little about habitation.

## Answer in one table
| What "inhabited" means | Measured in our data ([[settlement-test]]) | Verdict |
|---|---|---|
| **Settlement**: ≥ 5 buildings per hectare (village, hamlet, town) | AUC 0.982–0.995 Miesbach → Garmisch; 0.984 on the 2018 flight; F1 about 0.89–0.91 | **Stable.** Ready as a thesis component |
| **Any building** in the hectare | AUC 0.965 (embedding) / 0.898 (colour); F1 0.76 at real prevalence | Moderate: misses single huts and barns |
| **Inhabited** in Overpass terms: ≥ 1 dwelling (residential type or house number, not an outbuilding) | AUC 0.984 Miesbach → Garmisch; 0.973 on 2018 ([[settlement-overpass-labels]]) | **Stable.** Better than "any building" |
| **Actually lived in** (residents) | Not measured | Needs population data (see below) |

"Stable" covers three tests, each costing at most about 0.02 AUC for settlements: a held-out area (2 km spatial blocks), a different landscape (pre-Alpine Miesbach → high-Alpine Garmisch), and a different flight (2024 → 2018), with 92–96 % same-cell agreement ([[settlement-test]]).

## Why it works
- Settlements combine many cues at once: roofs, sealed surfaces, gardens and regular geometry. Buildings are also the easiest segmentation class in aerial benchmarks (F1 about 95 on Vaihingen at 9 cm, [[maggiori-2017-hr-semantic-labeling]]).
- Features from a detector pretrained on aerial imagery (DOTA) generalise better than colour statistics. A linear probe on top suffices ([[settlement-test]], [[pretrained-models]]).
- Colour alone is weaker under transfer (0.898 vs 0.965 for "built"), which supports the caution about colour cues ([[spectral-texture-features]]). Even so, colour held up across the 2018 → 2024 flights better than expected.

## Where it breaks
- **Isolated small buildings.** Hay barns and Alpine huts (5–10 m) in a 100 m cell are 10 of 11 misses ([[settlement-test]]). They need an object detector or building segmentation at full resolution, not a 1-ha tile label ([[methods-10-25cm]]).
- **Look-alikes.** Roads across meadows, mown patterns, bare limestone and ponds cause the false alarms ([[settlement-test]]).
- **Rare class.** Settlement covers only 2–4 % of cells, so even an AUC of 0.995 gives modest precision at a naive threshold. Tune the threshold, or segment instead of classifying tiles (unsourced).
- **Label = OSM.** Completeness of OSM buildings is assumed. Half of random photo footprints have no building at all ([[osm-real-test]]), so absent labels are mostly true absences, but small unmapped huts exist.
- **Scope of the test:** two districts, one older flight (both flights' seasons unknown), linear probe only, about 400 uniform cells per district. Positives among uniform cells are few (9–15 for settlement), hence the wide CIs.

## Better labels for "inhabited" (unsourced unless cited)
- **Overpass dwelling rule** (measured): residential building types or `addr:housenumber` on non-outbuildings. 30 of 46 "built" Garmisch cells are outbuildings only. With this rule the detector improves ([[settlement-overpass-labels]]); the workflow is in [[settlement-overpass]].
- **ALKIS Tatsächliche Nutzung** gives official residential vs. industrial vs. farm land-use polygons in Bavaria ([[bayern-opengeodata]]).
- **Hausumringe / LoD2** give official footprints, partly with building function, which separates barns from houses ([[bayern-opengeodata]]).
- **Zensus 2022 population on a 100 m grid** would be the most direct "inhabited" label, and its cell size matches this test. Its availability and licence are not yet checked (unsourced).

## How to use it in the thesis
1. **As a robust first stage:** a settlement / no-settlement mask is cheap, stable across years and transfers across districts. For localisation it gives a coarse, season-robust layer: match the photo's settlement mask against the map's settlement layout before object matching ([[coarse-to-fine-localization]]; proposal).
2. **As an FF1 result:** a clean, honest experiment with spatial CV, cross-district and cross-year transfer, and hand-crafted vs. pretrained features. Next steps are a pixel-level segmentation model (U-Net) on Hausumringe or OSM masks, and fine-tuning instead of a linear probe ([[methods-10-25cm]]).
3. **Do not equate buildings with inhabitants**: define "inhabited" via residential land use or population, and report huts and barns separately.

## Related
- [[settlement-overpass]]
- [[settlement-test]]
- [[cv-detectability]]
- [[spectral-texture-features]]
- [[semantic-segmentation]]
- [[pretrained-models]]
- [[coarse-to-fine-localization]]
- [[methods-10-25cm]]

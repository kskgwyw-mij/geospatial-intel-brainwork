---
title: Overpass dwelling labels — tag statistics and relabelled settlement test
type: source
tags: [real-data, overpass, osm-tags, settlement, evaluation]
sources: [settlement-overpass-labels]
raw: raw/2026-10-21-settlement-overpass-notes.md
raw_data: [raw/2026-10-21-settlement-test-results-dwelling.json]
updated: 2026-10-21
---
The follow-up to [[settlement-test]]. It reports the building tags found in the Overpass exports, a rule that tells dwellings from outbuildings using only OSM tags, the detector's accuracy against that rule, and a live Overpass settlement grid for Garmisch-Partenkirchen.

## Summary
"Inhabited" was re-defined in Overpass terms as a residential building type or a house number on a non-outbuilding. The 1,100 test cells were relabelled with this
rule and the same features were re-evaluated. `tools/overpass_settlements.py` turns any Overpass area into a 100 m settlement grid with the same rule.

## Key claims
- **Building types are mostly unknown:** 74.1 % (Miesbach) and 75.9 % (Garmisch) are `building=yes` ([[settlement-overpass-labels]]).
- **House numbers carry the signal:** 34.6 % / 43.4 % of buildings have `addr:housenumber`, most of them on `building=yes`. With the dwelling rule, 40.0 % / 44.7 % of buildings count as dwellings and 9.6 % / 14.1 % are explicit outbuildings (barn, shed, hut, garage …) ([[settlement-overpass-labels]]).
- **The detector matches the Overpass definition better** than "any building":
  - inhabited (≥ 1 dwelling/ha): AUC 0.984 on Garmisch and 0.973 on the 2018 flight, vs 0.965 / 0.958 for "any building";
  - settlement (≥ 3 dwellings/ha): 0.982 on all Garmisch cells, 0.999 on uniform cells and 0.986 on 2018 (DOTA embedding, trained on Miesbach).

  ([[settlement-overpass-labels]])
- **Most "built" cells are not inhabited:** in uniform Garmisch cells, 30 of the 46 cells with a building contain only outbuildings ([[settlement-overpass-labels]]).
- **Live layer, Garmisch (relation 62726):** 10,315 non-empty hectares, of which 2,541 are settlement, 1,616 inhabited and 6,158 built only. Place nodes: 5 towns, 34 villages, 70 hamlets, 24 isolated dwellings. Settlement covers ≈ 2.5 % of the district, consistent with 2.2 % of random test cells. The busy mirror answered 504 once; the retry worked ([[settlement-overpass-labels]]).

## Relevance to this wiki
It makes the settlement detector and the Overpass map speak the same language; how to use this is in [[settlement-overpass]].
It also quantifies the weak `building=*` subtype labels noted in [[osm-object-catalog]].

## Pages touched
[[settlement-overpass]], [[settlement-detection]], [[osm-object-catalog]], [[overpass-api]], [[overview]]

## Related
- [[settlement-test]]
- [[settlement-overpass]]

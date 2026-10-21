# Settlement / built-up detection stability test on DOP20 (run 2026-10-21)

Test record written by the assistant for the author. Metrics table: `raw/2026-10-21-settlement-test-results.json`.
Error examples: `raw/assets/2026-10-21-settlement-test-errors-gap.jpg` (top row = false alarms, bottom row = misses,
Garmisch-Partenkirchen, uniform cells, embedding model, "built" target).
Imagery: Bayerische Vermessungsverwaltung, DOP20 via WMS, CC BY 4.0. OSM: © OpenStreetMap contributors, ODbL.

## Setup
- Script: `tools/settlement_test.py` (collect + analyse), seed 11.
- Cells: 100 × 100 m (1 ha, 500 × 500 px at 0.2 m). Per district: 400 uniform inside the district boundary + 150
  centred within ±40 m of a random OSM building. 1,100 cells in total.
- Districts: Landkreis Miesbach (MB; 47,261 OSM buildings), Landkreis Garmisch-Partenkirchen (GAP; 43,446 OSM buildings,
  fetched 2026-10-21 from the maps.mail.ru Overpass mirror).
- Labels from OSM building centroids: "built" = ≥ 1 building in the cell; "settlement" = ≥ 5 buildings in the cell.
  Prevalence in uniform cells: built MB 13.3 %, GAP 11.5 %; settlement MB 3.7 %, GAP 2.2 %.
- Imagery: current DOP20 (`by_dop20c`; equals the 2024 flight for the tested points) and the 2018 flight from the
  historical WMS (`by_dop_2018_h`). Only even years are flown here (2018, 2020, 2022, 2024); odd-year layers are blank.
- Features: (a) 23 hand-crafted colour/texture statistics (RGB mean/std, excess green, saturation, grey fraction,
  reddish fraction, gradient energy, edge density, block texture, grey histogram); (b) 512-d embedding of YOLO11s-OBB
  pretrained on DOTA (no fine-tuning).
- Classifier: standardised logistic regression (C = 0.1, balanced class weights), threshold 0.5.
- Protocols: spatial 5-fold CV in MB with 2 km blocks as groups; train on all MB 2024 → test GAP 2024; same model →
  GAP 2018 (spatial + temporal shift); same model → MB 2018 (temporal only; same cells as training, so optimistic).

## Results (AUC; 95 % bootstrap CI where computed)
| Target | Features | MB spatial CV | MB→GAP 2024 (all) | MB→GAP 2024 uniform | MB→GAP 2018 (all) | 2024 vs 2018 same-cell agreement (GAP) |
|---|---|---|---|---|---|---|
| built ≥ 1 | colour/texture | 0.965 | 0.922 | 0.898 [0.852, 0.936] | 0.913 [0.887, 0.938] | 94.7 % |
| built ≥ 1 | DOTA embedding | 0.969 | 0.965 | 0.965 [0.939, 0.986] | 0.958 [0.938, 0.974] | 92.5 % |
| settlement ≥ 5 | colour/texture | 0.970 | 0.959 | 0.967 [0.942, 0.986] | 0.943 [0.924, 0.960] | 94.5 % |
| settlement ≥ 5 | DOTA embedding | 0.985 | 0.982 | 0.995 [0.983, 1.000] | 0.984 [0.968, 0.995] | 95.5 % |

F1 / precision / recall at threshold 0.5 (DOTA embedding):
- settlement, MB→GAP all: F1 0.888, P 0.863, R 0.915; MB→GAP 2018: F1 0.907, P 0.899, R 0.915.
- settlement, GAP uniform only (9 positives of 400): P 0.444, R 0.889 — low precision at 2 % prevalence.
- built, MB→GAP all: F1 0.884, P 0.937, R 0.837; GAP uniform only (46 positives): P 0.761, R 0.761.

## Error inspection (GAP, uniform, built target, embedding model)
- 11 false negatives: 10 of them are cells with exactly one OSM building, almost all isolated hay barns / Alpine huts
  in meadows or at forest edges (5–10 m roofs); one is a village-edge cell with 7 buildings at the corner.
- 11 false positives: roads and tracks across meadows, mown field patterns, bare limestone rock, a pond with paths;
  one shows a small hut at the cell edge that is not counted in the cell (centroid outside or unmapped).

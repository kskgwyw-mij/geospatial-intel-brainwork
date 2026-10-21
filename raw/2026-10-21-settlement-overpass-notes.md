# Follow-up: "inhabited" defined in Overpass terms (2026-10-21)

Test record written by the assistant for the author, after the question "how can I transfer this to the Overpass API".
Metrics: `raw/2026-10-21-settlement-test-results-dwelling.json` (same 1,100 cells and features as
`2026-10-21-settlement-test-notes.md`, relabelled). Tool: `tools/overpass_settlements.py`.

## Building tags in the Overpass exports (2026-10-21)
- Miesbach 47,261 buildings: building=yes 74.1 %, garage 4.7 %, house 4.5 %, detached 3.0 %, residential 3.0 %,
  apartments 2.0 %, shed 1.7 %, barn 0.3 %; 34.6 % carry addr:housenumber (11,590 of them are building=yes).
- Garmisch-Partenkirchen 43,446 buildings: building=yes 75.9 %, shed 4.8 %, garage 4.0 %, house 2.8 %, apartments 2.5 %,
  barn 1.6 %, cabin 0.7 %, hut 0.6 %; 43.4 % carry addr:housenumber (15,429 of them are building=yes).

## Dwelling rule (used by both tools)
dwelling = building in {house, detached, residential, apartments, semidetached_house, terrace, farm, bungalow, hotel,
dormitory} OR (has addr:housenumber AND building not in {barn, shed, garage, garages, carport, hut, cabin,
farm_auxiliary, roof, service, chapel, stable, cowshed, hangar, greenhouse, transformer_tower, ruins}).
Share of buildings that are dwellings: Miesbach 40.0 %, Garmisch 44.7 %; explicit outbuilding types 9.6 % / 14.1 %.

## Results with the dwelling labels (DOTA embedding + logistic regression, trained on Miesbach 2024)
| Target | MB spatial CV | MB→GAP all | MB→GAP uniform (pos.) | MB→GAP 2018 | same-cell agreement |
|---|---|---|---|---|---|
| inhabited ≥ 1 dwelling/ha | 0.963 | 0.984 | 0.984 (16) | 0.973 | 93.6 % |
| settlement ≥ 3 dwellings/ha | 0.959 | 0.982 | 0.999 (7) | 0.986 | 95.5 % |
Colour/texture features: inhabited 0.960 / 0.937 / 0.957; settlement 0.959 / 0.983 / 0.952 (all, uniform, 2018).
Uniform Garmisch: 46 cells contain any building, but 30 of them contain no dwelling (only barns, huts, sheds, garages).

## Live Overpass layer for Garmisch-Partenkirchen (relation 62726, maps.mail.ru mirror)
`overpass_settlements.py --area-relation 62726`: 10,315 non-empty 100 m cells — settlement 2,541, inhabited 1,616,
built_only 6,158; place nodes: town 5, village 34, hamlet 70, isolated_dwelling 24, suburb 11. The first attempt got
HTTP 504 (busy mirror); the retry succeeded. The saved export gives the same grid within 3 cells (later edits).
Settlement cells ≈ 25 km² of the district's ~1,012 km² (≈ 2.5 %), consistent with 2.2 % in uniform test cells.

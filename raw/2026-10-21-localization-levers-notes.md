# Localisation levers: coverage ceilings, class-diversity rule, priors (2026-10-21)

Test record written by the assistant for the author, after the question "what could we do to improve performance on
localization". Data: `raw/2026-10-21-localization-coverage-gap.json`, `raw/2026-10-21-localization-priors-offline.json`,
`raw/2026-10-21-real-e2e-anchor-v2.jsonl` (rerun of the 40 anchor sites with saved detections).
OSM: © OpenStreetMap contributors, ODbL. Imagery: DOP20 © Bayerische Vermessungsverwaltung, CC BY 4.0.

## 1. Coverage ceilings per map cue (Garmisch-Partenkirchen)
2,000 photo footprints of 500 × 375 m, uniformly placed inside the district boundary, random rotation (seed 5).
OSM (fetched 2026-10-21, maps.mail.ru mirror; second attempt, the first returned an empty body): anchors export of
2026-10-21; 43,446 buildings; 32,284 ways with highway / waterway / natural=wood / landuse=forest / railway=rail /
power=line (`out geom`). Forests mapped as multipolygon relations were NOT fetched, so forest edge is a lower bound.
"Visible roads" = highway motorway … residential, service, track, links (paths and footways excluded).
Junction = road node shared by ≥ 2 visible-road ways (19,031 junctions). Settlement cell = 100 m cell with ≥ 3 dwellings.

| Cue in footprint | Share of random photos |
|---|---|
| DOTA-detectable point anchors ≥ 4 | 0.1 % |
| any point anchor ≥ 4 (incl. pylons, towers) | 1.6 % |
| buildings ≥ 1 / ≥ 8 | 39.4 % / 16.2 % |
| settlement cell ≥ 1 | 8.0 % |
| road junctions ≥ 3 | 31.6 % |
| visible roads/tracks ≥ 200 m | 63.0 % |
| forest edge ≥ 200 m (lower bound) | 18.0 % |
| waterway ≥ 100 m | 49.5 % |
| power line ≥ 100 m | 6.0 % |
| object cues (anchors ≥ 4 or buildings ≥ 8 or junctions ≥ 3) | 34.0 % |
| line cues (road ≥ 200 or forest edge ≥ 200 or water ≥ 100 or power ≥ 100) | 77.6 % |
| object or line cues | 77.8 % |
| no mapped cue at all | 22.2 % |
Caveat: mapped ≠ visible (tracks and streams under canopy).

## 2. Class-diversity rule (tools/geo_match.py, `min_classes=2`)
"confident" now also needs inliers from ≥ 2 classes. Rerun of the same 40 anchor sites (seed 7; identical sites, headings
and detections to the first run):
- before: confident 3/4 correct, probable 2/4, ambiguous 1/14; located 6/40.
- after: confident **2/2** correct, probable 3/6, ambiguous 1/14; located 6/40.
- changed: site 17 (tank farm, 63.5 km error, inliers all `tank`) confident → probable; site 12 (0.88 m, inliers all `court`) confident → probable.
A density-aware chance score would not have caught site 17: 68 inliers vs a chance expectation of a few, because a regular
tank lattice matches a denser lattice at 1.76× scale.

## 3. Priors, evaluated offline on the saved real detections (40 anchor sites)
Region prior = only OSM anchors within R of a prior centre, which is the truth shifted by a random offset (dead-reckoning error).
| Setting | Correct (< 50 m) | confident | probable | ambiguous |
|---|---|---|---|---|
| whole region (~7,800 km²), GSD 0.05–0.6 m | 6/40 | 2/2 | 3/6 | 1/14 |
| scale prior GSD 0.16–0.25 m | 8/40 | 3/3 | 4/9 | 1/9 |
| region prior 20 km radius (5 km offset) | 7/40 | 3/3 | 4/6 | 0/10 |
| region prior 5 km radius (1 km offset) | 8/40 | 4/4 | 3/5 | 1/3 |
| 5 km region + scale prior | **10/40** | 4/4 | 4/4 | 2/3 |
18 of 40 sites have < 2 detections and can never be located by the object matcher.

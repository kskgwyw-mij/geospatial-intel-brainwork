# Real OSM data for the search region: queries and measured statistics (2026-10-21)

Retrieved via the public Overpass mirror https://maps.mail.ru/osm/tools/overpass/api/interpreter (overpass-api.de was blocked).
OSM data © OpenStreetMap contributors, ODbL. Export of the anchor query: raw/2026-10-21-osm-anchors-alpine-edge.json (2.1 MB).

## Region areas (OSM relation ids, admin_level 6)
3600062472 Landkreis Bad Tölz-Wolfratshausen; 3600062600 Landkreis Weilheim-Schongau; 3600062712 Landkreis Berchtesgadener Land;
3600062726 Landkreis Garmisch-Partenkirchen; 3602156362 Landkreis Rosenheim; 3602156363 Landkreis Traunstein;
3602168231 Landkreis Miesbach; 3602168233 Rosenheim (city).

## Anchor query
[out:json][timeout:600];
area(id:3600062472,3600062600,3600062712,3600062726,3602156362,3602156363,3602168231,3602168233)->.r;
( nwr["leisure"~"^(swimming_pool|pitch|track)$"](area.r);
  nwr["man_made"~"^(storage_tank|silo|water_tower|tower)$"](area.r);
  nwr["power"~"^(tower|generator)$"](area.r);
  nwr["aerialway"~"^(pylon|station)$"](area.r); );
out center tags;

Result: 11,599 elements. Classes (first matching key; sport only for leisure=pitch):
power=tower 3780; leisure=swimming_pool 934; aerialway=pylon 856; sport=soccer 812; power=generator 789;
man_made=storage_tank 782; sport=tennis 681; man_made=tower 444; sport=equestrian 384; aerialway=station 348;
leisure=track 299; man_made=silo 191; sport=multi 174; sport=ice_stock 166; sport=beachvolleyball 146; others < 120 each.
Density over about 7,800 km²: about 1.5 anchors/km² in total (pools 0.12/km², tennis 0.09/km²).

## Buildings
Region-wide building count timed out (HTTP 504). Landkreis Miesbach (relation 3602168231):
way["building"](area); out center tags → 47,261 buildings (≈ 55/km² at ≈ 864 km², area approximate);
building=yes 35,017, garage 2,211, house 2,108, detached 1,412, residential 1,408, apartments 940, shed 794.

## Matcher on real OSM layout (tools/sim_geo_match.py --osm anchors.json --osm-noise 1, 100 photos each; detections simulated)
- Photos centred near a random object: 38 % located within 10 m; confident 30/30 correct; probable 5/15; median error 0.74 m;
  by detections: 0–2: 0/4, 3–4: 0/36, 5–7: 12/28, ≥ 8: 26/32.
- Photos uniformly placed in the region bbox: 1 % located; 89/100 photos had 0–2 detections; probable 1/2; no confident.

## Objects per photo footprint, Miesbach (3,000 random 600 × 450 m footprints within 2 km of a building)
≥ 1: buildings 49.1 %, point anchors 12.4 %; ≥ 4: 32.0 % / 2.1 %; ≥ 8: 23.1 % / 0.6 %; ≥ 20: 13.2 % / 0.1 %.
Median buildings per photo 0, mean 12.2.

---
title: OSM / Overpass object catalogue
type: analysis
tags: [osm, overpass, classes, catalogue]
sources: []
updated: 2026-10-20
---
Catalogue of what Overpass Turbo / the Overpass API can return: element types, the primary feature keys with their main values, and how visible each class is in orthoimagery. It is the menu for choosing the thesis classes.

> [!note] Provenance
> Written from model knowledge on 2026-10-20 because taginfo, the OSM wiki and overpass-api.de
> were unreachable from the research environment. Everything here is **(unsourced)** until
> a taginfo export or the OSM wiki *Map Features* page is ingested into `raw/`. The value lists
> are the common, documented ones, not every value in use (taginfo lists more than 100k keys).

## 1. Element types (what Overpass returns)

| Type | What it is | Overpass QL selector |
|---|---|---|
| node | A point with lat/lon | `node` |
| way | Ordered list of nodes: a line, or a closed ring/polygon | `way` |
| relation | Group of nodes, ways and relations with roles (multipolygons, routes, boundaries) | `rel` / `relation` |
| area | Derived by Overpass from closed ways and multipolygon relations; used for "inside X" filters | `area` |
| shorthand | node + way + relation, or subsets of them | `nwr`, `nw`, `wr`, `nr` |
| derived | Computed results (counts, `make` / `convert`) | `make`, `convert` |

Output modes: `out geom` (with coordinates), `out center`, `out bb`, `out tags`, `out meta`
(version, timestamp, user). Overpass Turbo exports results as GeoJSON, GPX or KML. (unsourced)

## 2. Primary feature keys and main values

Visibility in 10–20 cm RGB orthoimagery: ●●● clearly visible from above, ●● visible but
ambiguous or small, ● hardly visible or not visible (semantic only). Ratings are the author's
estimate. (unsourced)

| Key | Main values | Visibility | Notes for ML |
|---|---|---|---|
| `building` | yes, house, residential, detached, apartments, garage(s), shed, industrial, commercial, retail, warehouse, farm_auxiliary, barn, roof, church, school, hut, greenhouse, service, construction | ●●● footprint / ●● subtype | Best-covered class; the subtype is often `yes` → weak class labels |
| `highway` | motorway, trunk, primary, secondary, tertiary, unclassified, residential, service, track, path, footway, cycleway, steps, living_street, pedestrian; nodes: crossing, traffic_signals, bus_stop, street_lamp | ●●● roads / ● nodes | Lines → buffer for masks; road class is partly semantic |
| `landuse` | residential, commercial, industrial, retail, farmland, farmyard, meadow, orchard, vineyard, forest, grass, cemetery, allotments, construction, quarry, landfill, railway, military, greenhouse_horticulture, basin, reservoir | ●● | Large polygons; boundaries are fuzzy → segmentation |
| `natural` | wood, tree (node), tree_row, scrub, heath, grassland, wetland, water, beach, sand, scree, bare_rock, cliff, glacier, peak, spring | ●●● tree, water / ●● others | `natural=tree` is a good point-detection class |
| `water` (with natural=water) | lake, pond, river, reservoir, basin, canal, lagoon, stream_pool, wastewater | ●●● | Strong segmentation class |
| `waterway` | river, stream, canal, ditch, drain, weir, dam | ●● | Thin lines; often hidden under trees |
| `leisure` | swimming_pool, pitch, park, playground, garden, sports_centre, track, golf_course, stadium, marina, nature_reserve | ●●● pool, pitch, track / ● reserve | `swimming_pool` and `pitch` are classic detection classes |
| `amenity` | parking, parking_space, fuel, school, hospital, place_of_worship, restaurant, cafe, bench, bicycle_parking, charging_station, recycling, waste_basket, shelter, toilets, townhall, fountain | ●●● parking / ● most POIs | Most amenities are semantic, not visible; parking is visible |
| `man_made` | storage_tank, silo, tower, mast, chimney, water_tower, wastewater_plant, pier, bridge, pipeline, embankment, cutline, surveillance, wind turbine via `power` | ●●● tank, silo / ●● tower | Storage tanks and silos are compact round objects, well suited to detection |
| `power` | tower, pole, line, minor_line, substation, transformer, plant, generator (with `generator:source=solar\|wind\|hydro`) | ●●● solar, substation, line / ●● tower | `generator:source=solar` (rooftop PV) is a popular thesis class |
| `railway` | rail, light_rail, tram, subway, narrow_gauge, abandoned, disused, station, halt, platform, level_crossing, switch | ●●● rail / ●● station | Lines; platforms are visible |
| `aeroway` | aerodrome, runway, taxiway, apron, helipad, hangar, terminal | ●●● | Large, distinct shapes |
| `barrier` | fence, wall, hedge, gate, bollard, retaining_wall, guard_rail, kerb | ●● hedge, wall / ● fence | Thin lines; hard |
| `boundary` / `place` | administrative, protected_area / city, town, village, hamlet, locality | ● | Not visible; useful only as an area filter (`area[...]`) |
| `shop`, `office`, `craft`, `healthcare`, `tourism` (most values) | supermarket, bakery, …; company, …; hotel, museum, viewpoint, … | ● | Semantic POIs; exceptions: `tourism=camp_site`, `caravan_site` ●● |
| `historic` | castle, ruins, monument, memorial, wayside_cross, archaeological_site | ●● castle, ruins / ● others | Few samples |
| `military` | barracks, danger_area, bunker, airfield | ●● | Sensitive; check legal aspects |
| `aerialway` | cable_car, gondola, chair_lift, drag_lift, station, pylon | ●● | Relevant in Tyrol (ski areas) |
| `piste:type` | downhill, nordic | ●● (winter imagery) | Seasonal |
| `public_transport` | stop_position, platform, station | ● | Semantic |
| `emergency` | fire_hydrant, defibrillator, ambulance_station | ● | Not visible |
| `telecom` / `communication` | exchange / mast via `man_made=mast` | ●● | Small |
| `sport` (with leisure=pitch) | soccer, tennis, basketball, beachvolleyball, … | ●●● tennis, soccer | Good fine-grained classification on top of `leisure=pitch` |
| `surface` (attribute) | asphalt, paved, unpaved, gravel, grass, concrete | ●● | Classification attribute for roads and parking lots |
| `roof:shape`, `roof:material` (attributes) | flat, gabled, hipped, … / tiles, metal, … | ●●● shape | Classification target for buildings |

## 3. Shortlist for the thesis (visible, well mapped, enough samples)

Ranked by suitability for OSM-labelled orthoimagery. (unsourced)

1. `building=*` (footprints) → instance or semantic segmentation; optionally classify `roof:shape`.
2. `leisure=swimming_pool` → small, compact, distinctive → [[object-detection]].
3. `power=generator` + `generator:source=solar` → rooftop PV detection or segmentation; sparser in OSM, so label quality is a known issue.
4. `man_made=storage_tank` / `silo` → detection.
5. `leisure=pitch` + `sport=tennis|soccer|…` → detection plus fine-grained classification.
6. `natural=tree` → point detection; `natural=wood` / `landuse=forest` → segmentation.
7. `amenity=parking` (areas) / `highway=*` (buffered) → [[semantic-segmentation]].

## 4. Query templates

Overpass Turbo (the wizard syntax also works, e.g. `building=* in Kufstein`):

```
[out:json][timeout:120];
area["name"="Kufstein"]["boundary"="administrative"]->.a;
(
  nwr["leisure"="swimming_pool"](area.a);
  nwr["power"="generator"]["generator:source"="solar"](area.a);
);
out geom;
```

All values of one key in an area (for building a class list):

```
[out:json][timeout:180];
area["name"="Kufstein"]["boundary"="administrative"]->.a;
nwr["man_made"](area.a);
out tags;
```

Then count the values client-side, or in Overpass with `make stat` / `count`. (unsourced)

## Next step to make this sourced
Export the counts for the study area (taginfo or the Overpass `out tags` query above) to
`raw/` and `/ingest` them. That replaces the visibility guesses with real sample counts per class.

## Related
- [[overpass-api]]
- [[overpass-turbo]]
- [[openstreetmap]]
- [[osm-weak-labels]]
- [[thesis-poc-pipeline]]

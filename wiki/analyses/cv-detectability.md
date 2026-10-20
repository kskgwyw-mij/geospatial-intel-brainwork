---
title: What computer vision can detect in orthoimagery
type: analysis
tags: [computer-vision, classes, decision]
sources: [aerial-cv-benchmarks, author-note-industrial-colour]
updated: 2026-10-20
---
What computer vision can and cannot recognise in orthoimagery, by task type, object size and resolution, mapped to OSM tags, to decide the thesis classes.

## Rule of thumb: what limits detection
1. **Size in pixels.** An object needs roughly 10–20 px across to be detected reliably. DOTA v1.5 counts objects under 10 px as "extremely small" ([[aerial-cv-benchmarks]]). Minimum object size is about 10–20 × the GSD: at 20 cm per pixel, about 2–4 m. (unsourced)
2. **Visible from above.** Only what the roof or ground shows. Function, names, opening hours and indoor use are invisible. (unsourced)
3. **Occlusion and conditions.** Trees hide paths and streams, and shadows, season, snow and viewing angle (building lean in non-true orthophotos) all degrade results. (unsourced)
4. **Bands.** RGB only, or with near-infrared. NIR helps separate vegetation; ISPRS Vaihingen is IRRG ([[aerial-cv-benchmarks]]). Height (buildings, trees) needs a DSM/nDSM, not just the image. (unsourced)

## By CV task

| Task | Output | Typical aerial targets | OSM link |
|---|---|---|---|
| Image or tile **classification** | One label per tile | "contains PV yes/no", land-use type: industrial areas have a distinct colour ([[author-note-industrial-colour]]), plus texture and size cues, see [[spectral-texture-features]] | `landuse=industrial\|commercial\|residential\|farmland\|forest` |
| **[[object-detection]]** (boxes, oriented boxes) | Box + class per object | DOTA classes: plane, ship, storage tank, vehicles, tennis/basketball court, soccer field, track field, baseball diamond, swimming pool, bridge, harbor, roundabout, helicopter, container crane, airport, helipad ([[aerial-cv-benchmarks]]) | `aeroway`, `man_made=storage_tank`, `leisure=pitch`+`sport`, `leisure=swimming_pool`, `bridge=yes`, `junction=roundabout` |
| **[[semantic-segmentation]]** | Class per pixel | ISPRS classes: impervious surface, building, low vegetation, tree, car ([[aerial-cv-benchmarks]]); water, roads, forest | `building`, `highway`, `natural`, `landuse`, `water` |
| **Instance segmentation** | Mask per object | Building footprints (Inria: 30 cm, [[aerial-cv-benchmarks]]), PV arrays, single trees | `building=*`, `power=generator`, `natural=tree` |
| **Attribute classification** | Property of a detected object | Roof shape, roof material, surface type, sport type | `roof:shape`, `roof:material`, `surface`, `sport` (unsourced) |
| **Line or graph extraction** | Vector lines | Roads, railways, power lines, waterways | `highway`, `railway`, `power=line`, `waterway` (unsourced) |
| **Change detection** | What changed between two dates | New buildings, demolitions, new PV | OSM completeness and outdated-object checks (unsourced) |

## What works at which resolution (GSD) (unsourced)

| GSD | Reliably detectable |
|---|---|
| ≤ 10 cm (drone, Potsdam 5 cm) | Cars, road markings, manholes, small solar panels, single bushes, bollards |
| 10–25 cm (typical state orthophoto) | Buildings and roof shapes, pools, cars, PV arrays, trees, pitches, parking lots, tanks, sheds |
| 30–50 cm (Inria 30 cm, high-res satellite) | Buildings, roads, large vehicles, pools, tanks, sports fields |
| 1–3 m | Building blocks, major roads, fields, forest, water |
| 10 m (Sentinel-2) | Land cover and land use only (forest, farmland, built-up, water) |

## Mostly not detectable from imagery alone
Most `shop=*`, `office=*`, `amenity=*` POIs (restaurant, school, pharmacy…), names, addresses,
fine `building=*` function subtypes (a single house roof says little about its use), opening hours,
access rules, underground features (pipelines, tunnels), and anything under tree canopy.
These are context classes: the model can at best infer them from surroundings. (unsourced)

> [!note] Correction
> Coarse **land use** is an exception. Industrial areas differ visibly in colour
> ([[author-note-industrial-colour]]), and large halls, yards and truck parking add texture and
> shape cues. `landuse=industrial` is therefore detectable at the area level, even if a single
> building's function is not. See [[spectral-texture-features]].

## Implication for the thesis
The overlap of "computer vision detects it well" and "it exists in OSM via Overpass" is roughly the
DOTA/ISPRS-style classes: buildings, pools, storage tanks, sports pitches, vehicles and parking,
PV, trees, water, roads. See the shortlist in [[osm-object-catalog]]. Start with one well-mapped
detection class (for example `leisure=swimming_pool`) and one segmentation class (`building=*`). (unsourced)

## Related
- [[spectral-texture-features]]
- [[osm-object-catalog]]
- [[aerial-cv-benchmarks]]
- [[object-detection]]
- [[semantic-segmentation]]
- [[orthoimagery]]
- [[thesis-poc-pipeline]]

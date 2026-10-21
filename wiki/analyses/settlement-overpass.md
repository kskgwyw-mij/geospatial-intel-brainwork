---
title: From settlement detection to the Overpass API
type: analysis
tags: [overpass, settlement, osm-tags, localisation, workflow]
sources: [settlement-overpass-labels, settlement-test, osm-real-test, author-note-use-cases-gnss-denied]
updated: 2026-10-21
---
How the image-side settlement detector connects to Overpass. Both sides use one definition of "inhabited" built from OSM tags, compared on the same 100 m grid. Overpass supplies the labels for training, the reference map for localisation, and the baseline for finding unmapped buildings.

## 1. One definition, written in Overpass terms
The detector predicts per hectare. Overpass returns objects. The bridge is a tag rule applied to the Overpass result plus a 100 m grid ([[settlement-overpass-labels]]):

| Class per 100 m cell | Rule on the Overpass result | Garmisch (live) |
|---|---|---|
| `settlement` | ≥ 3 dwellings | 2,541 cells |
| `inhabited` | ≥ 1 dwelling | 1,616 |
| `built_only` | buildings, but no dwelling (barns, huts, sheds, garages) | 6,158 |
| (empty) | no building | — |

**Dwelling** = `building` ∈ {house, detached, residential, apartments, semidetached_house, terrace, farm, bungalow, hotel, dormitory},
**or** `addr:housenumber` on any building that is not an outbuilding type (barn, shed, garage(s), carport, hut, cabin, farm_auxiliary, roof, service, chapel, stable, …).
The house number does the work: about 75 % of buildings are only `building=yes`, but 35–43 % have an address ([[settlement-overpass-labels]]).

The query that `tools/overpass_settlements.py` sends (one request per area):
```
[out:json][timeout:600];
area(id:3600062726)->.r;                       // 3600000000 + relation id (here Lkr. Garmisch-Partenkirchen)
(way["building"](area.r);relation["building"](area.r););
out center tags;                               // centroid + tags, enough for the grid
node["place"~"^(city|town|village|hamlet|isolated_dwelling|suburb|neighbourhood)$"](area.r);
out;                                           // named settlement points
```
Overpass cannot aggregate to a grid itself, so gridding and the dwelling rule run client-side (unsourced: Overpass QL has no raster aggregation).
In Overpass Turbo the same query shows the raw objects. Dwellings only, for a quick visual check:
`nwr["building"]["addr:housenumber"]["building"!~"^(barn|shed|garage|garages|carport|hut|cabin|farm_auxiliary|roof)$"]({{bbox}}); out center;`

## 2. Overpass → detector (training and evaluation labels)
- For **any region**, run the tool with that area's relation id. The output gives training and test labels with the same definition. Cell size 100 m matches the detector input of 500 × 500 px at 0.2 m.
- Measured: with these labels, a detector trained in Miesbach reaches **AUC 0.984 (inhabited) and 0.999 (settlement, uniform cells)** in Garmisch, and **0.973 / 0.986 on the 2018 flight** ([[settlement-overpass-labels]]). The Overpass definition is *easier* to learn than "any building", because the barns and huts it excludes were the main misses ([[settlement-test]]).
- To change region, swap the relation id. The search region stays a parameter ([[oberbayern-sued]]).

## 3. Detector → Overpass (at inference)
1. **Localisation (GNSS-denied use case):** the photo yields a settlement mask, i.e. which parts of it are village, single farmstead or empty. Compare it with the Overpass settlement grid of the search region:
   - a coarse retrieval step: count, size and arrangement of settlement patches, robust across seasons and flights;
   - then object RANSAC inside the candidate villages ([[coarse-to-fine-localization]], [[geo-match-prototype]]).
   
   `place=*` nodes name the candidate ("hamlet X") (proposal, unsourced).
2. **Answering "where is it?" in OSM terms:** after localisation, query Overpass around the found position (`around:` filter, or `is_in`) for the place name, municipality and nearest addresses. This is the human-readable output for the [[poc-platform]] (unsourced).
3. **OSM completeness check:** cells the detector rates as inhabited where the Overpass layer is empty or `built_only` are candidates for unmapped houses or missing addresses. This is the OSM-maintenance use case in [[gnss-denied-use-cases]]. Review them by hand; never import them automatically (unsourced; OSM import rules apply).

## Limits of the tag rule
- Addresses also sit on shops, workshops and farm buildings, so "dwelling" really means "used, addressed building", which is close to inhabited but not equal to it (unsourced).
- An unaddressed `building=yes` counts as non-dwelling. Villages whose addresses are not yet mapped will be under-labelled (unsourced).
- OSM changes daily. Pin a dated export as a raw source for each experiment ([[osm-real-test]]).
- Official alternatives (ALKIS land use, building outlines with function) would remove the tag guesswork ([[settlement-detection]]).

## Related
- [[settlement-detection]]
- [[settlement-overpass-labels]]
- [[overpass-api]]
- [[overpass-turbo]]
- [[osm-object-catalog]]
- [[coarse-to-fine-localization]]

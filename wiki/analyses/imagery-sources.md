---
title: Imagery sources for training and testing
type: analysis
tags: [imagery, data-sources, decision]
sources: [bayern-dop20rgb-detail, bayern-opengeodata, german-dop-search, copernicus-browser, bayern-dop-regions-search, author-decision-search-region, geopera-free-satellite-germany, author-decision-no-metadata, pretrained-models-search, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-21
---
Which imagery to use for training (georeferenced, OSM-labelled) and testing (metadata-free nadir photos), ranked by fit with the thesis resolution of 10–25 cm.

## Requirements
- **Training:** georeferenced orthophotos at about 10–25 cm, with good OSM coverage, an open licence and known flight dates. Georeference is allowed here ([[author-decision-no-metadata]]).
- **Testing / PoC:** nadir photos used without metadata. A georeferenced original is kept aside as ground truth to score geolocation accuracy. (unsourced)

## Candidates

| Source | GSD | Coverage / update | Fit | Evidence |
|---|---|---|---|---|
| **Bavarian DOP20 RGB** (+ separate DOP20 CIR, bulk or service only) | 20 cm | All of Bavaria, including the search region [[oberbayern-sued]]; **CC BY 4.0**; 1 km GeoTIFF tiles in EPSG:25832, about 50 MB per tile; district bulk up to 126 GB; historical DOP via WMS ([[bayern-dop20rgb-detail]]) | ●●●● **first choice**: in-region training **and** test data | [[bayern-dop-regions-search]], [[bayern-opengeodata]] |
| **Bavarian DGM1 / DOM20 / laser points** | 1 m terrain; **20 cm surface model** | All of Bavaria, CC BY 4.0 | ●●●● terrain for geolocation; nDSM (DOM − DGM) as an extra input band | [[bayern-opengeodata]] |
| **Bavarian LoD2 + Hausumringe + Einzelbäume + ALKIS TN** | Vector (3D buildings, footprints, single trees, actual land use) | All of Bavaria | ●●●● official labels for buildings, roof shapes, trees and land use | [[bayern-opengeodata]] |
| Bavarian ATKIS Basis-DLM, ALKIS parcels | Vector | All of Bavaria; parcels carry a no-modification clause | ●●● rural anchors (fields, water, forest edges) | [[bayern-opengeodata]] |
| Commercial satellite (for example via Geopera) | up to 30 cm | Paid, taskable | ● coarser than free DOP20; only if aerial data is missing | [[geopera-free-satellite-germany]] |
| Landsat (NASA Earthdata) | 30 m | Global since 1972, free | ✗ for objects ("a football pitch is roughly one pixel") | [[geopera-free-satellite-germany]] |
| German state orthophotos **DOP10** (for example NRW) | 10 cm | Per Land; NRW renewed every 3 years | ●●● training at the upper resolution | [[german-dop-search]] |
| German state orthophotos **DOP20 / DOP40** | 20 / 40 cm | Nationwide; about 3-year actuality (Lower Saxony) | ●●● DOP20 for training; DOP40 is borderline | [[german-dop-search]] |
| Austrian orthophotos (basemap.at, Land Tirol) | about 10–25 cm | Tyrol (bordering the search region) | ●● out-of-region generalisation test; check licence | (unsourced) |
| ISPRS Potsdam / Vaihingen | 5 / 9 cm | Small benchmark tiles | ●● method comparison, not OSM-labelled | [[maggiori-2017-hr-semantic-labeling]] |
| Maxar (behind DINOv3-sat pretraining) | 0.6 m | Global, commercial | ● pretraining only | [[pretrained-models-search]] |
| Sentinel-2 (Copernicus) | 10 m | Global, 5-day revisit, free; quarterly and annual mosaics in the Copernicus Browser | ✗ for objects; land cover only | [[geopera-free-satellite-germany]], [[copernicus-browser]] |
| **Copernicus DEM GLO-30** (Copernicus Browser) | 30 m elevation | Global, free with registration (view service needs a CCM opt-in) | ●●● **terrain cue** for Alpine and rural geolocation; not for objects | [[copernicus-browser]] |
| Copernicus DEM EEA-10 | 10 m elevation | Europe; restricted user categories | ●● if access is granted | [[copernicus-browser]] |
| Copernicus VHR2024 mosaic | not stated | All of Europe; download only for EU or public research users, view-only for the public | ? check eligibility | [[copernicus-browser]] |
| Commercial aerial (for example Vexcel) | 7.5 cm urban | Paid | Optional | [[german-dop-search]] |

## Recommendation (updated for the search region [[oberbayern-sued]])
1. **Train and test on Bavarian DOP20** inside the search region ([[author-decision-search-region]]). It is open (CC BY 4.0, with attribution) and has a NIR band ([[bayern-dop-regions-search]]). **Split by district**, for example training on the Oberland districts (GAP, TÖL, MB, WM) and testing on RO, TS and BGL, so the test is spatially independent. (unsourced)
2. Optionally add NRW DOP10 for extra urban training data, and use Tyrolean orthophotos as an out-of-region generalisation test. (unsourced)
3. **Simulate metadata-free nadir test photos** by cropping held-out orthophotos, then rotating, rescaling and stripping coordinates. The true position, scale and heading are known, so geolocation error can be measured exactly.
4. Ignore Sentinel-2 for objects. Use it only for land-cover context, if at all.
5. **Terrain: use Bavarian DGM1 (1 m)** inside Bavaria ([[bayern-opengeodata]]); Copernicus DEM GLO-30 (30 m) only as a fallback outside Bavaria ([[copernicus-browser]]).
6. **Storage: sample, don't mirror.** The seven districts are about 7,800 tiles, roughly 156–390 GB ([[bayern-dop20rgb-detail]]). Download a stratified sample of tiles per district (urban, rural, Alpine) using the polygon bulk download (≤ 100 km² per request). (unsourced)
7. **Use historical DOP (WMS)** for cross-year robustness tests and old-photo localisation ([[bayern-dop20rgb-detail]]).
8. **Labels: combine OSM with official data.** Bavarian Hausumringe and LoD2 give building footprints and roof shapes; OSM remains the searched map ([[bayern-opengeodata]]).

## Related
- [[orthoimagery]]
- [[geopera-free-satellite-germany]]
- [[osm-fingerprint-geolocalization]]
- [[thesis-poc-pipeline]]

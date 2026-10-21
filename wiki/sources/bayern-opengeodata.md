---
title: Bayern OpenGeoData portal — product catalogue
type: source
tags: [open-data, bavaria, orthophotos, dem, buildings, lidar, land-use]
sources: [bayern-opengeodata, bayern-dop20rgb-detail]
raw: raw/2026-10-21-bayern-opendata-index-clip.md
superseded_raw: [raw/2026-10-21-bayern-opengeodata-search.md]
updated: 2026-10-21
---
The start page of the Bavarian surveying administration's OpenData portal (clipped by the author): about 40 free products, among them orthophotos (RGB and CIR), terrain and surface models at 1 m and 20 cm, LiDAR, LoD2 buildings, individual trees, building outlines, ALKIS land use and parcels, administrative areas and topographic maps.

## Summary
Full product list from the clip; it replaces the earlier snippet-based version of this page. Access types per product:
download, bulk download (Massendownload), service (WMS/WMTS). Licence details are on each product page; DOP20 is CC BY 4.0
([[bayern-dop20rgb-detail]]). The earlier snippet notes (`raw/2026-10-21-bayern-opengeodata-search.md`) remain as history.

## Key claims: product catalogue (with relevance)

| Product | Access | Use in this thesis |
|---|---|---|
| **DOP20 RGB** (20 cm) | download, bulk, service | Main imagery ([[bayern-dop20rgb-detail]]) |
| **DOP20 CIR** (20 cm, colour-infrared) | bulk, service only | NIR band for vegetation, NDVI ([[spectral-texture-features]]) |
| DOP40 RGB (40 cm) | download, bulk, service | Coarser fallback |
| **DGM1** (1 m terrain) / DGM5 | download, bulk, service / download, bulk | Terrain layer for geolocation |
| **DOM20** (20 cm surface model) | download, bulk | **nDSM = DOM20 − DGM1** at image resolution: object heights, lean correction, extra input band |
| DOM-Mesh | download | 3D surface; optional |
| Geländerelief, Höhenlinien | service, bulk | Terrain visualisation |
| **LoD2** 3D building models | download, bulk | **Roof shapes**, building heights |
| **Laserdaten** (LiDAR) | download, bulk | Raw 3D points |
| **Einzelbäume** (individual trees) | download | **Official single-tree labels** for tree detection |
| DOK 1:10,000; DTK25/50/100/500; DTK Vektor; Webkarte; TK50/100; ÜK2000 | various | Map context, not needed |
| **ATKIS Basis-DLM** | download, service | Official vector landscape model: roads, water, vegetation |
| **Hausumringe** | download | Official building footprints |
| ALKIS Parzellarkarte | service, bulk | Field and parcel mosaic (check the modification clause) |
| **ALKIS Tatsächliche Nutzung (TN)** | download, service | **Official land-use polygons** (industrial, residential, farmland…) |
| Landnutzung | download | Land use (product details not in the clip) |
| **ALKIS Verwaltungsgebiete** | download, service | **District polygons** for the search region |
| Festpunkte, geodetic reference points, Mittelpunkte | various | Not needed |
| Freizeitthemen, Bayernnetz für Radler, Radwege, Wanderwege | various | Possible rural line anchors (paths, trails) |
| Historische Karten und Ansichten | download | Historic context |

## Relevance to this wiki
- **Labels:** besides OSM there are official labels for buildings (Hausumringe, LoD2 roof shapes), trees (Einzelbäume) and land use
  (ALKIS TN), which helps the industrial-area class ([[author-note-industrial-colour]]). They can measure OSM label noise or
  replace it ([[osm-weak-labels]], [[methods-10-25cm]]).
- **Heights:** DOM20 − DGM1 gives an nDSM at the same 20 cm as the imagery ([[orthoimagery]], [[maggiori-2017-hr-semantic-labeling]]). (unsourced)
- **Terrain:** DGM1 (1 m) is the terrain cue inside Bavaria; Copernicus GLO-30 is only for outside Bavaria ([[copernicus-browser]]).
- **Region parameter:** ALKIS Verwaltungsgebiete gives exact district polygons for [[oberbayern-sued]], so the region no longer depends on an OSM name regex. (unsourced)
- **Rural anchors:** ATKIS, ALKIS parcels and trail networks support boundary and line matching ([[osm-fingerprint-geolocalization]]).
- **Thesis framing unchanged:** OSM remains the searched map; Bavarian data provides training labels, heights, terrain and evaluation.

## Pages touched
[[imagery-sources]], [[osm-weak-labels]], [[methods-10-25cm]], [[oberbayern-sued]], [[osm-fingerprint-geolocalization]], [[spectral-texture-features]], [[overview]]

## Related
- [[bayern-dop20rgb-detail]]
- [[bayern-dop-regions-search]]
- [[imagery-sources]]
- [[oberbayern-sued]]

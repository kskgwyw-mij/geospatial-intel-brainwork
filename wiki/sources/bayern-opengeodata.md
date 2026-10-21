---
title: Bayern OpenGeoData portal (DOP20 RGB + further datasets)
type: source
tags: [open-data, bavaria, orthophotos, dem, buildings, lidar]
sources: [bayern-opengeodata]
raw: raw/2026-10-21-bayern-opengeodata-search.md
updated: 2026-10-21
---
The Bavarian surveying administration's OpenGeoData portal, given by the author: DOP20 RGB orthophotos plus free terrain (DGM1), surface (DOM), LiDAR, LoD2 building, building-outline, ATKIS and ALKIS data for all of Bavaria, mostly CC BY 4.0. Ingested from search snippets because the site was blocked.

## Summary
Since early 2023 the Bayerische Vermessungsverwaltung publishes its core geodata for free: orthophotos (DOP20 RGB, DOP40),
terrain model DGM1/DGM5, surface model (DOM), laser points, 3D building models LoD2, building outlines (Hausumringe),
the ATKIS Basis-DLM landscape model, the ALKIS parcel map and topographic maps. Access is by download, bulk download
and services (WMS).

## Key claims
- **DOP20 RGB:**
  - 20 cm, free download, bulk download and WMS; CRS includes EPSG:25832 (UTM 32N); CC BY 4.0.
  - The federal DOP20 spec uses 1 × 1 km GeoTIFF tiles (JPEG-compressed) with a .csv metadata file per tile. The Bavarian tiling is assumed similar (unconfirmed).
- **DGM1 / DGM5:** terrain model at 1 m and 5 m grid for all of Bavaria, CC BY 4.0.
- **DOM** (surface model) is updated cyclically with the DOP.
- **Laser points** (LiDAR) were added in H1 2023.
- **LoD2** 3D buildings and **Hausumringe** building outlines; LoD2 is updated continuously.
- **ATKIS Basis-DLM** (official vector landscape model) and the **ALKIS parcel map**.
- **Licence:** attribution required. For sensitive data such as parcel boundaries, modification is not allowed. Other products may be edited and used commercially with attribution.
- A community bulk-download script exists (mueckl/opendata_bayern_download).

## Relevance to this wiki
These change several design choices for the search region [[oberbayern-sued]]:
- **Terrain:** DGM1 at 1 m is about 30× finer than Copernicus GLO-30 ([[copernicus-browser]]) and free. It becomes the terrain layer for Alpine and rural geolocation ([[osm-fingerprint-geolocalization]]).
- **DOM − DGM = nDSM** (object heights) for the whole region. It enables the DSM input band that helps building segmentation ([[maggiori-2017-hr-semantic-labeling]], [[methods-10-25cm-search]]) and a way to correct building lean ([[orthoimagery]]). (unsourced)
- **Better labels than OSM:**
  - Hausumringe give official building footprints.
  - **LoD2 gives roof shapes**, the classification target in [[methods-10-25cm]], which is rarely tagged in OSM.
  - Official data reduces label noise ([[osm-weak-labels]]). (unsourced)
- **Rural anchors:** ALKIS parcels and ATKIS give the field mosaic, watercourses and forest boundaries for boundary-map matching ([[rural-geolocalization-search]]). Check the "no modification" clause before deriving products from parcel data.
- **Thesis framing:** OSM stays the map that is searched (it is global and the thesis topic); the Bavarian data is used for training labels, terrain and evaluation. (unsourced)

## Pages touched
[[imagery-sources]], [[osm-fingerprint-geolocalization]], [[osm-weak-labels]], [[methods-10-25cm]], [[copernicus-browser]], [[bayern-dop-regions-search]], [[overview]]

## Related
- [[bayern-dop-regions-search]]
- [[imagery-sources]]
- [[oberbayern-sued]]

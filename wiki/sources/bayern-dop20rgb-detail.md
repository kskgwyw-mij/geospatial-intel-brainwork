---
title: Bayern OpenData — DOP20 RGB detail page
type: source
tags: [open-data, bavaria, orthophotos, download]
sources: [bayern-dop20rgb-detail]
raw: raw/2026-10-21-bayern-opendata-dop20rgb-clip.md
updated: 2026-10-21
---
Official product page for Bavaria's 20 cm RGB orthophoto: 1 × 1 km GeoTIFF tiles in UTM32 (EPSG:25832), CC BY 4.0, by single, polygon, municipality or district download, plus WMS (current and historical) and WMTS.

## Summary
DOP are rectified, true-to-scale aerial photos from the Bavarian state flight programme ("Bayernbefliegung"), with a 20 cm ground pixel.
Full page clipped by the author.

## Key claims

| Access | CRS / format | Tiling | Volume / limits | Update |
|---|---|---|---|---|
| Single download (BayernAtlas grid) | EPSG:25832, GeoTIFF | 1 km × 1 km | about **50 MB per tile** | in batches ("losweise") |
| Bulk download by polygon (Metalink .meta4; zip if ≤ 4 tiles) | EPSG:25832, GeoTIFF | 1 km × 1 km | about 20 MB per tile; max **100 km²**, max 20,000 polygon points | in batches |
| Bulk download per municipality (.meta4) | EPSG:25832, GeoTIFF | 1 km × 1 km | up to **24 GB per municipality** | in batches |
| Bulk download per district (.meta4) | EPSG:25832, GeoTIFF | 1 km × 1 km | up to **126 GB per district** | in batches |
| WMS DOP20 `https://geoservices.bayern.de/od/wms/dop/v1/dop20?` | 25832, 25833, 31468, 4326, 4258, 3857; PNG/JPEG/TIF | Bavaria-wide | — | in batches |
| **WMS historical DOP** `https://geoservices.bayern.de/od/wms/histdop/v1/histdop?` | same | Bavaria-wide | — | yearly |
| WMTS Geobasisdaten `…/od/wmts/geobasis/v1/1.0.0/WMTSCapabilities.xml` | 25832, 31468, 3857 | Bavaria-wide | — | in batches |

- Licence: CC BY 4.0 for all access paths. Data notes: `https://www.geodaten.bayern.de/odd/m/3/html/datenhinweise/datenhinweise_dop.html`.
- The page gives no single per-tile acquisition date. Updates come "losweise", i.e. different flight years per area.

## Relevance to this wiki
- Confirms the tiling that [[bayern-opengeodata]] had only assumed: **1 km tiles, GeoTIFF, EPSG:25832**. `tools/osm_overlay.py` reads GeoTIFF tags, but 25832 needs `pyproj` ([[imagery-sources]]).
- **Storage:** the seven districts of [[oberbayern-sued]] (about 7,800 km²) mean about 7,800 tiles, roughly 156–390 GB at 20–50 MB per tile (estimate). Use a **sample of tiles per district** for the thesis, not the full region. (unsourced)
- The **historical DOP WMS** (updated yearly) gives older flight years of the same place. Use it to test robustness across years and seasons, and for use case 4, locating old photos ([[gnss-denied-use-cases]]).
- "Losweise" updates mean the image date can differ from the OSM edit date by years; record the flight year per tile for [[osm-weak-labels]].

## Pages touched
[[bayern-opengeodata]], [[imagery-sources]], [[oberbayern-sued]], [[gnss-denied-use-cases]]

## Related
- [[bayern-opengeodata]]
- [[imagery-sources]]

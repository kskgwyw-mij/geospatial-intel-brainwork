---
title: Copernicus Browser (Copernicus Data Space Ecosystem)
type: source
tags: [imagery, dem, data-sources, open-data]
sources: [copernicus-browser]
raw: raw/2026-10-21-copernicus-browser-search.md
updated: 2026-10-21
---
The EU's free web browser for Copernicus data (Sentinel-1/2, mosaics, Contributing Missions, Copernicus DEM), suggested by the author as a second imagery source; most useful here for the elevation model, not for object imagery.

## Summary
The Copernicus Browser (part of CDSE) lets registered users search, view, compare, 3D-explore and download
Sentinel data, Sentinel-2 quarterly and annual mosaics, Copernicus Contributing Missions (CCM) collections
and federated datasets. Facts come from search snippets; the site was blocked from the research environment.

## Key claims
- Free, with a free account required for full use. Search by date, place, source and cloud cover; download full products or single files; compare; 3D.
- **Copernicus DEM:** GLO-30 (30 m, global) and GLO-90 are free for registered users. **EEA-10 (10 m, Europe) is restricted** to certain user categories. Since Aug 2026 the GLO-30 *view* service needs a CCM opt-in.
- **VHR2024** mosaic of Europe (via CCM): download is limited to Copernicus Services, EU institutions, EU-funded research and public authorities. **The general public can only view it.** Its resolution was not in the snippets.

> [!warning] Contradiction
> [[geopera-free-satellite-germany]] claims Copernicus access needs no registration. The CDSE documentation above says a free account is required. Trust the docs.

## Relevance to this wiki
- **Not an object-imagery source.** Sentinel-2 at 10 m is far too coarse for pools, tanks or roofs ([[cv-detectability]], [[imagery-sources]]).
  VHR2024 is probably out of reach for download by a master's student; check whether HOK research use qualifies. (unsourced)
- **Valuable for terrain:** Copernicus DEM GLO-30 provides the elevation model for the terrain cue in rural and Alpine geolocation
  ([[osm-fingerprint-geolocalization]], [[rural-geolocalization-search]]). This matters in the Alpine search region [[oberbayern-sued]].
  At 30 m it captures ridges and valleys, not buildings.
- Sentinel-2 mosaics can add coarse land-cover context, and a multi-season view helps tell fields apart. (unsourced)

## Pages touched
[[imagery-sources]], [[osm-fingerprint-geolocalization]], [[overview]]

## Related
- [[imagery-sources]]
- [[geopera-free-satellite-germany]]

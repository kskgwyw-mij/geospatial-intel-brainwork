---
title: Geopera — 10 best free sources of satellite data for Germany
type: source
tags: [imagery, data-sources, germany, open-data]
sources: [geopera-free-satellite-germany, copernicus-browser, bayern-dop-regions-search]
raw: raw/2026-10-21-geopera-free-satellite-germany-clip.md
updated: 2026-10-21
---
A vendor blog (Geopera, Darcy Weedman, 28 Oct 2025) listing ten free satellite and geodata sources for Germany, aimed at homeowners and generalists. Its key point for the thesis: free *satellite* data stops at 10–30 m, and commercial satellite tops out at about 30 cm.

## Summary
Full article clipped by the author. It replaces the earlier snippet-based version of this page. The list:
1. **Copernicus Data Space Ecosystem:** Sentinel-1 radar and Sentinel-2 optical.
2. **BKG geodata centre:** federal topographic data, DEMs, boundaries.
3. **Pera Portal:** the vendor's own; Sentinel-2 with 45+ spectral indices, plus paid commercial satellites.
4. **GeoPortal.de:** central portal for federal and state geodata (INSPIRE).
5. **Google Earth:** viewing only; history slider; 3D cities.
6. **State geoportals:** BayernAtlas, GEOportal.NRW, Geoportal BW, Berlin FIS-Broker, GeoSN, Hessen, LGLN.
7. **ESA Earth Online.**
8. **NASA Earthdata Search:** Landsat since 1972, MODIS.
9. **Maxar Open Data:** sub-metre imagery, disasters only.
10. **Zoom Earth:** weather.

It closes with a pitch for paid imagery.

## Key claims
- **Sentinel-2:** 10 m, 5-day revisit, archive since 2015. **Sentinel-1:** radar, all-weather, archive since 2014.
- **Landsat:** 30 m, "a football pitch is roughly one pixel"; archive since 1972 via NASA Earthdata.
- Free imagery is updated every few months to years and is lower resolution: "you can see buildings, but not detailed features". "Live" satellite views of a house do not exist.
- **Resolution wall** (the article's own table): Landsat 30 m gives regional land cover; Sentinel-2 10 m gives field-scale patterns, with "buildings are blurs"; commercial (Geopera) up to **30 cm** shows "individual vehicles, fence lines, solar panels, single trees".
- **State geoportals** are recommended for "high-resolution state-specific imagery" (Bavaria via BayernAtlas). Tip: start with Copernicus plus the state geoportals for German data.
- Maxar releases sub-metre imagery within 24–48 h of disasters (Rhine, Elbe, Danube floods).
- BKG offers DEMs and terrain data, often free without registration.

> [!warning] Contradiction
> The article says Copernicus offers "free access without download limits or **registration barriers**".
> The CDSE documentation says a **free account is required**, and the GLO-30 DEM view service needs a CCM
> opt-in since Aug 2026 ([[copernicus-browser]]). The official docs are newer and authoritative; treat the blog
> as outdated or simplified on access.

> [!warning] Bias
> Vendor blog. The summary lists its own Pera Portal first (it is no. 3 in the body), and the ending is a sales pitch.
> Use it as a pointer list.

## Relevance to this wiki
- **It confirms that free satellite data is useless for the object classes** (10–30 m), consistent with [[cv-detectability]] and [[imagery-sources]].
- **Commercial satellite at 30 cm is still coarser than Bavarian DOP20 at 20 cm,** which is free ([[bayern-dop-regions-search]]).
  So aerial state orthophotos beat paid satellite imagery for this thesis. (unsourced, from comparing the two sources)
- The pointer to **BayernAtlas** and the Bavarian state geoportal fits the search region [[oberbayern-sued]].
- **BKG DEMs** are a possible German alternative to the Copernicus DEM for the terrain cue; resolution not stated in the article.
- **Correction to the earlier snippet-based version:** the official DOP10/20/40 facts (AdV, NRW 10 cm on a 3-year cycle) are **not** in
  this article. They came from other results of the same search; see [[german-dop-search]].

## Pages touched
[[imagery-sources]], [[copernicus-browser]], [[overview]]

## Related
- [[german-dop-search]]
- [[imagery-sources]]
- [[copernicus-browser]]
- [[bayern-dop-regions-search]]

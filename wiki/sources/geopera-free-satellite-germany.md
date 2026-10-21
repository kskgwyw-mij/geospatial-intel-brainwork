---
title: Geopera — 10 free sources of satellite data for Germany (search notes)
type: source
tags: [imagery, data-sources, germany, open-data]
sources: [geopera-free-satellite-germany]
raw: raw/2026-10-21-geopera-free-satellite-germany.md
updated: 2026-10-21
---
A vendor blog listing free satellite and aerial imagery sources for Germany, ingested from search snippets, plus official facts on German state orthophotos (DOP10/20/40) that surfaced alongside it.

## Summary
Geopera's guide (Darcy Weedman, Oct 2025, updated Jun 2026) lists ten free sources: Pera Portal (the
vendor's own, ranked first), Copernicus, BKG, GeoPortal.de, Google Earth, state geoportals, ESA Earth
Online, NASA Earthdata, Maxar open disaster imagery and Zoom Earth. Its message: free *satellite* imagery
is coarse and infrequent, and high resolution usually costs money. The page itself was blocked, so this
page is built from search snippets.

## Key claims
- **Sentinel-2:** 10 m optical, 5-day revisit; **Sentinel-1:** radar archive. Both are free via Copernicus.
- Free imagery is updated every few months to years and is lower resolution: buildings are visible, details are not.
- **German state orthophotos (official, not from the blog):**
  - DOP20 and DOP40 are nationwide, and some Länder offer **DOP10**. Metadata is on GeoPortal.de (AdV).
  - **NRW: 10 cm, renewed every 3 years.** Lower Saxony DOP20: about 3-year actuality. Saxony: 20 cm. Mecklenburg-Vorpommern: published as WMTS.
- Commercial benchmark: Vexcel urban aerial imagery at 7.5 cm (paid).

> [!warning] Bias
> This is a vendor blog that ranks its own portal first. Use it as a pointer list, not as evidence.

## Relevance to this wiki
- **Training data:** German state DOP10/DOP20 orthophotos match the thesis resolution of 10–25 cm
  ([[methods-10-25cm]]). Paired with well-mapped German OSM, they are a strong source of georeferenced
  training imagery for [[osm-weak-labels]] (`tools/osm_overlay.py`), which [[author-decision-no-metadata]] still allows.
  Check each Land's licence; several publish DOP as open data. (unsourced)
- **Sentinel-2 at 10 m** is too coarse for the object classes. It is only useful for land cover ([[cv-detectability]]).
- The thesis is Austrian (Tyrol), and the blog covers Germany. Training on German DOP and applying to Tyrolean
  photos introduces a domain shift (roof styles, terrain, flight season), so it must be evaluated. (unsourced)

## Pages touched
[[orthoimagery]], [[imagery-sources]], [[overview]]

## Related
- [[imagery-sources]]
- [[orthoimagery]]

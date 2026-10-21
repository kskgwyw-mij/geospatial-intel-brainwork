---
title: Imagery sources for training and testing
type: analysis
tags: [imagery, data-sources, decision]
sources: [geopera-free-satellite-germany, author-decision-no-metadata, pretrained-models-search, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-21
---
Which imagery to use for training (georeferenced, OSM-labelled) and testing (metadata-free nadir photos), ranked by fit with the thesis resolution of 10–25 cm.

## Requirements
- **Training:** georeferenced orthophotos at about 10–25 cm, with good OSM coverage, an open licence and known flight dates. Georeference is allowed here ([[author-decision-no-metadata]]).
- **Testing / PoC:** nadir photos used without metadata. A georeferenced original is kept aside as ground truth to score geolocation accuracy. (unsourced)

## Candidates

| Source | GSD | Coverage / update | Fit | Evidence |
|---|---|---|---|---|
| German state orthophotos **DOP10** (for example NRW) | 10 cm | Per Land; NRW renewed every 3 years | ●●● training at the upper resolution | [[geopera-free-satellite-germany]] |
| German state orthophotos **DOP20 / DOP40** | 20 / 40 cm | Nationwide; about 3-year actuality (Lower Saxony) | ●●● DOP20 for training; DOP40 is borderline | [[geopera-free-satellite-germany]] |
| Austrian orthophotos (basemap.at, Land Tirol) | about 10–25 cm | Tyrol (the thesis region) | ●●● in-domain test and fine-tune data; check licence | (unsourced) |
| ISPRS Potsdam / Vaihingen | 5 / 9 cm | Small benchmark tiles | ●● method comparison, not OSM-labelled | [[maggiori-2017-hr-semantic-labeling]] |
| Maxar (behind DINOv3-sat pretraining) | 0.6 m | Global, commercial | ● pretraining only | [[pretrained-models-search]] |
| Sentinel-2 (Copernicus) | 10 m | Global, 5-day revisit, free | ✗ for objects; land cover only | [[geopera-free-satellite-germany]] |
| Commercial aerial (for example Vexcel) | 7.5 cm urban | Paid | Optional | [[geopera-free-satellite-germany]] |

## Recommendation (unsourced)
1. **Train** on German DOP10/DOP20 where licences are open and OSM is dense. That gives lots of labels cheaply via `tools/osm_overlay.py`.
2. **Fine-tune and test** on Tyrolean orthophotos to measure and close the Germany → Tyrol domain gap: Alpine roofs, terrain, snow, season.
3. **Simulate metadata-free nadir test photos** by cropping held-out orthophotos, then rotating, rescaling and stripping coordinates. The true position, scale and heading are known, so geolocation error can be measured exactly.
4. Ignore Sentinel-2 for objects. Use it only for land-cover context, if at all.

## Related
- [[orthoimagery]]
- [[geopera-free-satellite-germany]]
- [[osm-fingerprint-geolocalization]]
- [[thesis-poc-pipeline]]

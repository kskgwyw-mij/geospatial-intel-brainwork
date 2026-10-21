---
title: Imagery sources for training and testing
type: analysis
tags: [imagery, data-sources, decision]
sources: [bayern-dop-regions-search, author-decision-search-region, geopera-free-satellite-germany, author-decision-no-metadata, pretrained-models-search, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-21
---
Which imagery to use for training (georeferenced, OSM-labelled) and testing (metadata-free nadir photos), ranked by fit with the thesis resolution of 10–25 cm.

## Requirements
- **Training:** georeferenced orthophotos at about 10–25 cm, with good OSM coverage, an open licence and known flight dates. Georeference is allowed here ([[author-decision-no-metadata]]).
- **Testing / PoC:** nadir photos used without metadata. A georeferenced original is kept aside as ground truth to score geolocation accuracy. (unsourced)

## Candidates

| Source | GSD | Coverage / update | Fit | Evidence |
|---|---|---|---|---|
| **Bavarian DOP20** (RGB + colour-infrared) | 20 cm | All of Bavaria, including the search region [[oberbayern-sued]]; **CC BY 4.0**, WMS | ●●●● **first choice**: in-region training **and** test data | [[bayern-dop-regions-search]] |
| German state orthophotos **DOP10** (for example NRW) | 10 cm | Per Land; NRW renewed every 3 years | ●●● training at the upper resolution | [[geopera-free-satellite-germany]] |
| German state orthophotos **DOP20 / DOP40** | 20 / 40 cm | Nationwide; about 3-year actuality (Lower Saxony) | ●●● DOP20 for training; DOP40 is borderline | [[geopera-free-satellite-germany]] |
| Austrian orthophotos (basemap.at, Land Tirol) | about 10–25 cm | Tyrol (the thesis region) | ●●● in-domain test and fine-tune data; check licence | (unsourced) |
| ISPRS Potsdam / Vaihingen | 5 / 9 cm | Small benchmark tiles | ●● method comparison, not OSM-labelled | [[maggiori-2017-hr-semantic-labeling]] |
| Maxar (behind DINOv3-sat pretraining) | 0.6 m | Global, commercial | ● pretraining only | [[pretrained-models-search]] |
| Sentinel-2 (Copernicus) | 10 m | Global, 5-day revisit, free | ✗ for objects; land cover only | [[geopera-free-satellite-germany]] |
| Commercial aerial (for example Vexcel) | 7.5 cm urban | Paid | Optional | [[geopera-free-satellite-germany]] |

## Recommendation (updated for the search region [[oberbayern-sued]])
1. **Train and test on Bavarian DOP20** inside the search region ([[author-decision-search-region]]). It is open (CC BY 4.0, with attribution) and has a NIR band ([[bayern-dop-regions-search]]). **Split by district**, for example training on Oberland and testing on Südostoberbayern, so the test is spatially independent. (unsourced)
2. Optionally add NRW DOP10 for extra urban training data, and use Tyrolean orthophotos as an out-of-region generalisation test. (unsourced)
3. **Simulate metadata-free nadir test photos** by cropping held-out orthophotos, then rotating, rescaling and stripping coordinates. The true position, scale and heading are known, so geolocation error can be measured exactly.
4. Ignore Sentinel-2 for objects. Use it only for land-cover context, if at all.

## Related
- [[orthoimagery]]
- [[geopera-free-satellite-germany]]
- [[osm-fingerprint-geolocalization]]
- [[thesis-poc-pipeline]]

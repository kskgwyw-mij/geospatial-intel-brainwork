---
title: Colour, texture and shape cues
type: concept
tags: [features, land-use, classical-ml, computer-vision]
sources: [settlement-test, author-note-industrial-colour, dsia-studienordnung-2027, maggiori-2017-hr-semantic-labeling, bayern-opengeodata]
updated: 2026-10-21
---
Low-level image cues (colour, texture, shape, size) that let a model recognise land use, such as industrial areas, from orthoimagery, and that make a classical ML baseline possible.

## The observation
Industrial areas have a distinct colour in orthoimagery ([[author-note-industrial-colour]]).

## Why industrial areas stand out (unsourced)
- **Colour:** large grey, white or light-blue metal and membrane roofs; light concrete or asphalt yards; little green.
- **Texture:** homogeneous large surfaces, compared with the fine-grained mix of roofs, gardens and trees in residential areas.
- **Shape and size:** very large rectangular halls, wide turning areas, truck parking, storage tanks, rail sidings.
- **Context:** next to motorways, railways and rivers; separate from housing.

The same cues separate other land uses: farmland (field patterns and seasonal colour), forest
(dark, rough texture), residential (small roofs plus gardens), commercial/retail (large roofs
plus big car parks). (unsourced)

## How to use it in the thesis
- **Classical baseline:** per tile or per segment, compute colour histograms or statistics
  (RGB/HSV, plus NDVI if NIR is available), texture (GLCM, local binary patterns) and shape
  features, then train a random forest. This is a natural baseline next to a CNN, and the
  regulation teaches random forests ([[dsia-studienordnung-2027]]). (unsourced)
- **Official labels in Bavaria:** ALKIS Tatsächliche Nutzung (actual land use) and DOP20 CIR (NIR for NDVI) are open data ([[bayern-opengeodata]]).
- **Deep learning:** CNNs learn these cues implicitly. Tile classification or
  [[semantic-segmentation]] on `landuse=industrial|commercial|retail|residential` polygons
  from Overpass is a cheap first experiment with [[osm-weak-labels]]. (unsourced)

## Caveats (unsourced)
- Colour alone is ambiguous: a grey pixel can be roof or asphalt, and only the surrounding context decides ([[maggiori-2017-hr-semantic-labeling]]). CNNs learn such colour-plus-context rules, for example "red, inside a larger red rectangle, surrounded by vegetation, near a road → building" (same source).
- Colour alone is fragile. It changes between orthophoto flights, sensors and seasons, with
  sun angle and haze, and with roof material, so normalise radiometry and test across flight
  years and regions.
- Not every industrial roof is grey (red roofs, PV-covered roofs), and some non-industrial
  buildings (supermarkets, sports halls, farm buildings) look industrial. Expect confusion
  between `industrial`, `commercial` and `retail`, and between `farmyard` and `industrial`.
- OSM `landuse` polygon boundaries are drawn loosely, so pixel labels near the edges are noisy.

## Measured in the search region
23 colour/texture statistics plus logistic regression detect settlement hectares with AUC 0.959 Miesbach → Garmisch and 0.943 on the 2018 flight. A pretrained DOTA embedding does better (0.982 / 0.984), and the gap is largest under transfer and for single buildings (0.898 vs 0.965). Colour cues held up across flight years better than feared, but pretrained features are the safer default ([[settlement-test]], [[settlement-detection]]).

## Related
- [[settlement-detection]]
- [[cv-detectability]]
- [[semantic-segmentation]]
- [[osm-weak-labels]]
- [[osm-object-catalog]]
- [[thesis-poc-pipeline]]

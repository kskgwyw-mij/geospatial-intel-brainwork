---
title: OSM as weak labels
type: concept
tags: [labels, weak-supervision, osm]
sources: [thesis-goal, maggiori-osm-imperfect-labels, costea-2016-aerial-geolocalization, author-decision-nadir-input, bayern-opengeodata]
updated: 2026-10-20
---
Using OSM geometries pulled through Overpass as (noisy) training labels for orthoimagery, instead of annotating by hand.

- The thesis targets objects that exist in OSM, so OSM can serve as the label source ([[thesis-goal]]).
- Polygons become segmentation masks or instance masks; their bounding boxes become detection labels; points (for example `power=tower`) need a box size or a point-based method. (unsourced)
- Known noise sources: misalignment between OSM and the imagery (offsets of a few metres), missing objects (false negatives in the labels), objects that are outdated relative to the image date, and inconsistent tagging. (unsourced)
- Published precedent: pretrain an FCN on large imperfect OSM labels, then refine on a small accurate set. OSM alone teaches only rough locations because of misregistration and omissions ([[maggiori-osm-imperfect-labels]]).
- OSM can miss objects that are clearly visible (detected intersections absent from OSM). Conversely, aligning OSM to detections and fusing them (soft-dilate, multiply, thin) raised road F from 66.5 % to 93.9 % ([[costea-2016-aerial-geolocalization]]). The same trick could clean training labels. (unsourced)
- Tooling: `tools/osm_overlay.py` projects an Overpass Turbo GeoJSON export onto a north-up nadir image (GeoTIFF tags, world file, or lon/lat bbox for Web-Mercator screenshots) and writes pixel labels. It inherits every OSM offset and omission, so it is label projection, not detection.
- On **raw nadir frames** (the thesis input, [[author-decision-nadir-input]]), projected labels carry more error: GPS position (metres), heading, flat-ground and exact-nadir assumptions, and relief displacement of tall objects. Refine by aligning projected OSM to detections, as in the Chamfer/RANSAC step of [[costea-2016-aerial-geolocalization]]. (unsourced)
- **Official alternative in Bavaria:** Hausumringe (building outlines) and LoD2 (3D buildings with roof shapes) are open data ([[bayern-opengeodata]]). Use them to measure OSM label noise, or as cleaner labels for buildings and roof shapes. (unsourced)
- Common mitigations: pick regions known to be well mapped, check a sample by hand to estimate label quality, keep a small hand-corrected test set, and use loss functions or training schemes that tolerate noise. (unsourced)

## Related
- [[maggiori-osm-imperfect-labels]]
- [[openstreetmap]]
- [[orthoimagery]]
- [[object-detection]]
- [[semantic-segmentation]]
- [[thesis-poc-pipeline]]

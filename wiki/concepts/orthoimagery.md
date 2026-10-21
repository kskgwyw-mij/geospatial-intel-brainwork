---
title: Orthoimagery
type: concept
tags: [imagery, remote-sensing]
sources: [thesis-goal, maggiori-2017-hr-semantic-labeling]
updated: 2026-10-20
---
Aerial or satellite images that are geometrically corrected (orthorectified), so they line up with map coordinates; the input data of the thesis.

- Input modality of the thesis model and of the [[poc-platform]] ([[thesis-goal]]).
- Because orthoimages are georeferenced, OSM vectors can be projected straight onto pixels to make labels; see [[osm-weak-labels]]. (unsourced)
- Key properties to pin down: ground sample distance (cm per pixel), bands (RGB / RGB+NIR), acquisition date (compared with OSM edit dates), and licence. (unsourced)
- A DSM/nDSM (surface heights) can be stacked as an extra input band next to the colour bands ([[maggiori-2017-hr-semantic-labeling]]).
- For Austria, the state-run basemap.at orthophoto and the regional (Land) orthophotos are candidate sources; check resolution and licence before use. (unsourced)

## Related
- [[osm-weak-labels]]
- [[object-detection]]
- [[semantic-segmentation]]

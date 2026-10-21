---
title: Orthoimagery
type: concept
tags: [imagery, remote-sensing]
sources: [thesis-goal, maggiori-2017-hr-semantic-labeling, author-decision-nadir-input, german-dop-search, bayern-dop-regions-search]
updated: 2026-10-20
---
Aerial or satellite images that are geometrically corrected (orthorectified), so they line up with map coordinates; the input data of the thesis.

- Input modality of the thesis model and of the [[poc-platform]] ([[thesis-goal]]).
- Because orthoimages are georeferenced, OSM vectors can be projected straight onto pixels to make labels; see [[osm-weak-labels]]. (unsourced)
- Key properties to pin down: ground sample distance (cm per pixel), bands (RGB / RGB+NIR), acquisition date (compared with OSM edit dates), and licence. (unsourced)
- A DSM/nDSM (surface heights) can be stacked as an extra input band next to the colour bands ([[maggiori-2017-hr-semantic-labeling]]).
- **Bavaria (the search region):** DOP20, 20 cm RGB + colour-infrared, open under CC BY 4.0 ([[bayern-dop-regions-search]]).
- Germany: state orthophotos DOP20/DOP40 nationwide, DOP10 in some Länder (NRW: 10 cm, 3-year cycle) ([[german-dop-search]]). Source comparison: [[imagery-sources]].
- For Austria, the state-run basemap.at orthophoto and the regional (Land) orthophotos are candidate sources; check resolution and licence before use. (unsourced)

## Nadir vs. ortho vs. true ortho (unsourced)
| | Nadir image | Orthoimage | True orthoimage |
|---|---|---|---|
| What it is | A raw photo taken looking **straight down**. Nadir describes the viewing direction | A **processed product**: nadir photos rectified with a terrain model (DTM) and camera orientation, resampled into a map projection, usually mosaicked | Same, but rectified with a surface model (DSM) that includes buildings and trees |
| Geometry | Central perspective: scale varies with terrain height; tall objects lean radially away from the image centre (relief displacement d = r·h/H); lens distortion | Uniform scale, north-up, georeferenced; terrain corrected | Uniform scale; roofs sit exactly over footprints; hidden areas filled from other photos |
| Remaining error | Everything above | **Buildings and trees still lean**, so roofs are offset from footprints, more at the edge of each source photo | Small; artefacts at occlusion edges |
| Can you measure on it? | Not directly | Yes, like a map, for ground-level objects | Yes, also for roofs |
| Typical source | Drone frame, single aerial survey photo | State orthophotos (for example basemap.at) | Special products; more expensive |

Rule of thumb: nadir describes **how** the photo was taken; ortho describes **what processing** was applied.
Every orthophoto starts from nadir (or near-nadir) photos, but a nadir photo is not an orthophoto until it
is orthorectified. Oblique imagery is the opposite of nadir: the camera is tilted.

**Thesis decision:** nadir images are the required input; orthoimages are the ideal case, not a requirement ([[author-decision-nadir-input]]).

Consequences for this thesis:
- `tools/osm_overlay.py` handles both. Orthoimages use their georeference (GeoTIFF, world file, bbox). Raw nadir frames use
  `--nadir LAT,LON,HEADING` plus GSD or camera parameters, assuming flat ground and an exact nadir view, so
  relief displacement and tilt remain as label offsets. Frames without metadata must first be located by
  [[osm-fingerprint-geolocalization]]; orthorectification (for example OpenDroneMap) is optional.
- With a standard (not true) orthophoto, OSM building footprints and image roofs disagree by the lean.
  Expect systematic label offsets for tall buildings ([[methods-10-25cm]]).
- Example of the lean in a raw nadir photo: with h/H = 10 m / 100 m (a house seen from a drone at 100 m), a
  roof at r = 2000 px from the image centre is displaced about 200 px. For a survey flight at H = 3000 m
  the same house shifts only about 7 px.

## Related
- [[imagery-sources]]
- [[osm-weak-labels]]
- [[object-detection]]
- [[semantic-segmentation]]

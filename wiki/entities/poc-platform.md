---
title: PoC platform
type: entity
tags: [thesis, platform, deployment]
sources: [thesis-goal, dsia-studienordnung-2027]
updated: 2026-10-20
---
The proof-of-concept platform where orthoimagery is uploaded and the thesis model's detections are shown.

- Users upload **nadir images**, with orthoimagery as the ideal case ([[author-decision-nadir-input]]). Drone frames carry GPS, heading and height in EXIF/XMP, which gives a rough georeference. Users upload [[orthoimagery]] to the platform, which runs the recognition/classification model on it ([[thesis-goal]]).
- **Unknown:** whether this is an existing platform (from the university or an employer) or something the thesis must build. That decides deployment constraints such as GPU availability, upload size, and supported formats like GeoTIFF/COG.

## Programme hooks
- Elective WPF.1 covers analytics and cloud platforms (KNIME, RapidMiner, Grafana; Google Cloud, AWS, Azure), with SageMaker/Rekognition on the reading list. WPF.8 covers UX for AI, XAI and human-in-the-loop; both are relevant if the platform is built in the thesis ([[dsia-studienordnung-2027]]).
- DPR.1 mentions centrally provided "Data Labs"; possible compute for training ([[dsia-studienordnung-2027]]).

## Likely requirements (unsourced)
- Accept georeferenced rasters (GeoTIFF), so predictions can be returned as georeferenced vectors (GeoJSON).
- Tile large uploads, run inference per tile, and merge the results.
- Optional: compare predictions with live OSM data for the same extent via [[overpass-api]], to flag objects that are missing from OSM or no longer exist.

## Related
- [[thesis-poc-pipeline]]
- [[orthoimagery]]

---
title: GNSS-denied visual localisation — use cases & framing
type: analysis
tags: [use-cases, gnss-denied, drones, ethics, research-question]
sources: [author-note-use-cases-gnss-denied, costea-2016-aerial-geolocalization, rural-geolocalization-search, dsia-studienordnung-2027, author-decision-no-metadata, bayern-dop-regions-search]
updated: 2026-10-21
---
Application framing of the thesis: locating a drone or aerial photo without GPS/GNSS by matching detected OSM objects to the map. It lists the use cases, which of them the prototype already supports, the evidence behind each, and the dual-use implications.

## Framing
"Drone localisation without satellite navigation" is called **GNSS-denied visual localisation**: position from
the camera image plus map data alone ([[author-note-use-cases-gnss-denied]]). The thesis's specific angle is that
the map is **OSM via Overpass**, and the image features are **detected OSM-class objects** (not pixels), matched by
[[ransac]]-style similarity fitting ([[geo-match-prototype]]).

## Use cases

| # | Use case | Fit with the prototype | Evidence |
|---|---|---|---|
| 1 | GPS outage, jamming, spoofing: backup position and spoofing check | ●●● (core) | Motivation of [[costea-2016-aerial-geolocalization]]; jamming and spoofing details unsourced |
| 2 | Shading and multipath in Alpine valleys | ●●● fits [[oberbayern-sued]]; add DEM terrain ([[copernicus-browser]]) | Author framing; DEM-based UAV localisation: about 26–31 m after 2 km ([[rural-geolocalization-search]]) |
| 3 | Search & rescue (Bergwacht, civil protection) | ●● needs robustness to snow and storm imagery | Author framing (unsourced) |
| 4 | Locating imagery after the fact (stripped metadata, scanned historic photos, screenshots) | ●●● exactly the metadata-free input ([[author-decision-no-metadata]]) | Historic photos break the OSM-currency assumption (unsourced) |
| 5 | Checking and refining GPS to sub-metre | ●●● confident matches: 0.2–0.4 m in simulation | [[geo-match-prototype]] (synthetic) |
| 6 | Infrastructure inspection (lines, pylons, cable cars, bridges, tanks) | ●●● those objects are also anchors | Author framing; anchor classes in [[osm-object-catalog]] |
| 7 | Map maintenance: find objects missing from or outdated in OSM | ●●● closes the loop to [[thesis-goal]] | Planned in [[thesis-poc-pipeline]] step 7 |
| 8 | Military and security use | Dual-use, so not a thesis target | Ethics and law section (ETHR: GDPR, AI Act; [[dsia-studienordnung-2027]]) |

## Limits shown so far ([[geo-match-prototype]], synthetic)
- About **8 detected anchors** are needed in about 7,700 km²; 3–4 fail.
- In rural areas point anchors are too sparse. Add building footprints, forest edges, water and terrain ([[author-note-rural-roads]], [[rural-geolocalization-search]]).
- A **search-region prior** is required; smaller regions give more reliable matches.

## Research question (proposed for the exposé)
> Wie zuverlässig lässt sich eine Drohnenaufnahme ohne Metadaten allein anhand erkannter OSM-Objekte lokalisieren,
> skalieren und ausrichten, und wie viele Objekte sind dafür in alpinen und ländlichen Gebieten nötig?

The question is measurable (success rate, position, scale and heading error vs. number and type of anchors, urban
vs. rural vs. Alpine), uses the simulation framework with known ground truth, and leaves room for comparing anchor
types ([[author-note-use-cases-gnss-denied]]).

## Ethics & dual use (to write up)
- Dual-use: GNSS-independent navigation has military relevance. State the civilian scope explicitly. (unsourced)
- Privacy: locating other people's photos can reveal where private persons live. Restrict to aerial nadir imagery of public space and do not publish located private images. (unsourced)
- Data licences: Bavarian DOP20 is CC BY 4.0 with attribution; OSM is ODbL ([[bayern-dop-regions-search]]).

## Literature still needed (unsourced claims to back)
GNSS jamming and spoofing incidents and countermeasures; GNSS multipath in Alpine terrain; consumer-drone GPS accuracy;
recent GNSS-denied UAV visual localisation surveys.

## Related
- [[author-note-use-cases-gnss-denied]]
- [[geo-match-prototype]]
- [[osm-fingerprint-geolocalization]]
- [[thesis-timeline]]

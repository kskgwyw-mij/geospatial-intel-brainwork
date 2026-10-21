---
title: Real OSM data test — Alpine-edge districts (Overpass export)
type: source
tags: [osm, real-data, evaluation, density]
sources: [osm-real-test]
raw: raw/2026-10-21-osm-real-test-notes.md
raw_data: [raw/2026-10-21-osm-anchors-alpine-edge.json]
updated: 2026-10-21
---
First test with real OSM data for the search region: real anchor counts (11,599 objects, about 1.5/km²), building density in Miesbach (about 55/km²), and the matcher's performance on the real object layout. It shows that point anchors alone fail for randomly placed photos.

## Summary
Retrieved from a public Overpass mirror; the export is in `raw/2026-10-21-osm-anchors-alpine-edge.json` (ODbL). Detections
are still **simulated** (85 % recall, 2 false alarms, 1 m OSM noise), but the object layout, counts and clustering are **real**.

## Key claims
- **Anchors in about 7,800 km²:** 11,599 in total (about 1.5/km²). power=tower 3,780; swimming pools **934**; aerialway pylons 856;
  soccer 812; power=generator 789; storage tanks 782; tennis 681; towers 444; equestrian 384; aerialway stations 348; tracks 299; silos 191.
- **Buildings, Landkreis Miesbach:** 47,261 (about 55/km²); 74 % are tagged only `building=yes`.
- **Matcher on the real layout:**
  - Photos near objects: 38 % located; **confident 30/30 correct**; median error 0.74 m; ≥ 8 detections located 26/32.
  - **Photos uniformly in the region: 1 % located;** 89/100 had 0–2 detections.
- **Objects per photo** (600 × 450 m, Miesbach, random):

  | At least | Buildings | Point anchors |
  |---|---|---|
  | 1 | 49 % | 12 % |
  | 4 | 32 % | 2 % |
  | 8 | 23 % | 0.6 % |

## Relevance to this wiki
- **It replaces the hypothetical densities** used in [[feasibility]], [[osm-fingerprint-geolocalization]] and [[geo-match-prototype]].
  For example, pools are 934, not the assumed 4,250. Point anchors are about 4× sparser than assumed.
- **Confirms the reliability of "confident"** on real geometry (30/30), but shows that **coverage is the real problem**: point anchors work only where photos happen to contain clusters of them.
- Buildings are about 35× denser than all point anchors and give ≥ 8 objects in about a quarter of random Miesbach photos. **Half of the area has no buildings at all** (forest, Alpine terrain, meadows), so terrain and shape cues are mandatory there ([[coarse-to-fine-localization]], [[author-note-rural-roads]]).
- 74 % `building=yes` means building *class* carries little information. Matching needs per-building descriptors such as size, orientation and LoD2 roof shape ([[bayern-opengeodata]]).

## Pages touched
[[feasibility]], [[geo-match-prototype]], [[osm-fingerprint-geolocalization]], [[oberbayern-sued]], [[overview]]

> [!note] Follow-up
> The real end-to-end run with real imagery and a real detector ([[real-e2e-test]]) found one wrong confident match, so "confident 30/30" holds only for simulated detections.

## Related
- [[real-e2e-test]]
- [[feasibility]]
- [[geo-match-prototype]]
- [[oberbayern-sued]]

---
title: Author note — use cases for GNSS-denied drone localisation
type: source
tags: [use-cases, gnss-denied, drones, research-question]
sources: [author-note-use-cases-gnss-denied]
raw: raw/2026-10-21-author-note-use-cases-gnss-denied.md
updated: 2026-10-21
---
The author's note (in German) framing the thesis as GNSS-denied visual localisation of drones, with eight use cases, the limits shown by the simulation, and a proposed exposé research question.

## Summary
Locating drones without GPS or other GNSS is called **GNSS-denied visual localisation** in the literature. The
drone determines its position from its camera image alone by comparing it with map data, which is what the
`geo_match.py` prototype does ([[geo-match-prototype]]). The note lists eight use cases, restates the simulation
limits, and proposes a research question.

## Key claims
- **Use cases:**
  1. GPS outage, jamming and spoofing: visual position as a backup and as a spoofing check. This was Costea & Leordeanu's motivation.
  2. Signal shading and multipath in Alpine valleys, walls and gorges. Relevant to [[oberbayern-sued]], where terrain from the Copernicus DEM helps.
  3. Search and rescue (Bergwacht, civil protection), when GPS is disturbed in storms or avalanches.
  4. Locating imagery after the fact: stripped metadata, scanned historic air photos, screenshots, third-party images. Uses: documentation, expert reports, insurance, historical comparison.
  5. Checking and refining GPS: cheap drones are often several metres off; map matching can refine to under a metre. Confident simulation matches had about 0.2–0.4 m error. Useful for surveying, inspection and orthophoto production.
  6. Infrastructure inspection (power lines, pylons, cable cars, bridges, tanks). These objects are also good anchors: `power=tower`, `aerialway=*`, `man_made=storage_tank`.
  7. Map maintenance: once located, compare with OSM to find missing or outdated objects. This closes the loop to the original thesis goal ([[thesis-goal]]).
  8. Military and security use: the method is **dual-use**, to be covered in the ethics and law part (module ETHR: GDPR, AI Act), together with privacy when locating other people's images.
- **Limits from the simulation:**
  - About 8 detected objects are needed in about 7,700 km², and 3–4 fail.
  - Point objects are not enough in the countryside; add building footprints, forest edges, water and terrain.
  - A search-region prior is required, and smaller regions are more reliable.
- **Proposed research question:** "Wie zuverlässig lässt sich eine Drohnenaufnahme ohne Metadaten allein anhand
  erkannter OSM-Objekte lokalisieren, skalieren und ausrichten, und wie viele Objekte sind dafür in alpinen und
  ländlichen Gebieten nötig?" In English: *How reliably can a drone image without metadata be located, scaled and
  oriented from detected OSM objects alone, and how many objects are needed in Alpine and rural areas?*

## Relevance to this wiki
- **Reframes the application:** the thesis is now positioned as GNSS-denied visual localisation, with OSM-object detection as the means. Use cases go to [[gnss-denied-use-cases]].
- **Fixes the candidate research question** for the exposé ([[thesis-timeline]]).
- The claims about GPS jamming, spoofing, multipath and cheap-drone accuracy are the author's framing and have no source yet. Back them with literature before the exposé.

## Pages touched
[[gnss-denied-use-cases]], [[thesis-timeline]], [[overview]], [[thesis-goal]]

## Related
- [[gnss-denied-use-cases]]
- [[geo-match-prototype]]

---
title: Author decision — working title of the thesis
type: source
tags: [thesis, decision, expose]
sources: [author-decision-generalisation-axes, author-decision-title]
raw: raw/2026-10-22-author-decision-title-gsd.md
superseded_raw: [raw/2026-10-22-author-decision-title.md]
updated: 2026-10-22
---
The author chose the working title "Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen: Eine Generalisierungsstudie über Regionen" (English: "Calibrated Probabilistic Geolocalization of Nadir Imagery with OpenStreetMap Features: A Cross-Region Generalization Study").

## Summary
The title names the method (calibrated, probabilistic geolocalisation), the input (nadir aerial images), the reference (OSM object features) and the study type (generalisation across regions and **ground sampling distances**). The first version said "Zoomstufen" / "Cross-Zoom"; the author replaced this with Bodenauflösung / Ground Sampling Distance, which is the precise remote-sensing term.

## Key claims
- **Method framing:** "calibrated probabilistic" means a likelihood/heatmap whose confidence is checked against hit rates, as in [[thesis-contribution]] ([[author-decision-title]]).
- **Input:** nadir aerial images, consistent with [[author-decision-nadir-input]] ([[author-decision-title]]).
- **Reference:** OSM *object features*, i.e. the object/POI route, not image-to-image matching ([[author-decision-title]]).
- **Generalisation axes: regions and ground sampling distances (GSD, Bodenauflösung).** GSD is a new explicit axis: the method must work at ground resolutions other than those it was tuned on. It replaces or adds to "cross-provider" from [[author-note-novelty]] ([[author-decision-title]]).

> [!note] Amended
> The GSD axis was dropped later, so the subtitle is now „Eine Generalisierungsstudie über Regionen“ / "A Cross-Region Generalization Study" ([[author-decision-generalisation-axes]]).

## Relevance to this wiki
It fixes the scope of the evaluation design ([[thesis-contribution]], [[thesis-timeline]]) and the exposé title ([[expose-material]]). It also turns scale robustness, already a matcher parameter (GSD range) and studied in the literature (Castleberry & Martin 2021, VTRN at diverse altitudes; [[author-literature-list]]), into a stated research axis.

## Pages touched
[[thesis-timeline]], [[thesis-contribution]], [[expose-material]], [[overview]]

## Related
- [[author-decision-generalisation-axes]]
- [[thesis-contribution]]
- [[author-note-novelty]]
- [[expose-guide]]

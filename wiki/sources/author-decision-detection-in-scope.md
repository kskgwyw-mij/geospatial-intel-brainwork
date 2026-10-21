---
title: Author decision — detection is part of the thesis
type: source
tags: [scope, decision, detection]
sources: [author-decision-detection-in-scope]
raw: raw/2026-10-21-author-decision-detection-in-scope.md
updated: 2026-10-21
---
Scope decision by the author: object recognition and classification (building and evaluating the detectors) is part of the thesis, alongside geolocation.

## Summary
"Die Erkennung ist Teil der Arbeit." The thesis therefore has two connected parts: (1) detecting and classifying
OSM-class objects in nadir photos, and (2) using those detections to locate the photo without metadata.

## Key claims
- Detection is in scope; it is not an assumed input.

## Relevance to this wiki
- It keeps the original goal ([[thesis-goal]]: recognition and classification) and adds the GNSS-denied localisation framing ([[gnss-denied-use-cases]]); it does not replace it.
- The geolocation results so far assume simulated detections ([[geo-match-prototype]]). Real detector errors (recall, false alarms, class confusion) must be measured and fed into the matcher, so the evaluation becomes **end-to-end**.
- The research question needs a detection sub-question ([[thesis-timeline]]).

## Pages touched
[[thesis-goal]], [[thesis-timeline]], [[thesis-poc-pipeline]], [[geo-match-prototype]], [[overview]]

## Related
- [[thesis-goal]]
- [[gnss-denied-use-cases]]

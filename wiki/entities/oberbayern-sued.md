---
title: Oberbayern Süd (search region)
type: entity
tags: [region, study-area, bavaria]
sources: [author-decision-search-region, bayern-dop-regions-search, author-note-rural-roads]
updated: 2026-10-21
---
The thesis search region and study area: southern Upper Bavaria, operationalised as planning regions 17 Oberland + 18 Südostoberbayern (about 9,180 km²).

## Definition
- Chosen by the author as the search region ([[author-decision-search-region]]).
- No official unit called "Oberbayern Süd" exists. Working definition: **Region 17 Oberland** (3,956 km²: Bad Tölz-Wolfratshausen, Garmisch-Partenkirchen, Miesbach, Weilheim-Schongau) plus **Region 18 Südostoberbayern** (5,225 km²) ([[bayern-dop-regions-search]]). Total about **9,181 km²**, roughly half of Oberbayern (about 17,529 km²).
- Region 18's districts are Rosenheim (district and city), Traunstein, Berchtesgadener Land, Altötting and Mühldorf a. Inn. (unsourced)
- **Status: provisional.** The author keeps this working definition (both planning regions, including Altötting and Mühldorf) for now and may change the area later ([[author-decision-search-region]]). Keep the region a parameter (a district list or polygon) in queries and tools, never hard-coded.
- **Alternative narrower definition:** only the Alpine-edge districts GAP, TÖL, MB, WM, RO, TS and BGL, which drops the lowland districts Altötting and Mühldorf. The author should confirm. (unsourced)

## Character (unsourced)
- A mix of Alpine valleys and mountains (Zugspitze, Karwendel, Chiemgau Alps), pre-Alpine lakes (Chiemsee, Tegernsee, Starnberger See edge, Kochelsee), farmland and many dispersed farms. Towns: Rosenheim, Traunstein, Garmisch-Partenkirchen, Bad Tölz.
- This means many **rural, road-sparse tiles**, so shape anchors and terrain matter ([[author-note-rural-roads]], [[osm-fingerprint-geolocalization]]). Distinctive rare anchors: cable cars and lifts, ski pistes, lake shorelines, onion-dome churches, hay barns.
- Borders Tyrol, including Kufstein and the HOK campus ([[hok-dsia-master]]).

## Data
- **Imagery:** Bavarian DOP20 (20 cm RGB + CIR, CC BY 4.0) ([[bayern-dop-regions-search]], [[imagery-sources]]).
- **OSM:** Overpass area query by district, for example:

  ```
  [out:json][timeout:600];
  area["boundary"="administrative"]["admin_level"="6"]
      ["name"~"^(Landkreis )?(Garmisch-Partenkirchen|Bad Tölz-Wolfratshausen|Miesbach|Weilheim-Schongau|Rosenheim|Traunstein|Berchtesgadener Land|Altötting|Mühldorf a\\. ?Inn)$"]->.r;
  ( nwr["leisure"~"swimming_pool|pitch|track"](area.r);
    nwr["man_made"~"storage_tank|silo|water_tower|tower"](area.r);
    nwr["power"~"tower|generator"](area.r);
    nwr["aerialway"](area.r); );
  out center tags;
  ```
  Check the district names against OSM (`name` vs. `name:de`) before relying on the regex. (unsourced)

## Related
- [[author-decision-search-region]]
- [[osm-fingerprint-geolocalization]]
- [[imagery-sources]]
- [[bayern-dop-regions-search]]

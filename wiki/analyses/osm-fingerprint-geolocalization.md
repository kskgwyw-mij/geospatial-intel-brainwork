---
title: Two-factor OSM fingerprint for locating an image
type: analysis
tags: [geolocalization, fingerprint, overpass, decision]
sources: [author-decision-search-region, bayern-dop-regions-search, author-decision-no-metadata, costea-2016-aerial-geolocalization, methods-10-25cm-search, aerial-cv-benchmarks, author-note-rural-roads, rural-geolocalization-search]
updated: 2026-10-21
---
How to turn detected objects in an orthoimage into a two-factor "fingerprint" (what + where-relative-to-what) that can be searched in OSM via Overpass to find where the image was taken, and how to estimate whether a fingerprint is unique.

## When this is needed
With nadir images as the thesis input ([[author-decision-nadir-input]]), this matters more: frames without GPS/heading metadata can only be placed by fingerprinting, and frames with metadata still need fine alignment.

State orthophotos are already georeferenced. Fingerprinting matters for images **without**
coordinates: drone frames with stripped metadata, screenshots, scanned historic air photos,
or tiles whose georeference must be verified. Published precedent: detect road intersections,
match each intersection's neighbourhood to OSM, then align the road networks geometrically. About 90 %
of intersections were located within 2.5 m at 1 m/px, even when trained on one city and tested on another
([[costea-2016-aerial-geolocalization]]).

> [!note] What the paper changes in this design
> 1. A **single object or pair is a weak key**. The paper's fingerprint is the *neighbourhood*: all anchors
>    within a radius w. Identification accuracy grows with w ([[costea-2016-aerial-geolocalization]]).
> 2. Use **retrieve then verify**: a cheap descriptor kNN gives k candidates, and geometric alignment
>    (Shape Context + RANSAC affine + Chamfer distance) picks the winner. Alignment pushed identification to about 90 % (same source).
> 3. **Known orientation is a legitimate factor**: the paper assumes a compass heading and tolerates σ = 5° noise (same source).
>    North-up orthophotos give it for free.

## The two factors

**Factor 1 — semantic key (what):** a *pair of object classes*, A and B, chosen so that
- both are **reliably detectable** at 10–25 cm, with few false positives ([[methods-10-25cm]]);
- both are **rare** in the search region (low density, so few chance matches);
- both are **well mapped** in OSM (missing OSM objects create false negatives);
- both are **stable over time**: tanks and pitches, not cars or construction sites. (unsourced)

**Factor 2 — geometric key (where, relative to each other):** the vector from A to B. Orthophotos are
north-up with a known pixel size, so the image gives
- the **distance d in metres** (pixels × GSD),
- the **bearing θ** from A to B (north-up, so it can be used directly),
- optionally the **sizes or orientations** of A and B (pitch long-axis angle, pool area).

Fingerprint = `(class_A, class_B, d ± δd, θ ± δθ)`. This is the minimal, interpretable version.

**Recommended upgrade, following the paper:** Factor 1 = the anchor class (the rarest detected object). Factor 2 =
its **neighbourhood constellation**: classes, distances and bearings of all detected objects (and road
intersections) within radius w. A pair is just the w-neighbourhood with one neighbour, so the uniqueness
maths below still applies; each extra neighbour multiplies down the chance of a false match. (unsourced)

## How unique is a fingerprint? Back-of-envelope
Expected number of chance matches in a region (assuming independent random placement): (unsourced)

- distance only: `N ≈ n_A · ρ_B · 2π·d·2δd`
- distance + bearing: `N ≈ n_A · ρ_B · (d·2δθ) · 2δd`, roughly `n_A · ρ_B · π·r²` for a positional tolerance r

where `n_A` = count of class A and `ρ_B` = density of class B (per m²). The fingerprint is
**unique when N ≪ 1**.

*Illustrative example for the search region [[oberbayern-sued]] (about 9,181 km², [[bayern-dop-regions-search]]; hypothetical counts, not measured):*
Suppose 5,000 pools and 1,000 tennis courts, so ρ_B ≈ 1.09·10⁻⁷ /m². For d = 100 m:
- distance only, ±5 m → N ≈ 5000 · 1.09e-7 · 6283 m² ≈ **3.4 matches**, not unique;
- distance + bearing, ±5 m positional tolerance → N ≈ 5000 · 1.09e-7 · 79 m² ≈ **0.04**, which is unique.

Metadata-free photos have no bearing ([[author-decision-no-metadata]]), so a pair is **not** unique in this region.
Add a third anchor: a triangle gives an extra distance and angle, which multiplies N by roughly another factor of
10⁻²–10⁻³ for rare classes, giving about 0.003–0.03. (unsourced)
(An earlier version of this example used Tyrol at about 12,600 km²; the region was changed by [[author-decision-search-region]].)

Lessons: **use the bearing** (free with north-up orthophotos), keep tolerances tight, and pick
**rare** classes. Real counts should come from an Overpass export of the study area ([[osm-object-catalog]]).

## Good class pairs (ranked; unsourced)
| Pair | Why it works |
|---|---|
| `man_made=storage_tank` + `railway=rail` siding or a second tank | Rare, very stable, high detection precision |
| `leisure=pitch`+`sport=tennis` + `leisure=swimming_pool` | Both DOTA classes ([[aerial-cv-benchmarks]]); a common pairing at hotels, which narrows the pool of candidates |
| `leisure=pitch`+`sport=soccer` + `leisure=track` | Large, stable, distinctive geometry |
| Road intersection (degree + angles) + any rare object | Intersections are dense but carry strong geometry ([[costea-2016-aerial-geolocalization]]) |
| `power=generator` (wind) or `aerialway=pylon` + anything | Very rare; good in Tyrol mountain areas |

Avoid as factors: cars, trees (too dense), solar PV (changes often, incompletely mapped),
and building function (not visible).

## Search procedure
1. **Detect** objects, convert positions to metres in the image frame (north-up).
2. **Choose the most informative pair:** the lowest expected N among detected pairs.
3. **Query OSM.** Use Overpass for a quick test, or download all candidate-class geometries for
   the region once and build a local spatial index for speed. Matching object descriptors
   rather than pixels is far faster: Lin et al. report 648×, as noted on [[costea-2016-aerial-geolocalization]]. In Costea & Leordeanu, matching and alignment ran about 10× faster than detection over 70 km².

   ```
   [out:json][timeout:300];
   area["boundary"="administrative"]["admin_level"="6"]["name"~"Garmisch|Tölz|Miesbach|Weilheim|Rosenheim|Traunstein|Berchtesgaden|Altötting|Mühldorf"]->.a;  // Oberbayern Süd, see [[oberbayern-sued]]
   nwr["leisure"="swimming_pool"](area.a)->.pools;
   nwr["leisure"="pitch"]["sport"="tennis"](around.pools:120)->.courts;
   nwr.pools(around.courts:120)->.pairs;
   (.pairs; .courts;);
   out center;
   ```
   Then filter client-side by the distance band d ± δd and the bearing θ ± δθ.
4. **Verify** each candidate by aligning all detected objects and roads in the neighbourhood: RANSAC affine fit, then Chamfer distance; keep the minimum ([[costea-2016-aerial-geolocalization]]).
5. **Output** location + confidence, using the number of agreeing objects and N.

If scale or rotation is unknown (non-orthophoto input), switch to **three-object
constellations** with scale- and rotation-invariant keys (triangle angles and side ratios),
i.e. geometric hashing. (unsourced)

## Rural areas: when roads are not enough
Roads alone fail in sparse countryside ([[author-note-rural-roads]]). The road-and-intersection method was
tested only in two cities ([[costea-2016-aerial-geolocalization]]). In the country there are few
junctions per tile, and those are generic T- and Y-junctions. Switch from **point anchors** to **shape
anchors**, which the countryside has in abundance:

| Rural anchor | OSM source | Why it is distinctive | Stability |
|---|---|---|---|
| **Forest edges** | `landuse=forest`, `natural=wood` polygons | Long irregular outline, like a coastline | High (years) |
| **Watercourses** | `waterway=stream\|river\|ditch` lines, `natural=water` | Unique meanders; ponds as point anchors | High, but streams are often hidden under trees ([[rural-geolocalization-search]]) |
| **Field mosaic** | `landuse=farmland\|meadow\|orchard` polygons | Parcel shapes and sizes form a near-cadastral pattern | Medium: parcels merge or split; crop colour changes every season |
| **Hedges & tree rows** | `barrier=hedge`, `natural=tree_row` | Linear, irregular, long-lived | High |
| **Isolated farm buildings** | `building=farm_auxiliary\|barn\|house` | Footprint shape and **orientation** of each building | High |
| **Tracks** | `highway=track\|path` | Denser than roads, distinctive curves | Medium (often incompletely mapped) |
| **Power lines & pylons** | `power=line`, `power=tower` | Straight lines with regular pylon spacing; pylons are point anchors | High |
| **Alpine extras (Tyrol)** | `aerialway=*`, `piste:type`, `natural=peak\|cliff\|scree` | Very rare, distinctive | High |
| **Terrain** | Not OSM: a DEM/DSM | Ridge and valley shapes are unique everywhere | Very high |

Evidence and method (sourced unless marked):
- **Boundary-map matching** is the rural counterpart of road matching. Segment land cover, simplify it to boundary maps, and template-match against large maps; this has been done for cadastral geolocation ([[rural-geolocalization-search]]).
  Here, render OSM `landuse`, `natural`, `waterway` and `barrier` geometry into the same boundary map and match detections against it.
- **Expect broken edges:** natural boundaries are irregular, discontinuous and partly hidden by vegetation ([[rural-geolocalization-search]]), so use robust matching such as Chamfer distance or RANSAC rather than exact shapes ([[costea-2016-aerial-geolocalization]]).
- **Terrain** is the strongest fallback in Tyrol. DEM-based orthoprojection gave about 26–31 m mean error after 2 km in a UAV setting ([[rural-geolocalization-search]]). An nDSM also improves detection ([[maggiori-2017-hr-semantic-labeling]]).
- **Adapt the radius:** grow the neighbourhood w until expected chance matches N ≪ 1. Rural tiles need a larger w because anchors are sparser, but each anchor is also rarer. (unsourced)
- **Season:** use shapes, not colours, for fields, because crop colour flips between flights; prefer forest edges, water and buildings as the primary anchors. (unsourced)
- **Evaluation data:** AirZoo-Real has a 190-image rural subset ([[rural-geolocalization-search]]).

Practical split: **urban → roads, intersections and objects; rural → forest edges, water, buildings
and fields as a boundary map, plus terrain.** One retrieve-then-verify pipeline can serve both, by adding
the area-based anchors to the same neighbourhood descriptor. (unsourced)

## Photo only, no metadata: unknown position, scale and rotation
The thesis input is the nadir photo **without metadata** ([[author-decision-no-metadata]]). Compared with an
orthophoto, three things are unknown: **where**, **how big** (GSD, metres per pixel) and **which way is north**.
Bearing and metric distance, the strongest factors above, are therefore not directly available.
(Everything in this section is design reasoning: unsourced unless cited.)

**1. Recover scale from objects with known size ("metric anchors")**
- Standardised objects set the scale: a tennis court (about 23.8 × 11 m doubles), football pitches (within a regulated range), cars (about 4.5 m), road lane width (about 3 m), parking bays (about 2.5 × 5 m).
- One detected tennis court gives the GSD to within a few percent. Several anchors averaged give a robust estimate.
- With the scale known, the distance factor works again.

**2. Make the fingerprint rotation-invariant, or search over rotation**
- Use **distances and angles *between* objects**, for example triangles of three anchors (side lengths, or angles and side ratios if the scale is also unknown). These do not change when the photo is rotated. This is geometric hashing / constellation matching, as in star trackers.
- Alternatively, try candidate rotations, for example every 5°, and keep the best alignment. Costea & Leordeanu's final alignment is affine-invariant, while their retrieval step assumed a known heading ([[costea-2016-aerial-geolocalization]]).
- Weak orientation cues: shadow direction (sun from the south at midday in the northern hemisphere), and the dominant direction of streets or fields.

**3. Fingerprint without metadata = a similarity-invariant constellation**
Factor 1 = the classes of the detected anchors (pool, tennis court, tank, pylon, farm building…).
Factor 2 = their **relative geometry**: pairwise distances in metres (from the recovered scale) and angles between them.
The match fits a 2D **similarity transform** (translation + rotation + scale) between image objects and OSM objects
with RANSAC; the winner has the most consistent matches and the lowest residual.

**4. A search region is still needed**
Without GPS the search area is the prior, for example "Tyrol". The smaller the region, the fewer chance matches
(see the uniqueness formula above). Download the anchor classes for the whole region once from Overpass into
a local index, instead of querying live.

**5. Training vs. inference**
"No metadata" applies to the **uploaded photo** at inference. Training can still use georeferenced orthophotos
with projected OSM labels (`tools/osm_overlay.py`). Augment with rotation, scale and perspective/lean so the
detectors cope with raw nadir frames.

**Resulting pipeline:** detect + classify objects → estimate scale from metric anchors → build an invariant
constellation → RANSAC similarity match against the regional OSM index → location, scale and rotation →
project the full OSM layer onto the photo to label or check every object → output geo-objects.

## Thesis angle
This could be the research question itself: *"How many and which OSM-mapped objects detected in
a 10–25 cm orthophoto are needed to geolocate it uniquely within Oberbayern Süd ([[oberbayern-sued]])?"* It uses the
detectors from [[methods-10-25cm]], the Overpass index, and has a measurable answer: uniqueness
rate against fingerprint size. Ethics: geolocating images can affect privacy, so cover it in the legal section
([[thesis-timeline]]). (unsourced)

## Related
- [[oberbayern-sued]]
- [[author-decision-no-metadata]]
- [[pretrained-models]]
- [[author-note-rural-roads]]
- [[rural-geolocalization-search]]
- [[costea-2016-aerial-geolocalization]]
- [[methods-10-25cm]]
- [[osm-object-catalog]]
- [[overpass-api]]
- [[thesis-timeline]]

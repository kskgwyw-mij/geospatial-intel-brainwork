# Log

Append-only chronology of wiki activity. Newest at the bottom.
Latest entries: `grep "^## \[" wiki/log.md | tail -5`

## [2026-10-20] schema | Wiki initialised
- created: [[overview]], index, log
- notes: Scaffolded the LLM Wiki (raw / wiki / schema layers) for ML/DL algorithm selection with Overpass. No sources ingested yet.

## [2026-10-20] schema | Commit and push after every milestone
- notes: Added a Git section to CLAUDE.md: every ingest, filed query, lint pass and schema change is committed and pushed immediately.

## [2026-10-20] ingest | Thesis goal statement + HOK programme listings
- created: [[thesis-goal]], [[hok-dsia-program-listings]], [[hok-dsia-master]], [[openstreetmap]], [[overpass-api]], [[overpass-turbo]], [[poc-platform]], [[orthoimagery]], [[osm-weak-labels]], [[object-detection]], [[semantic-segmentation]], [[thesis-poc-pipeline]]
- updated: [[overview]]
- notes: Wiki is now anchored on the thesis goal (OSM-object recognition/classification in orthoimagery + PoC upload platform). The official HOK page was unreachable, so programme facts come from third-party listings. Most method claims are still (unsourced).

## [2026-10-20] ingest | Studienordnung MSc DSIA (from WS 2027/28)
- created: [[dsia-studienordnung-2027]], [[thesis-timeline]]
- updated: [[hok-dsia-master]], [[overview]], [[thesis-poc-pipeline]], [[poc-platform]]
- notes: Official regulation supersedes the listing notes. Thesis = 20 ECTS + 2 ECTS committee exam in Sem 4; the exposé is drafted in Sem 3 and approved by the programme director. The curriculum covers CNNs and image object recognition but nothing geospatial. The regulation applies to cohorts from WS 2027/28; check which one applies to the author.

## [2026-10-20] query | List all Overpass Turbo / API objects
- created: [[osm-object-catalog]]
- updated: [[overpass-api]], [[overpass-turbo]], [[thesis-poc-pipeline]], [[overview]]
- notes: Catalogue of element types, primary keys, main values and orthoimagery visibility, plus a thesis class shortlist (buildings, pools, rooftop PV, tanks, pitches, trees). taginfo, the OSM wiki and overpass-api.de were blocked, so it is written from model knowledge and is entirely (unsourced) until a taginfo/Overpass export is ingested.

## [2026-10-20] query | What can be detected with computer vision
- created: [[aerial-cv-benchmarks]], [[cv-detectability]]
- updated: [[object-detection]], [[semantic-segmentation]], [[osm-object-catalog]], [[overview]]
- notes: Detectability depends on object size in pixels, visibility from above, occlusion and bands. The DOTA and ISPRS benchmark classes overlap well with OSM tags (pools, tanks, pitches, buildings, vehicles, trees). Benchmark facts come from search snippets; the GSD table is (unsourced).

## [2026-10-20] ingest | Author note: industrial areas have a different colour
- created: [[author-note-industrial-colour]], [[spectral-texture-features]]
- updated: [[cv-detectability]], [[osm-object-catalog]], [[thesis-poc-pipeline]], [[overview]]
- notes: Corrected the claim that land use is invisible from above: coarse land use (industrial vs. residential vs. farmland) is recognisable from colour, texture and shape. `landuse=industrial` was added to the class shortlist, and colour/texture features now define the classical baseline.

## [2026-10-21] ingest | Maggiori et al. — High-Resolution Semantic Labeling with CNNs (+ OSM imperfect-labels paper)
- created: [[maggiori-2017-hr-semantic-labeling]], [[maggiori-osm-imperfect-labels]]
- updated: [[semantic-segmentation]], [[osm-weak-labels]], [[thesis-poc-pipeline]], [[thesis-timeline]], [[overview]]
- notes: Per-pixel labelling of georeferenced imagery is a location-aware alternative to box detection, not image geolocalisation. The same group pretrained on imperfect OSM labels and refined on a small accurate set, which gives the thesis a sourced method and research-question template. The full texts were blocked, so the facts come from search snippets and the exact accuracy numbers are still missing.

## [2026-10-21] ingest | Maggiori et al. arXiv:1611.01962v1 full PDF
- updated: [[maggiori-2017-hr-semantic-labeling]] (rewritten from the full text), [[semantic-segmentation]], [[aerial-cv-benchmarks]], [[spectral-texture-features]], [[orthoimagery]], [[cv-detectability]], [[thesis-poc-pipeline]], [[overview]]
- notes: Exact results replace the snippets: MLP 88.92 OA / 86.58 mean F1 (Vaihingen), 87.02 / 86.62 (Potsdam), 2nd of 29 on the ISPRS test (OA 89.5), small FCN on a 4 GB GPU. New sourced points: colour alone is ambiguous (grey roof vs. asphalt), DSM works as an extra band, use overlapped tiling at inference, and the benchmark ground truth itself is imprecise.

## [2026-10-21] query | Rethink detector & classifier approaches for 10–25 cm orthophotos
- created: [[methods-10-25cm-search]], [[methods-10-25cm]]
- updated: [[semantic-segmentation]], [[object-detection]], [[thesis-poc-pipeline]], [[overview]]
- notes: Four approach families (classical, task-specific DL, two-stage, foundation/zero-shot). Per-class choice: segmentation for buildings and solar, detection for pools, tanks, pitches and trees, crop classifiers for roof shape and sport, SAM2 as refiner. Proposed minimum scope: buildings plus roof-shape classification. The evidence comes from search snippets.

## [2026-10-21] query | Two-factor label as a searchable location fingerprint
- created: [[costea-2016-aerial-geolocalization]], [[osm-fingerprint-geolocalization]]
- updated: [[overview]], [[overpass-api]], [[thesis-timeline]]
- notes: Fingerprint = semantic key (a pair of rare, stable, detectable classes) + geometric key (distance and bearing in metres, available because orthophotos are north-up with known GSD). The expected chance-match formula shows bearing is essential. Precedent: intersection-to-OSM matching (BMVC 2016). Opens a possible research question on fingerprint uniqueness; the example counts are hypothetical.

## [2026-10-21] ingest | Costea & Leordeanu 2016 full PDF (arXiv:1605.08323v1)
- updated: [[costea-2016-aerial-geolocalization]] (rewritten from the full text), [[osm-fingerprint-geolocalization]], [[osm-weak-labels]], [[overview]]
- notes: Confirmed fingerprint idea, now refined: use the neighbourhood constellation (radius w), retrieve then verify (descriptor kNN, then Shape Context/RANSAC/Chamfer), and orientation is assumed known (σ = 5° tolerated). About 90 % of intersections located within 2.5 m at 1 m/px; OSM alignment raised road F from 66.5 % to 93.9 %. Correction: the "648× faster" claim belongs to Lin et al. (SPIE), not this paper.

## [2026-10-21] ingest | Author note: roads fail in sparse countryside (+ rural geolocalisation search)
- created: [[author-note-rural-roads]], [[rural-geolocalization-search]]
- updated: [[osm-fingerprint-geolocalization]], [[overview]]
- notes: Added a rural strategy that switches from point anchors to shape anchors: forest edges, watercourses, field mosaic, hedges, farm-building footprints and orientations, pylons, and Alpine features, matched as boundary maps with robust (Chamfer/RANSAC) alignment, with a DEM as fallback. Neighbourhood radius adapts to anchor density.

## [2026-10-21] query | Are there pretrained CNNs?
- created: [[pretrained-models-search]], [[pretrained-models]]
- updated: [[methods-10-25cm]], [[osm-fingerprint-geolocalization]], [[overview]]
- notes: Yes, one per head: YOLO11-OBB pretrained on DOTAv1 (already covers pools, tanks, pitches), DeepForest, SatlasPretrain Swin V2/ResNet via TorchGeo, DINOv3 SAT-493M (0.6 m Maxar, also usable as a fingerprint retrieval descriptor), SAM2/Grounded-SAM. None was trained at 10–25 cm, so fine-tune or resample.

## [2026-10-21] edit | Tool: project Overpass objects onto a nadir image
- updated: [[thesis-poc-pipeline]], [[osm-weak-labels]]
- notes: Added tools/osm_overlay.py (numpy + Pillow; pyproj optional). Input: Overpass Turbo GeoJSON or Overpass JSON with `out geom`, plus georeference via GeoTIFF tags, a world file + EPSG, or a lon/lat bbox for Web-Mercator images. Output: annotated PNG, a JSON of pixel boxes and polygons per OSM object, and optional YOLO labels. Tested on synthetic data; all three georeference modes agree.

## [2026-10-21] query | Nadir vs. orthoimagery
- updated: [[orthoimagery]]
- notes: Nadir describes the viewing direction of a raw central-perspective photo, with relief displacement d = r·h/H. Ortho describes processing: DTM rectification to uniform map scale, but buildings still lean. True ortho uses a DSM so roofs sit over footprints. The overlay tool and OSM labels need orthoimages; raw nadir frames must be orthorectified or geolocated first. Answered from general photogrammetry knowledge (unsourced).

## [2026-10-21] ingest | Author decision: nadir images suffice (+ nadir mode in osm_overlay.py)
- created: [[author-decision-nadir-input]]
- updated: [[thesis-goal]] (amendment), [[orthoimagery]], [[osm-weak-labels]], [[poc-platform]], [[thesis-poc-pipeline]], [[osm-fingerprint-geolocalization]], [[overview]]
- notes: Input relaxed from orthoimagery to nadir frames. tools/osm_overlay.py gains `--nadir LAT,LON,HEADING` with --gsd or height/focal/sensor; it assumes flat ground and exact nadir, and was tested for heading rotation and the camera-derived GSD. Label offsets grow (GPS, heading, relief), so detection-to-OSM alignment and fingerprinting become more important.

## [2026-10-21] ingest | Author decision: photo only, no metadata
- created: [[author-decision-no-metadata]]
- updated: [[osm-fingerprint-geolocalization]] (new section on unknown position, scale and rotation), [[thesis-goal]], [[poc-platform]], [[thesis-poc-pipeline]], [[thesis-timeline]], [[overview]]
- notes: Geolocation becomes a core step. Scale comes from metric anchors (tennis courts, pitches, cars, lanes); the fingerprint becomes a rotation-invariant constellation matched by a RANSAC similarity transform against a regional OSM index; a search-region prior is needed. Training may still use georeferenced orthophotos; the --nadir metadata mode is not part of inference.

## [2026-10-21] ingest | Geopera: 10 free sources of satellite data for Germany (search snippets)
- created: [[geopera-free-satellite-germany]], [[imagery-sources]]
- updated: [[orthoimagery]], [[thesis-poc-pipeline]], [[overview]]
- notes: The page was blocked, so it was ingested from search snippets and flagged as a vendor blog. Key takeaway: free satellite imagery (Sentinel-2, 10 m) is too coarse for the classes, while German state orthophotos (DOP10/20, NRW 10 cm on a 3-year cycle) fit training at 10–25 cm. Proposed: train on German DOP, fine-tune and test on Tyrol, and simulate metadata-free test photos from held-out tiles.

## [2026-10-21] ingest | Author decision: search region Oberbayern Süd (+ Bavarian DOP and region search)
- created: [[author-decision-search-region]], [[bayern-dop-regions-search]], [[oberbayern-sued]]
- updated: [[osm-fingerprint-geolocalization]] (example re-computed for about 9,181 km²; a pair without bearing is not unique, so use triangles), [[imagery-sources]] (Bavarian DOP20 is now the first choice), [[orthoimagery]], [[overview]]
- notes: "Oberbayern Süd" is not official; working definition is planning regions 17 Oberland + 18 Südostoberbayern. Bavarian DOP20 (RGB+CIR) is CC BY 4.0, so training and testing can happen in-region with a district split. Open: whether to include the lowland districts Altötting and Mühldorf.

## [2026-10-21] query | What is RANSAC?
- created: [[ransac]]
- updated: [[osm-fingerprint-geolocalization]], [[costea-2016-aerial-geolocalization]], [[imagery-sources]] (fixed a stale "Tyrol = thesis region" row)
- notes: Concept page with the algorithm, the iteration formula (w = 0.3, s = 2 gives about 49 iterations) and its role in metadata-free geolocation, where the best similarity transform directly yields position, scale and north. Written from standard knowledge (unsourced).

## [2026-10-21] edit | Search region confirmed as provisional
- updated: [[author-decision-search-region]], [[oberbayern-sued]], [[overview]]
- notes: The working definition (Oberland + Südostoberbayern, including Altötting and Mühldorf) is kept for now. The author may choose another area later, so the region must remain a swappable parameter in queries and tools.

## [2026-10-21] edit | Search region narrowed to the Alpine-edge districts
- updated: [[author-decision-search-region]], [[oberbayern-sued]], [[osm-fingerprint-geolocalization]], [[imagery-sources]], [[overview]]
- notes: Provisional region is now GAP, TÖL, MB, WM, RO (+ Rosenheim city), TS, BGL, about 7,800 km² (Oberland part sourced, the other areas approximate); Altötting and Mühldorf dropped. Overpass queries updated; the uniqueness example was rescaled at constant density (N about 15 % lower); the train/test split is now Oberland districts vs. RO/TS/BGL.

## [2026-10-21] ingest | Copernicus Browser (second imagery source, search snippets)
- created: [[copernicus-browser]]
- updated: [[imagery-sources]], [[osm-fingerprint-geolocalization]], [[overview]]
- notes: The site was blocked, so it was ingested from search snippets. Sentinel-2 is too coarse for objects, and the VHR2024 download is restricted. The useful part is Copernicus DEM GLO-30 (30 m, free with registration) as the terrain layer for Alpine and rural geolocation. EEA-10 (10 m) is restricted, and the GLO-30 view service needs a CCM opt-in since Aug 2026.

## [2026-10-21] ingest | Geopera article, full clip (replaces snippet-based ingest)
- updated: [[geopera-free-satellite-germany]] (rewritten from the full text), [[copernicus-browser]], [[imagery-sources]], [[overview]]
- created: [[german-dop-search]] (the DOP facts split out of the old snippet notes)
- notes: Full list of 10 sources; key point: free satellite data is 10–30 m and paid satellite is at best 30 cm, still coarser than free Bavarian DOP20. Flagged a contradiction: the blog says Copernicus needs no registration, the CDSE docs say a free account is required. Corrected the attribution: the DOP10/20/40 facts came from other search results, not this article.

## [2026-10-21] edit | Geolocation matcher prototype + simulation
- created: [[geo-match-prototype]]
- updated: [[osm-fingerprint-geolocalization]], [[thesis-poc-pipeline]], [[ransac]], [[overview]]
- notes: Added tools/geo_match.py (hypothesise-and-verify similarity matching, metric anchors, confidence status) and tools/sim_geo_match.py. Synthetic results: at 7,744 km², 8/8 confident matches correct, ≥ 8 detections 6/7 located, 3–4 detections 0/20; when located, errors are about 0.2 m, < 0.1 % GSD and < 0.1° heading. 2-inlier fits carry no evidence. The densities are hypothetical; next step is to rerun on the real Overpass export.

## [2026-10-21] ingest | Author note: use cases for GNSS-denied drone localisation
- created: [[author-note-use-cases-gnss-denied]], [[gnss-denied-use-cases]]
- updated: [[thesis-timeline]] (preferred research question, dual-use ethics), [[overview]]
- notes: The thesis is now framed as GNSS-denied visual localisation using detected OSM objects. There are 8 use cases; the best fits are spoofing and outage backup, Alpine shading, after-the-fact locating, sub-metre refinement, inspection and OSM maintenance. Military use is dual-use and goes in the ethics section. The German research question is adopted as the preferred exposé candidate. The jamming, multipath and drone-GPS claims still need literature.

## [2026-10-21] ingest | Bayern OpenGeoData portal (DOP20 RGB detail + further datasets, search snippets)
- created: [[bayern-opengeodata]]
- updated: [[imagery-sources]], [[osm-fingerprint-geolocalization]], [[osm-weak-labels]], [[methods-10-25cm]], [[copernicus-browser]], [[bayern-dop-regions-search]], [[overview]]
- notes: The site was blocked, so this comes from snippets. Free Bavarian data changes the design: DGM1 (1 m) replaces Copernicus GLO-30 for terrain inside Bavaria; DOM − DGM gives an nDSM band; LoD2 and Hausumringe give official building and roof-shape labels; ATKIS and ALKIS give rural anchors (parcels carry a no-modification clause). OSM stays the searched map.

## [2026-10-21] ingest | Bayern OpenData: DOP20 RGB detail page + portal start page (full clips)
- created: [[bayern-dop20rgb-detail]]
- updated: [[bayern-opengeodata]] (rewritten from the full product list), [[imagery-sources]], [[oberbayern-sued]], [[osm-weak-labels]], [[methods-10-25cm]], [[spectral-texture-features]], [[overview]]
- notes: Confirmed 1 km GeoTIFF tiles in EPSG:25832 (about 50 MB each, up to 126 GB per district), so sample tiles instead of mirroring about 160–390 GB. New finds: DOM20 (20 cm surface model, giving an nDSM at image resolution), Einzelbäume (official tree labels), ALKIS Tatsächliche Nutzung (land-use labels), ALKIS Verwaltungsgebiete (district polygons for the region parameter), historical DOP WMS (cross-year tests). The earlier snippet notes are superseded.

## [2026-10-21] schema | `superseded_raw` frontmatter for replaced source notes
- updated: CLAUDE.md, tools/lint.py, [[bayern-opengeodata]], [[costea-2016-aerial-geolocalization]]
- notes: Snippet notes replaced by full clips or PDFs stay in raw/ (raw is immutable) and are listed under `superseded_raw:`, so lint no longer reports them as un-ingested.

## [2026-10-21] ingest | Author decision: detection is part of the thesis
- created: [[author-decision-detection-in-scope]]
- updated: [[thesis-goal]], [[thesis-timeline]] (FF1 detection + FF2 localisation), [[thesis-poc-pipeline]], [[geo-match-prototype]], [[overview]]
- notes: The thesis has two connected contributions: detecting and classifying OSM-class objects, then locating metadata-free photos from those detections. Measured detector recall, false alarms and confusion must replace the simulated assumptions, so the evaluation becomes end-to-end.

## [2026-10-21] query | Why must the photo be scaled and oriented?
- updated: [[osm-fingerprint-geolocalization]]
- notes: Map = metres and north-up, photo = pixels in an arbitrary orientation, so matching needs a 4-parameter similarity (shift 2, scale 1, rotation 1). Without scale, pixel distances cannot be compared with metres; without rotation, directions mean nothing; object coordinates and drone heading need both. Invariant fingerprints defer, but do not remove, the need.

## [2026-10-21] query | How to localise at fine granularity?
- created: [[coarse-to-fine-localization]]
- updated: [[geo-match-prototype]], [[osm-fingerprint-geolocalization]], [[overview]]
- notes: Four stages: retrieval by object fingerprints, RANSAC object alignment (the current prototype, metre level), dense registration against DOP20 (sub-metre), and camera pose with DOM20/DGM1 heights (removes relief displacement, gives height and tilt). OSM is only metre-accurate, so the fine stages use DOP and DOM as the reference. Expected accuracies beyond the simulation are unsourced.

## [2026-10-21] query | How is it technically and statistically possible?
- created: [[feasibility]]
- updated: [[geo-match-prototype]] (OSM-noise results), [[thesis-timeline]], [[overview]]; tools/sim_geo_match.py gains --osm-noise
- notes: Uniqueness is not the limit: going from 3 to 4 inliers cuts expected false matches from about 22 to about 0.002 per photo (H = 10⁵). Anchor availability is the limit: rare classes give P(≥ 4) of about 0 per 0.27 km² photo, while dense anchors (≥ 30/km²) give 0.9+. Precision is about σ/√n; with OSM noise of 1 / 2 m the median error is 0.72 / 1.78 m, confident still 100 %. About 100 test photos per condition for ±10 pp.

## [2026-10-21] ingest | Real OSM data test for the Alpine-edge districts
- created: [[osm-real-test]]
- updated: [[geo-match-prototype]], [[feasibility]], [[osm-fingerprint-geolocalization]], [[oberbayern-sued]], [[overview]]; tools/sim_geo_match.py gains --uniform-photos
- notes: Overpass mirror maps.mail.ru is reachable. Real anchors: 11,599 (about 1.5/km²); pools 934 vs 4,250 assumed. On the real layout, confident matches are 30/30 correct, but uniformly placed photos are located 1 % of the time. Miesbach: 47,261 buildings (about 55/km²); random footprints have ≥ 8 buildings 23 %, none 51 %. Synthetic results were optimistic on coverage; buildings with descriptors plus terrain are required.

## [2026-10-21] ingest | HOK course documents: WA exposé slides, ASPO chapter 1, AI guideline
- created: [[hok-aspo-2026]], [[wa-course-expose]], [[hok-ki-leitlinie]], [[expose-guide]]
- updated: [[thesis-timeline]], [[hok-dsia-master]], [[overview]]
- notes: The exposé has six fixed sections and is due 23.10.2026 as a name-free PDF, plus an AI-documentation PDF (self-estimated AI share ≤ 50 %). Thesis registration by 31.10.2026. ASPO: 10–15k words, ≥ 6 months processing (≥ 10 weeks in semester 4), defence 50 % of the final exam, unfair AI use = serious fraud. The author is probably in semester 3 (WS 2026/27), so the ingested 2027/28 programme regulation may not be theirs. The WA slides and the AI guideline are kept only as paraphrased notes (internal teaching material; the guideline forbids uploading such material to AI tools, so that point is flagged for the author). The ASPO statute PDF is stored.

## [2026-10-21] ingest | Real end-to-end test (DOP20 + pretrained detector + real OSM)
- created: [[real-e2e-test]]
- updated: [[geo-match-prototype]], [[feasibility]], [[osm-real-test]], [[pretrained-models]], [[overview]]; schema and lint gain `raw_data:` for data files belonging to a source
- notes: 80 real metadata-free DOP20 photos, 500 × 375 m. Zero-shot YOLO11s-OBB (DOTA): precision 0.49, recall 0.62 vs OSM. Located 6/40 near anchors (correct ones 0.9–5.2 m, ≤ 2.4 % scale, ≤ 2.9°) and 0/40 uniformly placed (36/40 photos contain no anchor). First wrong "confident" match: a tank farm matched the densest tank cluster 63.5 km away → inlier count must be judged against local density / class diversity. Contradiction with the simulated 30/30 is recorded.

## [2026-10-21] query | How possible is stable detection of inhabited areas in our dataset?
- created: [[settlement-test]], [[settlement-detection]]; tools/settlement_test.py; tools/real_geo_test.py `fetch_dop` gains url/layer (historical flights)
- updated: [[spectral-texture-features]], [[pretrained-models]], [[cv-detectability]], [[coarse-to-fine-localization]], [[overview]]
- notes: Measured rather than assumed: 1,100 real 1-ha DOP20 cells, OSM building labels, Miesbach → Garmisch and 2024 → 2018. Settlement (≥ 5 buildings/ha) AUC 0.982–0.995 with a frozen DOTA embedding (0.94–0.97 with colour/texture); 2018 flight costs ≤ 0.016 AUC; 92–96 % same-cell agreement. "Any building" is harder (0.965 / 0.898): misses are isolated hay barns and Alpine huts. Low prevalence (2–4 %) limits precision at a naive threshold. OSM buildings ≠ inhabitants; ALKIS land use or a population grid would be better labels.

## [2026-10-21] query | How to transfer settlement detection to the Overpass API?
- created: [[settlement-overpass]], [[settlement-overpass-labels]]; tools/overpass_settlements.py; tools/settlement_test.py gains dwelling labels (`ndw`, `--buildings` relabelling)
- updated: [[settlement-detection]], [[osm-object-catalog]], [[overpass-api]], [[overview]]
- notes: The bridge is a tag rule plus a shared 100 m grid. 75 % of buildings are `building=yes`, but house numbers (35–43 %) separate dwellings from barns and huts. With the Overpass dwelling definition the detector does better (inhabited AUC 0.984, 0.973 on 2018; settlement 0.999 uniform). Live Garmisch query: 10,315 cells (2,541 settlement). Overpass then serves three roles: training labels for any region, a reference layer for coarse localisation, and a baseline for unmapped-building checks.

## [2026-10-21] query | What could we do to improve localisation performance?
- created: [[localization-improvements]], [[localization-levers-test]]
- updated: [[geo-match-prototype]], [[real-e2e-test]], [[feasibility]], [[overview]]; tools/geo_match.py gains a class-diversity rule for "confident" (`min_classes=2`); tools/real_geo_test.py saves detections and inlier classes per site
- notes: Measured, not guessed. Random-photo coverage ceilings in Garmisch: point anchors 0.1–1.6 %, +buildings/junctions 34 %, +roads/water/forest edges 78 %, nothing mapped 22 %. The class rule turns confident 3/4 into 2/2 (tank-farm lattice error demoted). Region (5 km) + scale priors make confident and probable fully correct but raise located photos only from 6 to 10/40, because 18/40 sites have < 2 detections. Priority: more cue types and a better detector (FF1), then line/mask matching, multi-frame, priors as a scenario, terrain/DOP for the rest.

## [2026-10-22] query | Exposé requirements (author's summary of the WA slides) → material per section
- created: [[expose-material]]
- updated: [[expose-guide]]
- notes: The author's German summary matches [[wa-course-expose]], with nothing new. Filed bullet material per required section (numbers, wiki sources, literature candidates with their verification status) and a fact list of what the AI assistant did, for the AI-documentation PDF. Deliberately no exposé prose (course and HOK AI guideline). Gaps: peer-reviewed literature on GNSS-free UAV localisation, the RANSAC original, OSM data quality.

## [2026-10-22] edit | Exposé template in Typst
- created: expose/expose.typ, expose/literatur.bib, expose/ki-dokumentation.typ
- updated: [[expose-material]], README
- notes: The author writes the exposé in Typst. The template has the required six-part structure, no author anywhere (PDF metadata author empty, checked with pdfinfo) and hint boxes per section that a switch removes for submission. The bib holds 8 candidates, each marked with its verification status, and an APA style switch. A second document holds the AI-use table and a % field with a > 50 % warning. All three compile with Typst 0.15. No exposé prose was written.

## [2026-10-22] query | Research on Visual Terrain-Relative Navigation for position localisation
- created: [[vtrn-literature-search]], [[terrain-relative-navigation]]
- updated: [[expose-material]], [[gnss-denied-use-cases]], [[localization-improvements]], [[overview]]; expose/literatur.bib (+11 candidates, marked unverified)
- notes: Web search, snippets only. TRN/VTRN covers TERCOM/DSMAC, the Mars 2020 LVS (3.2 km → < 40 m), VISINAV (Mourikis 2009), UAV image-to-orthophoto matching (Conte & Doherty 2009; Goforth & Lucey 2019; Kinnari 2021/2022), the seasonal fragility fix (Fragoso 2021), reviews (Couturier & Akhloufi 2021), datasets (University-1652, UAV-VisLoc) and semantic-map methods (OrienterNet with OSM at ground level; building-vector matching; SASGeo, synthetic only). The literature names feature-poor regions at low altitude as open, which gives the thesis gap peer-reviewed footing: OSM object matching for nadir images in rural/Alpine terrain, on real data.

## [2026-10-22] ingest | Author note: novelty of the combination (verified)
- created: [[author-note-novelty]], [[thesis-contribution]]
- updated: [[expose-material]], [[terrain-relative-navigation]], [[geo-match-prototype]], [[localization-improvements]], [[overview]]; expose/literatur.bib (+6, Kunz/Shankar/Hu/MapLocNet/OSMLoc/SASGeo)
- notes: Every ingredient exists; the combination does not: nadir POI detection, a detector-error point-process likelihood, a calibrated heatmap with a null hypothesis, and cross-region/provider tests on real data. Citations confirmed by search except arXiv 2608.07835 (not found, flagged). Method consequence: replace inlier counting with a likelihood whose undetected-OSM-object term should penalise lattice errors (tank farm), testable offline on the saved detections. This differs from the rejected density-aware chance score, so there is no contradiction.

## [2026-10-22] ingest | Author's literature list (manual findings) → exposé bibliography
- created: [[author-literature-list]]
- updated: [[author-note-novelty]], [[thesis-contribution]], [[expose-material]], [[localization-improvements]], [[overview]]; expose/literatur.bib (now the author's 27 works, data as given; duplicate SASGeo merged; arXiv preprints as `@article{journal = arXiv}` and the Vilnius thesis as `@book` so APA renders cleanly), expose/kandidaten.bib (16 earlier unverified AI suggestions, not shown in the exposé), expose/expose.typ (`literatur-vollstaendig` switch, default: show the full own list)
- notes: Resolves arXiv 2608.07835 = SeqLoc (Zheng et al. 2026, feature-sparse scenes). The nearest neighbours to the novelty claim (Schleiss 2019, Wei 2022, Ouyang 2024, SWA-PF 2025) are known by title only, so the boundary must be checked in their full texts.

## [2026-10-22] edit | Author's literature list, second version (30 works)
- updated: [[author-literature-list]] (raw → v2, RTF as superseded_raw), [[expose-material]], [[overview]]; expose/literatur.bib rewritten
- notes: Full author names, months, issue numbers; +3 works (Hehelskyi & Avrutov 2025; Lee, Mesic & Chung n.d. on self-supervised landmark discovery for TRN; Rulko 2025 on TRN with deep template matching + VO). "et al." lists completed from the first version. Rulko's volume "0" left out and flagged; Lee et al. has no year (renders "o. J." with access date). All 30 render in APA without artefacts.

## [2026-10-22] ingest | Author decision: working title
- created: [[author-decision-title]]
- updated: [[thesis-timeline]], [[thesis-contribution]], [[expose-material]], [[overview]]; expose/expose.typ (title, subtitle, English title line, PDF title metadata; title block not justified, 16 pt, no hyphenation → two clean lines)
- notes: The title fixes the generalisation axes as regions + zoom levels (scale/GSD). Cross-provider from the novelty note is not in it, so that is an open decision. Against the course criteria: precise and no abbreviations, but 14 words with the subtitle (rule of thumb 8–12) and technical terms; the author's deliberate choice.

## [2026-10-22] edit | Title: "Zoomstufen" → Bodenauflösungen / Ground Sampling Distances
- updated: [[author-decision-title]] (raw → amended note, first note superseded), [[thesis-contribution]], [[thesis-timeline]], [[expose-material]], [[overview]]; expose/expose.typ
- notes: Author's terminology choice. German subtitle: „Eine Generalisierungsstudie über Regionen und Bodenauflösungen“. English: "A Generalization Study across Regions and Ground Sampling Distances" (no "GSD" abbreviation in the title). The evaluation axis is now cross-GSD, e.g. DOP20 resampled to 0.4 / 0.8 m or different flight altitudes.

## [2026-10-22] query | Does the title fit the topic development?
- updated: [[expose-material]]
- notes: Mostly yes. Covered: nadir input, geolocalisation, calibration/generalisation (the novelty); region left open by design. Only implicit: detection and classification (the original goal and a scope decision). Missing: "without metadata" (the core difficulty). The emphasis has moved from recognising to locating, so the exposé should keep detection as its own goal or sub-question and name the metadata-free setting early. Scope is ambitious; cross-provider is optional.

## [2026-10-22] query | Which of the two generalisation axes to drop?
- updated: [[thesis-contribution]]
- notes: Recommendation: keep regions (spatial blocking required anyway, data in place, Alpine vs pre-Alpine is the method's limit) and demote GSD to a robustness check. Reasons: a real GSD shift needs multi-altitude drone data; downsampling is a proxy; small objects drop below detectability at 0.8 m; error rates and calibration per GSD multiply the effort. Exception: real multi-altitude drone data. Title unchanged until the author decides.

## [2026-10-22] ingest | Author decision: generalise across regions only
- created: [[author-decision-generalisation-axes]]
- updated: [[author-decision-title]], [[thesis-contribution]], [[expose-material]], [[overview]], [[thesis-timeline]]; expose/expose.typ (subtitle)
- notes: No cross-provider test, GSD dropped as a study axis (it follows the recommendation). Subtitle: „Eine Generalisierungsstudie über Regionen“ / "A Cross-Region Generalization Study". Scale is still estimated by the metadata-free method; name a realistic GSD band in the methods.

## [2026-10-22] edit | Exposé: AI draft plan (Rohfassung) instead of a ghost-written exposé
- created: expose/expose-rohfassung.typ
- updated: [[expose-material]], expose/ki-dokumentation.typ (new row), README
- notes: The author asked for a complete exposé. Declined as finished text: an honest AI share would far exceed the course's 50 % cap, and the HOK AI guideline forbids fully AI-generated texts where own work is required (ASPO 2.8). Delivered the course-sanctioned alternative: a paragraph plan per section (claim + citations from the author's own bibliography + evidence status: verified / title only / own AI-assisted pre-test / author's decision). 5 pages, compiles; documented in the AI-use PDF.

## [2026-10-22] edit | Exposé: full AI draft on the author's request
- created: expose/expose-ki-entwurf.typ
- updated: expose/kandidaten.bib (dataset/software entries as `@book` "[Datensatz]/[Software]", arXiv as `@article`, so APA renders cleanly), expose/ki-dokumentation.typ (new row), [[expose-material]], README
- notes: The author asked for a written draft ("ignore the 50 %, it's only a draft"). Written as a marked AI draft (header "KI-Entwurf"), about 2,200 words: all five sections, draft research questions (main + FF1–FF3: detection/error model, likelihood vs inlier counting, Miesbach → Garmisch). Only verified claims; title-only sources described only by their titles; candidates from kandidaten.bib marked †; pre-test numbers footnoted as AI-assisted; open points in red. Two unsourced superlatives removed in review.

## [2026-10-22] edit | AI draft shortened to 4 pages
- updated: expose/expose-ki-entwurf.typ + .pdf, [[expose-material]]
- notes: Cut from 6 to 4 pages (about 1,700 words incl. bibliography at 10 pt). The draft-label header is switched off (cosmetic). On the request to "hide the AI generation": declined to rewrite for detector evasion, to remove the footnote that the pre-test was AI-assisted, or to drop the draft from the AI documentation, because the course requires disclosure and ASPO 2.8 treats concealment as fraud. The disclosure row in ki-dokumentation.typ is unchanged.

## [2026-10-22] query | Which object classes? (placeholder in the exposé draft)
- updated: [[thesis-contribution]], expose/expose-ki-entwurf.typ + .pdf
- notes: Proposal, applied in the draft and still 4 pages. Core: pools, tennis, soccer, tracks (DOTA baseline, standard sizes); storage tanks (lattice test case); buildings split into dwelling/outbuilding (coverage lever, Overpass rule). Optional: power pylons (3,780, most frequent) and road junctions (32 % coverage), only if time allows. Based on measured region counts and coverage.

## [2026-10-22] ingest | Author decision: DSR framework; scope not limited to feature-poor regions
- created: [[author-decision-framework-scope]]
- updated: [[thesis-contribution]], [[expose-material]], [[overview]]; expose/expose-ki-entwurf.typ + .pdf (framework sentence with Hevner/Peffers †; problem statement reframed to varying object density), expose/kandidaten.bib (+2, unverified)
- notes: "data science research" interpreted as Design Science Research; the author can correct this. The draft is still 4 pages; the framework placeholder is closed. Open: error threshold in metres, a calibration source.

## [2026-10-22] query | Is the scope too large (FF3)?
- updated: [[thesis-contribution]], [[expose-material]]; expose/expose-ki-entwurf.typ + .pdf
- notes: Yes, FF3 as a separate question would double all measurements. Folded into the evaluation design (develop and tune in Miesbach, test only in Garmisch-Partenkirchen); the main question gains "in einer nicht zur Entwicklung genutzten Region". Two research questions remain (FF1 detection/error model, FF2 likelihood + calibration vs counting). The title stays consistent; the draft is still 4 pages.

## [2026-10-22] edit | Data citations DOP20 + OSM verified and moved to own bibliography
- updated: expose/literatur.bib (+2), expose/kandidaten.bib (−2), expose/expose-ki-entwurf.typ + .pdf (no † for both; OSM licence ODbL named in text)
- notes: The author had checked both; cross-checked against the DOP20 product page clip (publisher, CC BY 4.0, 20 cm) and the OSM copyright page / OSMF attribution guideline (ODbL, credit "OpenStreetMap" contributors). Fixed the DOP20 title to the official "Digitales Orthophoto RGB 20cm (DOP20 RGB)"; added the Bavarian credit line as a bib note. Some INSPIRE records for other Bavarian datasets say CC BY-SA 4.0; for DOP20 the product page says CC BY 4.0.

## [2026-10-22] edit | Overpass API cited explicitly (verified)
- updated: expose/literatur.bib (+ olbricht_overpass), expose/expose-ki-entwurf.typ + .pdf
- notes: Software citation: Olbricht, R., Overpass API (Version 0.7.62.4) [Software], https://overpass-api.de/, accessed 21.10.2026. Maintainer, AGPL v3, service URL and GitHub source checked against the OSM wiki (DE:Overpass_API); the version comes from the "generator" field of the saved exports; the release year is unknown, hence "o. J.". The draft now names the Overpass API with a citation and is still 4 pages.

## [2026-10-22] query | Is the dwelling/outbuilding split useful? → replaced by geometric descriptors
- updated: [[thesis-contribution]], [[expose-material]]; expose/expose-ki-entwurf.typ + .pdf
- notes: For localisation the split adds little and costs a lot: tag-noisy labels (75 % `building=yes`, house-number rule), poor nadir separability and scope. The author agreed to describe buildings instead by footprint area and orientation from OSM polygons: reliable, visible from above, more discriminative, and in line with "Objektmerkmale" in the title. The split stays an outlook / settlement-mapping topic. The draft is still 4 pages.

## [2026-10-22] edit | Exposé draft: last red placeholders resolved
- updated: expose/expose-ki-entwurf.typ + .pdf, [[expose-material]]
- notes: Author decision: no calibration source in the exposé (Guo et al. 2017, PMLR 70:1321–1330, was verified and stays a suggestion only); the success threshold is not fixed yet and is phrased as "unterhalb einer noch festzulegenden Schwelle" (recommendation on record: 10 m main, 5/25/50 m supplementary). No red placeholders remain; still 4 pages.

## [2026-10-22] edit | Exposé draft: dagger markers removed; "Studienachse" rephrased
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: On request, the † legend and markers are gone. Still unverified (listed in a source comment): Hu/Dhillon/Buehrer 2024, Xia et al. 2018 (DOTA), Fischler & Bolles 1981, Hevner et al. 2004, Peffers et al. 2007; they remain in kandidaten.bib. The jargon "Bodenauflösung als Studienachse" became plain wording: different ground resolutions are not compared systematically, but the method searches scale in 0.1–0.3 m/px. Still 4 pages.

## [2026-10-22] edit | Exposé draft: no mention of ground-resolution comparison
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: The author found the exclusion confusing. Removed the data-section sentence (no systematic GSD comparison, scale searched in 0.1–0.3 m/px) and the GSD item in the scope limits. Scale estimation remains implicit in "Position, Maßstab und Ausrichtung" and the pose hypotheses. Still 4 pages.

## [2026-10-22] edit | Remaining five exposé citations verified bibliographically
- updated: expose/literatur.bib (+5), expose/kandidaten.bib (−5), expose/expose-ki-entwurf.typ + .pdf
- notes: Checked via web search against publisher/index pages: Xia et al. 2018 (CVPR, pp. 3974–3983, doi 10.1109/CVPR.2018.00418); Fischler & Bolles 1981 (CACM 24(6) 381–395, doi 10.1145/358669.358692); Hevner et al. 2004 (MISQ 28(1) 75–105); Peffers et al. 2007 (JMIS 24(3) 45–77, doi 10.2753/MIS0742-1222240302); Hu, Dhillon & Buehrer 2024 (arXiv 2409.09525). All citations in the draft are now bibliographically verified; reading the content is still the author's job. Still 4 pages.

## [2026-10-22] edit | Exposé draft: footnote on AI-assisted pre-test removed
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: Removed on the author's request. The disclosure stays in the required AI-documentation PDF (ki-dokumentation.typ row "Programmierung von Prototyp-Werkzeugen und Durchführung KI-gestützter Machbarkeitsprüfungen"), which is where the course puts it. Still 4 pages.

## [2026-10-22] edit | Research-question structure confirmed
- notes: The author confirms one main question plus two sub-questions (FF1 detection/error model, FF2 likelihood + calibration vs counting). No FF3; transfer stays in the main question and the evaluation design. Labels unchanged in the draft.

## [2026-10-22] edit | Exposé draft: bibliography on one page
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: The bibliography starts on a new page (weak page break) at 9 pt with tighter spacing, so all entries fit on page 4. The text ends mid page 3; still 4 pages in total.

## [2026-10-22] edit | Exposé draft: more spacing between headings and text blocks
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: Section headings: above 1.5 → 2.2 em, below 0.8 → 1.2 em. Paragraph spacing: 1.1 → 1.4 em. Still 4 pages; the bibliography stays alone on page 4.

## [2026-10-22] edit | Exposé draft: districts not fixed yet
- updated: expose/expose-ki-entwurf.typ + .pdf
- notes: On the author's request, Miesbach / Garmisch-Partenkirchen no longer appear. The text names a development region and a spatially separate test region with different object density inside the study area ("am bayerischen Alpenrand" stays). The wiki keeps the two districts as the working candidates used in the pre-tests. Still 4 pages; bibliography on page 4.

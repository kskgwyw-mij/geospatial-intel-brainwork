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

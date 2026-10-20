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

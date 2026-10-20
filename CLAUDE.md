# LLM Wiki — Schema

This repository is an **LLM-maintained wiki** following Karpathy's "LLM Wiki" pattern
(https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

**Domain:** geospatial intelligence — choosing ML/DL algorithms for problems built on
OpenStreetMap data pulled through the Overpass API (feature extraction, classification,
change detection, POI and road-network analysis, remote sensing fusion, and so on).

The human curates sources and asks questions. You (the LLM) do all the writing, cross-linking
and bookkeeping. Knowledge is compiled into the wiki **once** and kept current, not
re-derived from raw documents on every question.

## Three layers

| Layer | Path | Who writes it | Rules |
|---|---|---|---|
| Raw sources | `raw/` | Human (or you, only when asked to clip something) | **Immutable.** Never edit or delete. Images go in `raw/assets/`. |
| Wiki | `wiki/` | You | All synthesis lives here. Markdown + `[[wikilinks]]`. |
| Schema | `CLAUDE.md` (this file) | Human and you together | Change it when a convention stops working; log the change. |

## Wiki layout

```
wiki/
  index.md        catalog of every page, grouped by type, one line each — update on every change
  log.md          append-only chronology — never rewrite past entries
  overview.md     the big picture: current state of understanding of the whole domain
  sources/        one page per raw source  (summary, key claims, links out)
  entities/       concrete things: tools, libraries, datasets, APIs, models, orgs, OSM tags
  concepts/       ideas & methods: algorithms, techniques, problem types, evaluation metrics
  analyses/       answers to questions worth keeping, comparisons, decision guides
```

File names: `kebab-case.md`. Link with `[[page-name]]` (no folder, no extension — Obsidian
resolves them). Page names must therefore be unique across the whole wiki.

## Page format

Every page except `index.md` and `log.md` starts with YAML frontmatter:

```yaml
---
title: Graph Neural Networks
type: concept            # source | entity | concept | analysis | overview
tags: [deep-learning, road-network]
sources: [osmnx-paper]   # source page names this page's claims rest on ([] if none yet)
updated: 2026-10-20
---
```

Body conventions:
- First line after frontmatter: a one-sentence summary (this is what goes in `index.md`).
- Cite claims with the source page: `... outperforms baseline by 4% ([[osmnx-paper]]).`
- Claims with no source are allowed but must be marked `(unsourced)` — lint will surface them as gaps.
- Contradictions are never silently resolved. Add a `> [!warning] Contradiction` callout
  naming both sources and what each says, and list it under *Open questions* in `overview.md`.
- End each page with a `## Related` section of `[[wikilinks]]`.

Source pages (`wiki/sources/<name>.md`) also carry `raw: raw/<file>` in frontmatter and
contain: **Summary**, **Key claims** (bulleted, specific, with numbers), **Relevance to this
wiki**, **Pages touched**.

## Operations

### Ingest  (`/ingest <path-or-url>`)
1. Read the raw source fully (if given a URL, save it to `raw/` first as markdown and keep it unchanged).
2. Tell the human the 3–5 key takeaways and ask if anything should be emphasised — skip this if they said "batch".
3. Write `wiki/sources/<name>.md`.
4. For every entity and concept the source touches: update the existing page or create a new one.
   Integrate — don't just append. Revise summaries, add numbers, flag contradictions.
   A single source typically touches 5–15 pages.
5. Update `overview.md` if the big picture moved.
6. Update `index.md` for every new or renamed page.
7. Append to `log.md`.
8. Run `python3 tools/lint.py` and fix anything you broke.

### Query  (`/query <question>`)
1. Read `index.md` first to find candidate pages; use `python3 tools/search.py <terms>` when the index isn't enough.
2. Read those pages (and raw sources only when the wiki is thin or a claim needs checking).
3. Answer with `[[citations]]` to wiki pages. Say plainly where the wiki has no answer.
4. If the answer is reusable (a comparison, decision guide, synthesis), file it as
   `wiki/analyses/<name>.md`, add it to the index, and log it. Ask first if unsure.

### Lint  (`/lint`)
1. Run `python3 tools/lint.py` — mechanical checks (broken links, orphans, index drift, frontmatter).
2. Then do the judgement checks the script can't: contradictions between pages, claims a newer
   source has superseded, concepts mentioned on several pages that lack their own page,
   `(unsourced)` claims, and data gaps worth a web search or a new source.
3. Fix what you can, report the rest, suggest the next 3 sources or questions to pursue. Log it.

## log.md format

Append-only. One heading per event, with a fixed prefix so it greps cleanly:

```
## [2026-10-20] ingest | Title of source
- created: [[a]], [[b]]
- updated: [[c]]
- notes: one line on what changed in understanding
```

Event kinds: `ingest`, `query`, `lint`, `schema`, `edit`.
`grep "^## \[" wiki/log.md | tail -5` shows the latest activity.

## Domain hints

Useful entity/concept seeds as sources arrive: Overpass API, Overpass QL, OSM tags & keys,
OSMnx, osmium, GeoPandas, Shapely, H3/S2 grids, rasterisation vs vector features,
spatial autocorrelation & spatial cross-validation, class imbalance in OSM labels,
label noise / OSM completeness, gradient boosting (XGBoost/LightGBM), random forests,
CNNs / U-Net for segmentation, GNNs for road networks, transformers / foundation models
for geospatial (e.g. Prithvi, SatMAE), embeddings of POIs (e.g. hex2vec, loc2vec).
Treat these as prompts for what to look for, not as facts — nothing above is sourced.

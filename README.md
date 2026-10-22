# geospatial-intel-brainwork

Brainstorming ideas for ML/DL algorithm selection with Overpass (OpenStreetMap) —
kept as an **LLM-maintained wiki**, following Andrej Karpathy's
[LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) pattern.

Instead of re-searching raw documents for every question (RAG), the LLM reads each source
once and compiles it into a persistent, interlinked set of markdown pages that it keeps
up to date. You curate sources and ask questions; the LLM does the summarising,
cross-referencing and bookkeeping.

## Layout

| Path | What | Written by |
|---|---|---|
| `raw/` | Original sources (papers, articles, notes, Overpass query dumps). Immutable. | You |
| `wiki/` | Summaries, entity & concept pages, analyses, `overview.md`, `index.md`, `log.md` | The LLM |
| `CLAUDE.md` | The schema: structure, page format, workflows | You + the LLM |
| `tools/` | `lint.py` (health checks), `search.py` (BM25 search), `osm_overlay.py` (project Overpass objects onto a nadir image → annotated PNG + pixel labels / YOLO), `geo_match.py` (locate a metadata-free photo from detected objects + OSM), `sim_geo_match.py` (simulated evaluation), `real_geo_test.py` (end-to-end test on real DOP20 imagery + pretrained YOLO11-OBB + real OSM), `settlement_test.py` (settlement detection stability), `overpass_settlements.py` (Overpass → 100 m settlement grid) | — |
| `expose/` | Exposé in Typst: `expose.typ` (anonymous, required structure, hint boxes), `literatur.bib` (own verified list), `kandidaten.bib` (unverified AI suggestions), `ki-dokumentation.typ` (AI-use documentation). Build: `typst compile expose/expose.typ` | Author writes the text |
| `.claude/commands/` | `/ingest`, `/query`, `/lint` slash commands for Claude Code | — |

## Workflow

1. **Add a source** — drop a file in `raw/` (Obsidian Web Clipper works well), then in Claude Code:
   `/ingest raw/some-paper.md` — or pass a URL.
2. **Ask** — `/query which models handle road-network graphs from Overpass?`
   Good answers get filed into `wiki/analyses/`, so explorations compound.
3. **Maintain** — `/lint` now and then: broken links, orphans, contradictions, stale claims, gaps.

Run the checks by hand any time:

```sh
python3 tools/lint.py
python3 tools/search.py spatial cross validation
grep "^## \[" wiki/log.md | tail -5     # recent activity
```

## Browsing

Open the repo folder as an [Obsidian](https://obsidian.md) vault: pages use `[[wikilinks]]`
and YAML frontmatter, so the graph view and Dataview queries work out of the box.
Git gives you the full version history of every page.

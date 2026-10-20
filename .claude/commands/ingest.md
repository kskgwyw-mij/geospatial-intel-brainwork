---
description: Ingest a raw source into the wiki
argument-hint: <path in raw/ or URL> [batch]
---
Ingest this source into the LLM wiki: $ARGUMENTS

Follow the **Ingest** operation in CLAUDE.md exactly. If it's a URL, save it to `raw/` as
markdown first and never modify it afterwards. Integrate into existing entity/concept pages
rather than appending, flag contradictions, update `overview.md`, `index.md` and `log.md`,
then run `python3 tools/lint.py` and fix any errors you introduced. If "batch" is in the
arguments, skip the discussion step.

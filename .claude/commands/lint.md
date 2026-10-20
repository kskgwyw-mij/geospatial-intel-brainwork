---
description: Health-check the wiki and fix what can be fixed
---
Lint the LLM wiki. Follow the **Lint** operation in CLAUDE.md: run
`python3 tools/lint.py`, fix the mechanical errors, then do the judgement checks
(contradictions, superseded claims, missing concept pages, unsourced claims, data gaps).
Report what's left, suggest the next 3 sources or questions to pursue, and append a
`lint` entry to `wiki/log.md`.

---
description: Answer a question from the wiki, optionally filing the answer back
argument-hint: <question>
---
Answer this question from the LLM wiki: $ARGUMENTS

Follow the **Query** operation in CLAUDE.md: start from `wiki/index.md`, use
`python3 tools/search.py` if needed, cite wiki pages with `[[links]]`, and say clearly
where the wiki has no answer. If the answer is a reusable synthesis, file it under
`wiki/analyses/`, update the index, and append a `query` entry to `wiki/log.md`.

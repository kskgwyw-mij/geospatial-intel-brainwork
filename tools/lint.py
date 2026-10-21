#!/usr/bin/env python3
"""Mechanical health checks for the LLM wiki (stdlib only).

Checks: broken [[wikilinks]], duplicate page names, orphan pages, index drift,
missing/invalid frontmatter, unknown `sources:` entries, source pages whose raw
file is missing, raw files never ingested, and `(unsourced)` claims.

Exit code 1 if any errors (warnings alone exit 0).
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WIKI = ROOT / "wiki"
RAW = ROOT / "raw"
SPECIAL = {"index", "log"}
TYPES = {"source", "entity", "concept", "analysis", "overview"}
LINK_RE = re.compile(r"\[\[([^\]|#]+)(?:#[^\]|]*)?(?:\|[^\]]*)?\]\]")
FM_RE = re.compile(r"\A---\n(.*?)\n---\n", re.S)
CODE_RE = re.compile(r"```.*?```|`[^`\n]*`", re.S)


def parse_frontmatter(text):
    m = FM_RE.match(text)
    if not m:
        return None
    fm = {}
    for line in m.group(1).splitlines():
        if ":" not in line:
            continue
        key, val = line.split(":", 1)
        val = val.split(" #")[0].strip()
        if val.startswith("[") and val.endswith("]"):
            val = [v.strip() for v in val[1:-1].split(",") if v.strip()]
        fm[key.strip()] = val
    return fm


def main():
    errors, warnings = [], []
    pages = {}
    for path in sorted(WIKI.rglob("*.md")):
        name = path.stem
        if name in pages:
            errors.append(f"duplicate page name '{name}': {pages[name].relative_to(ROOT)} and {path.relative_to(ROOT)}")
        pages[name] = path

    texts = {n: p.read_text(encoding="utf-8") for n, p in pages.items()}
    inbound = {n: set() for n in pages}

    for name, text in texts.items():
        rel = pages[name].relative_to(ROOT)
        for target in LINK_RE.findall(CODE_RE.sub("", text)):
            target = target.strip()
            if target not in pages:
                errors.append(f"{rel}: broken link [[{target}]]")
            elif target != name:
                inbound[target].add(name)

        if name in SPECIAL:
            continue
        fm = parse_frontmatter(text)
        if fm is None:
            errors.append(f"{rel}: missing frontmatter")
            continue
        for key in ("title", "type", "sources", "updated"):
            if key not in fm:
                errors.append(f"{rel}: frontmatter missing '{key}'")
        if fm.get("type") and fm["type"] not in TYPES:
            errors.append(f"{rel}: unknown type '{fm['type']}'")
        for src in fm.get("sources") or []:
            if src not in pages or pages[src].parent.name != "sources":
                errors.append(f"{rel}: sources: '{src}' is not a page in wiki/sources/")
        if fm.get("type") == "source":
            raw = fm.get("raw")
            if not raw:
                errors.append(f"{rel}: source page missing 'raw:' path")
            elif not raw.startswith("http") and not (ROOT / raw).exists():
                errors.append(f"{rel}: raw file '{raw}' does not exist")
        n_unsourced = text.count("(unsourced)")
        if n_unsourced:
            warnings.append(f"{rel}: {n_unsourced} unsourced claim(s)")
        if "## Related" not in text:
            warnings.append(f"{rel}: no '## Related' section")

    index_links = set(LINK_RE.findall(CODE_RE.sub("", texts.get("index", ""))))
    for name in pages:
        if name in SPECIAL:
            continue
        if name not in index_links:
            errors.append(f"{pages[name].relative_to(ROOT)}: not listed in index.md")
        if not (inbound[name] - SPECIAL) and name != "overview":
            warnings.append(f"{pages[name].relative_to(ROOT)}: orphan (no inbound links from other pages)")

    ingested = set()
    for n, p in pages.items():
        fm = parse_frontmatter(texts[n]) if p.parent.name == "sources" else None
        if fm:
            ingested.add(fm.get("raw"))
            ingested.update(fm.get("superseded_raw") or [])
    for f in sorted(RAW.rglob("*")):
        if f.is_file() and "assets" not in f.parts and not f.name.startswith("."):
            if str(f.relative_to(ROOT)) not in ingested:
                warnings.append(f"{f.relative_to(ROOT)}: raw source not yet ingested")

    for e in errors:
        print(f"ERROR   {e}")
    for w in warnings:
        print(f"WARN    {w}")
    print(f"\n{len(pages)} pages, {len(errors)} errors, {len(warnings)} warnings")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Tiny BM25 search over the wiki (stdlib only) for when index.md isn't enough.

    python3 tools/search.py graph neural network road
    python3 tools/search.py --raw overpass timeout      # also search raw/
    python3 tools/search.py -n 5 spatial cross validation
"""
import argparse
import math
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOKEN_RE = re.compile(r"[a-z0-9]+")


def tokenize(text):
    return TOKEN_RE.findall(text.lower())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("terms", nargs="+")
    ap.add_argument("-n", type=int, default=10, help="max results")
    ap.add_argument("--raw", action="store_true", help="include raw/ sources")
    args = ap.parse_args()

    dirs = [ROOT / "wiki"] + ([ROOT / "raw"] if args.raw else [])
    docs = []
    for d in dirs:
        for p in d.rglob("*"):
            if p.is_file() and p.suffix in {".md", ".txt"}:
                text = p.read_text(encoding="utf-8", errors="ignore")
                docs.append((p, text, Counter(tokenize(text))))
    if not docs:
        return

    query = tokenize(" ".join(args.terms))
    avgdl = sum(sum(c.values()) for _, _, c in docs) / len(docs)
    df = Counter(t for _, _, c in docs for t in set(c))
    k1, b = 1.5, 0.75

    scored = []
    for path, text, counts in docs:
        dl = sum(counts.values())
        score = 0.0
        for t in query:
            if t not in counts:
                continue
            idf = math.log(1 + (len(docs) - df[t] + 0.5) / (df[t] + 0.5))
            tf = counts[t]
            score += idf * tf * (k1 + 1) / (tf + k1 * (1 - b + b * dl / avgdl))
        if score > 0:
            scored.append((score, path, text))

    for score, path, text in sorted(scored, key=lambda x: -x[0])[: args.n]:
        snippet = next((ln.strip() for ln in text.splitlines()
                        if any(t in ln.lower() for t in query) and not ln.startswith("---")), "")
        print(f"{score:6.2f}  {path.relative_to(ROOT)}\n        {snippet[:140]}")


if __name__ == "__main__":
    main()

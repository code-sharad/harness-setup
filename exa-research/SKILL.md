---
name: exa-research
description: |
  Deep web research: search with Exa AI, then extract the full content of the
  top results so an LLM can understand them. Pipeline = Exa search (find the
  right pages) → Firecrawl scrape (clean markdown) → combined LLM-ready doc.

  Use when the user wants to research a topic on the web, find sources, compare
  pages, or needs rich page content from a general query — especially when the
  answer needs more than a snippet. "Search exa then read the pages", "research
  X and summarize the sources", "find the best pages about X and extract their
  content".

  NOT for: single known-URL scraping (use firecrawl-scrape), platform-specific
  searches (use agent-reach), or content-free searches where snippets suffice.
allowed-tools:
  - Bash(mcporter call exa.web_search_exa *)
  - Bash(firecrawl scrape *)
  - Bash(curl https://r.jina.ai/*)
  - Bash(bash .agents/skills/exa-research/scripts/search_extract.sh *)
  - Bash(python3)
---

# Exa Research (Search + Full-Content Extraction)

Find the right pages with **Exa** (best search relevance), then extract their
**full content** with **Firecrawl** (clean LLM-ready markdown) so an LLM can
actually read and understand them. Falls back to **Jina Reader** (no auth) when
Firecrawl is rate-limited or out of credits.

## Why this combo

- **Exa** → semantic search. Returns relevant URLs + snippets, but not full pages.
- **Firecrawl** → turns URLs into clean markdown, handles JS-rendered SPAs.
- **Jina Reader** → free fallback (`https://r.jina.ai/URL`), no API key.

## Quick usage

Run the helper with a query, the number of results, and an optional extractor:

```bash
bash ~/.agents/skills/exa-research/scripts/search_extract.sh "your query" 5
```

- `num_results` — how many results to search and extract (default 5).
- `extractor` — `firecrawl` | `jina` | `auto` (default `auto`).

The script prints a combined markdown document to stdout: each section has the
title, source URL, and full extracted markdown content.

### Examples

```bash
# 5 results, best backend automatically (firecrawl first, jina fallback)
bash ~/.agents/skills/exa-research/scripts/search_extract.sh "react hooks best practices" 5

# 3 results, force Jina (no firecrawl credits)
bash ~/.agents/skills/exa-research/scripts/search_extract.sh "python asyncio" 3 jina

# 8 results, force firecrawl
bash ~/.agents/skills/exa-research/scripts/search_extract.sh "vector databases 2026" 8 firecrawl
```

## Manual workflow (if you prefer to run steps yourself)

1. **Search** with Exa:
   ```bash
   mcporter call exa.web_search_exa query="your query" numResults=5
   ```
2. **Extract** each result URL. Primary → Firecrawl:
   ```bash
   firecrawl scrape "https://example.com" -o .firecrawl/page.md
   ```
   Fallback → Jina (no auth, no credits):
   ```bash
   curl -s "https://r.jina.ai/https://example.com"
   ```
3. **Combine** the extracted pages into one markdown doc for the LLM.

## Output & organization

- Write results to `.firecrawl/` (already gitignored) or `/tmp/` — never dump
  huge raw content into the conversation. Use `grep`/`head` to inspect large files.
- The helper writes nothing persistent (uses a temp dir cleaned up on exit).
- For lightweight questions where snippets are enough, skip extraction and just
  use Exa directly.

## When Firecrawl is down / out of credits

If `firecrawl scrape` fails (rate limit or insufficient credits), use `auto`
mode or force `jina`. Jina Reader needs no API key and generally works well for
static pages:
```bash
curl -s "https://r.jina.ai/https://example.com"
```

## Troubleshooting

- **"Exa search failed"** — check `mcporter` is configured and the Exa MCP server
  is reachable (`agent-reach doctor --json` → `exa_search`).
- **All pages failed to extract** — likely Firecrawl quota exhausted; rerun with
  `jina`, or check `firecrawl --status`.
- **No results** — try a more specific or differently-worded query.
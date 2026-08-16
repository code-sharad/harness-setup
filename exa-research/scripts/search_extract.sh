#!/usr/bin/env bash
#
# exa-research: Search with Exa, then extract full page content so an LLM can
# understand it. Primary extractor is Firecrawl; falls back to Jina Reader
# (no auth) when Firecrawl is rate-limited or out of credits.
#
# Usage:
#   search_extract.sh "query" [num_results] [extractor]
#     num_results  default 5
#     extractor    firecrawl | jina | auto   (default auto)
#
# Output: prints a single combined markdown document to stdout.
#
set -euo pipefail

QUERY="${1:?usage: search_extract.sh \"query\" [num_results] [extractor]}"
NUM="${2:-5}"
EXTRACTOR="${3:-auto}"
WORKDIR="${EXA_RESEARCH_DIR:-$(mktemp -d)}"
trap 'rm -rf "$WORKDIR"' EXIT

echo "> Searching Exa: \"$QUERY\" (top $NUM) ..." >&2

# --- 1. Exa search ---------------------------------------------------------
timeout 90 mcporter call exa.web_search_exa query="$QUERY" numResults="$NUM" --output json \
  > "$WORKDIR/exa.json" 2>"$WORKDIR/exa.err" \
  || { echo "Exa search failed:" >&2; cat "$WORKDIR/exa.err" >&2; exit 1; }

# Extract URLs + titles from Exa's text blocks.
# Format inside text: "Title: X\nURL: https://...\n...\n---\n\nTitle: Y..."
python3 - "$WORKDIR/exa.json" "$WORKDIR/results.tsv" <<'PY'
import json, sys, re
data = json.load(open(sys.argv[1]))
out = open(sys.argv[2], "w")
for block in data.get("content", []):
    text = block.get("text", "")
    # split results on the "---" separator
    for chunk in re.split(r'\n---\n', text):
        title = re.search(r'^Title:\s*(.+)$', chunk, re.M)
        url = re.search(r'^URL:\s*(.+)$', chunk, re.M)
        if url:
            t = title.group(1).strip() if title else "Untitled"
            u = url.group(1).strip()
            out.write(f"{t}\t{u}\n")
out.close()
PY

if [ ! -s "$WORKDIR/results.tsv" ]; then
    echo "No search results returned." >&2
    exit 1
fi

echo "> Found $(wc -l < "$WORKDIR/results.tsv") result(s)." >&2

# --- helper: extract a single URL with the chosen backend ------------------
extract_firecrawl() {
    local url="$1" out="$2"
    timeout 60 firecrawl scrape "$url" -o "$out" 2>>"$WORKDIR/fc.err"
}
extract_jina() {
    local url="$1" out="$2"
    timeout 60 curl -s "https://r.jina.ai/$url" -o "$out"
}

# --- 2. Extract each URL ---------------------------------------------------
: > "$WORKDIR/combined.md"

while IFS=$'\t' read -r title url; do
    [ -z "$url" ] && continue
    slot="$WORKDIR/page.md"
    ok=0
    if [ "$EXTRACTOR" = "firecrawl" ] || [ "$EXTRACTOR" = "auto" ]; then
        if extract_firecrawl "$url" "$slot"; then ok=1; fi
    fi
    if [ "$ok" = "0" ] && { [ "$EXTRACTOR" = "jina" ] || [ "$EXTRACTOR" = "auto" ]; }; then
        echo "  [firecrawl failed -> jina] $url" >&2
        extract_jina "$url" "$slot" && ok=1
    fi
    if [ "$ok" = "1" ]; then
        {
            echo "## $title"
            echo "Source: $url"
            echo ""
            cat "$slot"
            echo ""
            echo "---"
        } >> "$WORKDIR/combined.md"
    else
        echo "  [failed] $url" >&2
    fi
done < "$WORKDIR/results.tsv"

cat "$WORKDIR/combined.md"
echo "" >&2
echo "> Done. $(grep -c '^Source:' "$WORKDIR/combined.md" 2>/dev/null || echo 0) page(s) extracted." >&2
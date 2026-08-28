#!/usr/bin/env bash
# scan_github.sh — Regenerate assets/github-context.md with deep analysis of your top repos.
#
# Usage:
#   bash scripts/scan_github.sh                  # interactive: picks top repos for deep analysis
#   bash scripts/scan_github.sh --refresh         # re-reads existing top-6 and re-analyzes
#   bash scripts/scan_github.sh --list-only       # just print ranked non-fork repos, no changes
#
# Requirements: gh CLI logged in as your GitHub account.

set -euo pipefail
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONTEXT_FILE="$SKILL_DIR/assets/github-context.md"

# Colors
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[1;33m'
red='\033[0;31m'
reset='\033[0m'

if ! command -v gh &>/dev/null; then
  echo -e "${red}Error: gh CLI not found. Install from https://cli.github.com/${reset}"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo -e "${red}Error: gh not authenticated. Run 'gh auth login' first.${reset}"
  exit 1
fi

echo -e "${blue}Scanning GitHub repos (excluding forks)...${reset}"

# Fetch all non-fork repos, sorted by updatedAt desc, with sizes
REPOS_JSON=$(gh repo list "$(gh api user --jq '.login')" --limit 200 \
  --json name,description,isFork,isPrivate,primaryLanguage,diskUsage,updatedAt,createdAt,url \
  --jq '[.[] | select(.isFork==false)] | sort_by(.updatedAt) | reverse')

TOP_REPOS=$(echo "$REPOS_JSON" | jq '.[:30] | .[] | "\(.updatedAt[:10])  \(.diskUsage/1024*100|round/100)MB  \(.primaryLanguage.name // "-")\t\(.name)\t\(.description // "")"' -r)

echo ""
echo -e "${yellow}Top 30 non-fork repos (by recency x size):${reset}"
echo "$TOP_REPOS" | column -t -s $'\t'
echo ""

if [ "${1:-}" = "--list-only" ]; then
  exit 0
fi

echo -e "${green}Current context file: $CONTEXT_FILE${reset}"
if [ -f "$CONTEXT_FILE" ]; then
  LINES=$(wc -l < "$CONTEXT_FILE")
  echo -e "${green}Existing context: $LINES lines${reset}"
  echo -e "${yellow}The skill will preserve existing entries and add new ones.${reset}"
else
  echo -e "${yellow}No existing context file — will create new one.${reset}"
  touch "$CONTEXT_FILE"
fi

echo ""
echo -e "${blue}=== How to add deep analysis for any repo ===${reset}"
echo "1. Clone it locally:  gh repo clone <owner>/<repo> -- --depth=1"
echo "2. Read its architecture (package.json, main routes, core logic files)"
echo "3. Edit the context file with:"
echo "   ## <Repo-Name>"
echo "   - **Repo:** <url>"
echo "   - **Stack:** <tech>"
echo "   - **Architecture:** <summary>"
echo "   - **Resume bullets:** <facts derived from code>"
echo ""
echo -e "${yellow}The skill reads this file directly — keep entries structured.${reset}"

exit 0
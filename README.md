# My Skills

A personal collection of agent skills (Claude Code / pi-Coding-Agent compatible) that I maintain and use.

## Included skills

| Skill | Description |
|-------|-------------|
| `agent-reach` | Research/search across 15+ internet platforms with multi-backend routing |
| `deep-dive` | Turn long-form content into an interactive learning website |
| `exa-research` | Deep web research: Exa search + Firecrawl extraction pipeline |
| `find-skills` | Discover and install agent skills |
| `firecrawl` | Web search / scrape / interact via the Firecrawl CLI |
| `firecrawl-crawl` | Bulk-extract content from a site or docs section |
| `firecrawl-interact` | Control a live browser session on a scraped page |
| `firecrawl-map` | Discover and list all URLs on a website |
| `firecrawl-scrape` | Extract clean markdown from any URL |
| `firecrawl-search` | Web search with full page-content extraction |
| `frontend-design` | Guidance for distinctive, intentional visual design |
| `grill-me` | Interactive interrogation / feedback agent |
| `teach` | Formats and workflow for teaching missions |

## Layout

Each skill lives in its own folder with a `SKILL.md` entry point, plus optional
`references/`, `scripts/`, and `assets/` subfolders.

## Usage

Point your agent framework at this directory so the skills are discoverable,
then reference a skill by name when a task matches its description.

## Note

Some skills (the `firecrawl*` family, `agent-reach`) are installed from
third-party projects and may carry their own licenses or API-key requirements.
This is a personal config repository.

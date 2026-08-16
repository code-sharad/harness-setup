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

## Theme

The `themes/` folder holds my custom pi-coding-agent theme(s), applied via
`settings.json` (`"theme": "rose-pine-moon"`).

- `themes/rose-pine-moon.json` — Rose Pine Moon palette for pi.

## Extensions (install from name)

The pi *extension packages* I have installed are listed in `~/.pi/agent/settings.json`
under `packages`. Install them again with `pi install <package>`:

| Package | Type |
|---------|------|
| `npm:pi-clinepass-provider` | npm |
| `npm:@vigolium/piolium` | npm |
| `npm:pi-subagents` | npm |
| `npm:pi-mcp-adapter` | npm |
| `npm:pi-effort` | npm |
| `npm:@pi-archimedes/todo` | npm |
| `git:github.com/nagisanzenin/engram` | git |

Additional local extension hook files (kept in `~/.pi/agent/extensions/`) are tracked
by name only, not by content:

| Name | What it does |
|------|--------------|
| `herdr-agent-state` | Herdr ↔ pi integration state hooks (`herdr-agent-state.ts`)
| `update` | Adds an in-app `/update` command to update pi and its extensions (`update.ts`) |

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

## One-shot setup prompt

Paste this into any AI harness to set up your environment:

```
Set up pi-coding-agent for me. Clone https://github.com/code-sharad/harness-setup
into ~/.agents/skills. Copy themes/rose-pine-moon.json to ~/.pi/agent/themes/.
Set settings.json theme=rose-pine-moon and packages to: pi-clinepass-provider,
@vigolium/piolium, pi-subagents, pi-mcp-adapter, pi-effort, @pi-archimedes/todo,
engram (git:github.com/nagisanzenin/engram). Run pi install for each. Add a
minimal /update extension (~/.pi/agent/extensions/update.ts). Verify via pi
doctor and confirm the theme and all packages are installed. Only touch these.
```

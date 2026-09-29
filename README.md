# My Skills

A personal collection of **self-authored** agent skills (Claude Code /
pi-Coding-Agent compatible) plus a declarative, LLM-driven setup prompt.

**Third-party skills are intentionally NOT vendored here.** Copies rot — they
are installed fresh from their official sources at setup time by the prompt in
[`prompts/harness-setup.md`](prompts/harness-setup.md).

## Setup

Paste the prompt in [`prompts/harness-setup.md`](prompts/harness-setup.md)
into any capable AI agent on the target machine. It will:

1. Install the **latest** third-party skills from their official repos (below)
2. Copy the self-authored skills from this repo
3. Install the `rose-pine-moon` pi theme
4. Install the pi extension packages and merge `settings.json`
5. Run a verification checklist and report

## Self-authored skills (live in this repo)

| Skill | Description |
|-------|-------------|
| `deep-dive` | Turn long-form content into an interactive learning website |
| `exa-research` | Deep web research: Exa search + Firecrawl extraction pipeline |
| `tailor-resume` | Tailor a LaTeX resume + cover letter to any job description |

## Third-party skills (installed from official sources, not copied here)

| Skill | Official source |
|-------|-----------------|
| `agent-reach` | https://github.com/Panniantong/Agent-Reach |
| `find-skills` | https://github.com/vercel-labs/skills |
| `frontend-design` | https://github.com/anthropics/skills |
| `grill-me` + `grilling` (dependency) | https://github.com/mattpocock/skills |
| `teach` | https://github.com/mattpocock/skills |
| `firecrawl`, `firecrawl-search`, `firecrawl-scrape`, `firecrawl-crawl`, `firecrawl-map`, `firecrawl-interact` | https://github.com/firecrawl/skills |

> ⚠️ Some of these need credentials/tools on the target machine
> (`FIRECRAWL_API_KEY`, the `agent-reach` CLI, Exa access). The setup prompt
> reports these as DEGRADED rather than failing.

## Theme

- `themes/rose-pine-moon.json` — Rose Pine Moon palette
  ([rose-pine.com](https://rose-pine.com)) packaged as a pi theme, applied via
  `settings.json` (`"theme": "rose-pine-moon"`).

## Extensions (installed by the setup prompt, not stored here)

| Package | Type |
|---------|------|
| `npm:pi-clinepass-provider` | npm |
| `npm:@vigolium/piolium` | npm |
| `npm:pi-subagents` | npm |
| `npm:pi-mcp-adapter` | npm |
| `npm:pi-effort` | npm |
| `npm:@pi-archimedes/todo` | npm |
| `git:github.com/nagisanzenin/engram` | git |

Local extension hook files (`~/.pi/agent/extensions/`) are tracked by name
only: `herdr-agent-state` (managed by Herdr) and `update` (in-app `/update`
command).

## Layout

Self-authored skills live in their own folders with a `SKILL.md` entry point,
plus optional `references/`, `scripts/`, and `assets/` subfolders. Setup
instructions live in `prompts/`.

## Maintenance

- Added a self-authored skill → add it here and to section 1B of the setup prompt.
- A third-party skill changed source/homepage → update the table above and
  section 1A of the setup prompt.
- The verification section of the setup prompt is the safety net — keep it strict.

This is a personal config repository.

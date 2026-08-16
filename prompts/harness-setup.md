# pi Coding-Agent — Full Setup Prompt

> Paste everything in the **block below** into any AI harness (Claude Code, pi,
> OpenAI Codex, ChatGPT, Gemini CLI, etc.). The agent will then recreate this
> exact environment: skills, theme, extensions, and pi configuration.

---

```
You are helping me bootstrap a personal ai coding-agent environment ("harness setup")
for pi-coding-agent (https://github.com/earendil-works/pi-coding-agent).

The reference repo is:  https://github.com/code-sharad/harness-setup
(replaces the old my-skills repo). If it is private, I confirm you may use my
already-authenticated GitHub/gh credentials.

## Goal
Recreate the following so I have a working pi environment identical to my
current setup: (1) skills, (2) theme, (3) page extensions.

## 1. Skills
- Clone the repo into my skills folder:
    git clone https://github.com/code-sharad/harness-setup.git ~/.agents/skills
  (If the folder already exists, instead pull the latest and/or merge carefully,
  keeping my local edits.)
- Confirm the 14 skill directories are present and verifiably nothing is broken:
  agent-reach, deep-dive, exa-research, find-skills, firecrawl, firecrawl-crawl,
  firecrawl-interact, firecrawl-map, firecrawl-scrape, firecrawl-search,
  frontend-design, grill-me, teach.
- Each skill is a folder with a SKILL.md entry point (plus optional references/,
  scripts/, assets/). Do not rename or flatten them.

## 2. Theme (rose-pine-moon)
- Copy the theme into pi's theme directory:
    mkdir -p ~/.pi/agent/themes
    cp ~/.agents/skills/themes/rose-pine-moon.json ~/.pi/agent/themes/rose-pine-moon.json

## 3. Extensions (package installs)
Run pi's installer for each package listed in settings.json (the "packages" array).
Equivalent command per package:  pi install <source>
    npm:pi-clinepass-provider
    npm:@vigolium/piolium
    npm:pi-subagents
    npm:pi-mcp-adapter
    npm:pi-effort
    npm:@pi-archimedes/todo
    git:github.com/nagisanzenin/engram
- If any package is already installed, skip it (idempotent) rather than erroring.

## 4. Local extension hook files (tracked by NAME only, not content here)
The following live in ~/.pi/agent/extensions/ and are NOT in the repo by design —
recreate or confirm them:
- herdr-agent-state.ts   -> installed/managed by Herdr; do not hand-edit. Leave it.
- update.ts              -> adds an in-app /update command for pi & extensions.
  If update.ts is missing, write a minimal pi extension that exposes an "/update"
  slash command running `pi update` (targets: all/extensions/self). If unsure of
  the ExtensionAPI shape, consult the installed @earendil-works/pi-coding-agent
  typings instead of guessing.

## 5. pi configuration (settings.json)
Ensure ~/.pi/agent/settings.json references my setup:
- "theme": "rose-pine-moon"
- "packages": the extension list above, in the same form they were installed
- "defaultProvider": "clinepass"
- "defaultModel": "cline-pass/deepseek-v4-flash"
- "defaultThinkingLevel": "high"
Merge these into existing settings; do not delete other keys.

## 6. Global skills reference
Optionally place a global AGENTS.md containing:
  - "Put the ~/.agents/skills folder in your skills search path."
  - "For any web search / platform lookup task, use the agent-reach skill; for
    single-URL scraping use firecrawl-scrape; for deep research use exa-research."

## 7. Verification (must complete before you say "done")
- Run: pi (or relogin) and confirm the theme rose-pine-moon is active.
- Run: pi doctor / pi update --check (or the equivalent) and confirm all 7
  extension packages show as installed.
- Run: pi install --list (or equivalent) and print the result so I can eyeball it.
- Confirm settings.json still loads (no JSON errors).
- Report exactly which steps you changed vs. skipped, and flag anything that
  needed credentials you did not have.

Do not install unrelated tools, modify my other dotfiles, or change provider
credentials. Keep it scoped to the above.
```

---

## Quick reference (the essentials at a glance)

| What | Where it goes |
|------|---------------|
| Skills | `~/.agents/skills` (clone of `harness-setup` repo) |
| Theme | `~/.pi/agent/themes/rose-pine-moon.json` |
| Installed extensions | `settings.json` → `packages` → `pi install <pkg>` |
| Hook files | `~/.pi/agent/extensions/` (`herdr-agent-state.ts`, `update.ts`) |
| Config | `~/.pi/agent/settings.json` |

> If the repo is **private** and the target machine/user can't access it, the
> skills can be re-provided by manually copying the skill folders instead of
> cloning. Everything else follows the same steps.

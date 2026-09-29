# pi Coding-Agent — LLM-Driven Setup Prompt

> There is **no setup script** in this repo, by design. Scripts rot (hardcoded
> commands, package names, and paths go stale). Instead, paste the block below
> into any capable AI agent (pi, Claude Code, Codex, Gemini CLI, …) on the
> target machine. The agent reads the *declared end state*, figures out the
> current correct commands by verifying official documentation, executes,
> verifies, and reports. The reference repo is:
> https://github.com/code-sharad/harness-setup (private — use the machine's
> already-authenticated `gh` / GitHub credentials if asked).

---

```
You are setting up my personal pi coding-agent environment from scratch.
Work from the reference repo: https://github.com/code-sharad/harness-setup
(If it is private, use my already-authenticated `gh` CLI — do not ask me for
credentials.)

This is a DECLARATIVE spec, not a script. For every command you intend to run,
first verify the current official documentation on the internet (CLI flags,
package names, install methods, and paths change over time). Do not rely on
memorized commands. If something you try fails, diagnose and adapt — do not
give up or silently skip. If a step is impossible without something I must
provide (an API key, a login), mark it DEGRADED, finish everything else, and
list it in your final report.

Target: pi-coding-agent (https://github.com/earendil-works/pi-coding-agent),
version currently installed on this machine (verify with `pi --version`).

=====================================================================
1. SKILLS — end state: all skills below are installed and discoverable
=====================================================================

The agent skills directory for pi is `~/.agents/skills` (each skill is a
folder containing SKILL.md). Anything already present there (e.g. OS-provided
skills such as `diagnose-crash`, `omarchy`) MUST be preserved, not deleted.

A) THIRD-PARTY SKILLS — install the LATEST version of each from its
   official source. Do NOT copy them out of the reference repo (those are
   stale snapshots). For each, verify the skill's official source repo on
   the internet, then install the current version — the open agent-skills
   CLI (`npx skills`, registry: skills.sh) is the usual installer; verify
   its current usage before running it.

   | Skill            | Official source                                      |
   |------------------|-------------------------------------------------------|
   | agent-reach      | github.com/Panniantong/Agent-Reach                    |
   | find-skills      | github.com/vercel-labs/skills                          |
   | frontend-design  | github.com/anthropics/skills                          |
   | grill-me         | github.com/mattpocock/skills                           |
   | grilling         | github.com/mattpocock/skills (REQUIRED dependency of  |
   |                  | grill-me — install it too, it is not in my repo)       |
   | teach            | github.com/mattpocock/skills                          |
   | firecrawl        | github.com/firecrawl/skills (install the core skills: |
   |                  | firecrawl, firecrawl-search, firecrawl-scrape,        |
   |                  | firecrawl-crawl, firecrawl-map, firecrawl-interact)   |

B) SELF-AUTHORED SKILLS — these exist ONLY in the reference repo. Obtain
   them from it (clone it to a scratch dir, or fetch via `gh api`) and copy
   the folders into `~/.agents/skills`:
   - deep-dive
   - exa-research
   - tailor-resume

C) Post-conditions: every skill folder above contains a valid SKILL.md with
   frontmatter; report any skill whose CLI prerequisites are missing (e.g.
   `firecrawl --status` unauthenticated, `agent-reach` binary absent) as
   DEGRADED with the exact remediation (which API key / install command).

=====================================================================
2. THEME — end state: rose-pine-moon installed in pi
=====================================================================

- Get `themes/rose-pine-moon.json` from the reference repo and install it
  into pi's themes directory (verify the correct location for this pi
  version — historically `~/.pi/agent/themes/`).

=====================================================================
3. EXTENSIONS — end state: these packages installed via pi
=====================================================================

Install each via pi's package installer (verify current command form —
historically `pi install <pkg>`). Idempotent: skip any already installed.

  - npm:pi-clinepass-provider
  - npm:@vigolium/piolium
  - npm:pi-subagents
  - npm:pi-mcp-adapter
  - npm:pi-effort
  - npm:@pi-archimedes/todo
  - git:github.com/nagisanzenin/engram

=====================================================================
4. CONFIG — end state: ~/.pi/agent/settings.json contains
=====================================================================

Merge (never delete existing keys) into `~/.pi/agent/settings.json`:
  - "theme": "rose-pine-moon"
  - "packages": the extension list above, in the form pi installed them
  - "defaultProvider": "clinepass"
  - "defaultModel": "cline-pass/deepseek-v4-flash"
  - "defaultThinkingLevel": "high"
Validate the JSON parses before and after.

Local extension hook files live in ~/.pi/agent/extensions/ and are tracked
by name only: `herdr-agent-state.ts` (managed by Herdr — leave it alone) and
`update.ts` (adds a `/update` slash command). If `update.ts` is missing,
write a minimal pi extension exposing `/update` that runs `pi update`,
consulting the installed pi typings for the correct ExtensionAPI shape.

=====================================================================
5. VERIFICATION — do all before you say "done"
=====================================================================

- [ ] List `~/.agents/skills`: all 12 third-party skill folders from 1A
      (including the `grilling` dependency) + the 3 self-authored skills
      from 1B are present; pre-existing skills still intact.
- [ ] Each installed skill reports a plausible source/version; third-party
      skills are the latest from their official repos, not repo snapshots.
- [ ] `rose-pine-moon` theme file exists and settings.json references it.
- [ ] All 7 extension packages show as installed (verify via pi's package
      listing; adapt command if `pi install --list` doesn't exist).
- [ ] settings.json parses, and required keys are present.
- [ ] Final report: exactly what you installed / skipped / found already
      present, anything DEGRADED and why, and every command you ran that
      failed before you adapted.

CONSTRAINTS: Do not install unrelated tools, modify unrelated dotfiles, or
touch provider credentials. Stay scoped to this spec. When a choice is
ambiguous, prefer the official docs of the tool in question over my repo's
stale copies.
```

---

## Why a prompt instead of a script

| Script (`setup.sh`) | LLM-driven prompt |
|---------------------|-------------------|
| Stale CLI flags break it silently | Agent verifies current docs before each command |
| Can't recover from unexpected state | Diagnoses, adapts, reports |
| Drifts from this repo's own philosophy (AGENTS.md mandates doc verification) | Enforces exactly that |
| Deterministic — same input, same output | Non-deterministic — mitigated by the declarative spec + hard verification checklist |

## Maintenance notes (for me, not the agent)

- When you add a self-authored skill → add it to section 1B.
- When a skill gains/changes an official source → update section 1A.
- The verification section is the safety net — keep it strict.
- Re-run this whole prompt on a new machine; it is idempotent by design.

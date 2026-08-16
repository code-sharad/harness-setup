---
name: deep-dive
description: >-
  MUST USE when the user wants to deeply understand any text content — blog post, article,
  docs chapter, paper, essay, transcript — by turning it into an interactive learning website.
  Triggers on: "deep-dive this", "turn this blog/article into an interactive site", "make an
  interactive explanation of this", "help me understand this content", "build a learning
  website from this text", or when the user pastes long-form content and asks for a rich
  interactive breakdown. Produces a single self-contained HTML file with simulators,
  playgrounds, drills, and decision tools, fact-checked and enriched via web research,
  verified by a headless-browser test suite. NOT for: summarization without a website,
  general web research with no content artifact, or code refactors.
---

# Deep-Dive Engine

Turn any text into an expert-level interactive learning website. The output is a single
self-contained `.html` file graded on the L0–L5 scale below. **L4 is the minimum acceptable
output. L5 is the default target.**

References (read as needed during the run):
- `references/research-and-factcheck.md` — tool routing + verification policy (Stage 2)
- `references/pedagogy-and-widgets.md` — section skeleton + 14-widget library + selection matrix
- `references/design-and-motion.md` — design tokens, themes, callouts, animation rules
- `references/verification.md` — the L5 headless-browser test harness + assertion patterns
- `assets/template.html` — starter skeleton with tokens, reveal system, progress bar, dot-nav

---

## Stage 0 · Input Contract

| Input | Required | Default |
|---|---|---|
| Content (pasted text / URL / file) | ✅ | — |
| Audience | no | "smart beginner who will work in this space" |
| Depth | no | expert: faithful core + badged extensions |
| Theme | no | warm-paper editorial |
| Widget budget | no | full coverage |

If the user pastes only content, every default applies silently. Do not interrogate.

## Stage 1 · Ingest & Analyze

If the input is a URL, scrape it first (see research reference). Then produce, in your head
or a scratch note, the **content inventory**:

1. **Core thesis** — the one sentence the text exists to prove
2. **Concept map** — every definition/entity and its relationships
3. **Taxonomies** — "N types of X", "3 layers", "5 mistakes" → these become widgets
4. **Processes** — step-by-step flows → pipeline/stepper widget
5. **Code/procedures** — anything do-able → walkthrough or playground
6. **Analogies** — the author's mental models; keep them, visualize them, then correct them
7. **Decisions** — "when to use / when not" → decision tree
8. **Hand-wavy claims** — assertions without evidence → candidates for fact-check + extension
9. **Difficulty curve** — the order a learner actually needs the concepts in

## Stage 2 · Research & Fact-Check (REQUIRED — use the web tools)

Never build on unverified content. Follow `references/research-and-factcheck.md`. In short:

- **Verify**: every quantitative claim, named study, version number, "X is deprecated",
  benchmark, and strong causal claim in the source. Soften or flag what doesn't check out.
- **Enrich**: the "▲ Beyond the text" sections must be built from *researched* expert
  material — failure modes, real numbers, edge cases, security/governance, evaluation
  practice, open problems, and a current landscape map of tools/frameworks.
- **Update-check**: tool names, library versions, and company claims drift. Confirm the
  source isn't describing stale reality.
- **Log sources**: every verified/enriched claim gets a source; the site's footer gets a
  References section linking them.

Tools: `firecrawl-search` / `exa-research` for open-web verification and enrichment,
`firecrawl-scrape` for known URLs, `agent-reach` when the question is "what do practitioners
say" on specific platforms.

## Stage 3 · Pedagogical Skeleton

Assemble sections from the universal arc (details in pedagogy reference). Include a section
only if the content supports it; never pad:

Hook (motivating failure) → Definitions done carefully → Mental models → Taxonomy →
Machinery → Playground → Decision guidance → Failure modes → Frontier → Compression
(takeaways + persisted checklist) → Quick reference (FAQ) → References.

## Stage 4 · Widget Selection

Use the selection matrix in `references/pedagogy-and-widgets.md`. Widget choice is a lookup
from the content inventory, not improvisation. Every widget must teach a specific concept —
if you can't name what it teaches, cut it.

## Stage 5 · Build

Single self-contained HTML file. Vanilla JS only (no frameworks). Google Fonts CDN allowed.
Start from `assets/template.html`. Follow `references/design-and-motion.md` for tokens,
themes, callouts, and motion rules. Rules that are not negotiable:

- Source content = skeleton; all expert additions badged **▲ Beyond the text**
- No invented claims about the source; researched additions cite their origin in footer references
- Responsive, `prefers-reduced-motion` respected, keyboard-clickable widgets
- Checklist state persisted to `localStorage`

## Stage 6 · Verification (the L5 gate)

Follow `references/verification.md`: extract inline JS and `node --check` it, then run the
headless-browser assertion suite — one assertion per widget behavior per content state
(e.g., playground: clean retrieval / leak state / noise state). **Zero JS errors and 100%
assertion pass rate required.** Do not report completion without the pass log.

## Stage 7 · Grade & Report

Score the output on the scale, report the level with evidence (assertion counts, widget
list, sources used). If below L5, state exactly what's missing.

---

## The Scale (L0–L5)

| Level | Meaning |
|---|---|
| **L0** | Reformatted text. Never ship. |
| **L1** | + design system, callouts, typography |
| **L2** | + scroll system: reveals, progress bar, dot-nav |
| **L3** | + 3–4 widgets covering the core taxonomy and one process |
| **L4** | + full widget coverage incl. a working playground/simulator, decision support, failure modes, frontier, checklist |
| **L5** | L4 + fact-checked & researched enrichment with references + automated browser verification (zero JS errors, all assertions pass) |

## Reporting format (final message)

1. File path + how to open
2. Section/widget table (what each widget teaches)
3. Fact-check summary: claims verified, claims softened/flagged, sources used
4. Test results (assertions passed / JS errors)
5. Grade (L-level) + residual risks

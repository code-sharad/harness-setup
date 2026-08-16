# Pedagogy & Widget Library

## The universal section arc

Learning-science order: emotion → precision → model → detail → practice → judgment →
humility → compression. Include a section only when the content supports it.

| # | Section | Job | Typical widget |
|---|---|---|---|
| 1 | **The Hook** | Make the problem visceral — show the failure the content prevents | Simulator, before/after toggle |
| 2 | **Definitions done carefully** | Precise definitions + "the test" for each concept | Flip cards, styled prose |
| 3 | **Mental models** | The author's analogies visualized, then corrected ("the analogy, then the reality") | Animated diagram, callouts |
| 4 | **The taxonomy** | The N types/categories, each with where-it-lives + how-it-breaks | Tabs explorer |
| 5 | **The machinery** | How it actually works under the hood | Pipeline, SVG diagram |
| 6 | **The playground** | Hands-on with a working miniature of the core mechanism | Playground |
| 7 | **Decision guidance** | When to use it — and when NOT to | Decision tree |
| 8 | **Failure modes** | Mistakes → fixes | Flip cards + troubleshooting list |
| 9 | **The frontier** | Open problems, honestly labeled | Card grid with "open:" questions |
| 10 | **Compression** | Takeaways + actionable checklist (persisted) | Checklist |
| 11 | **Quick reference** | FAQ / glossary | Accordion |
| — | **References** | Original + every research source (required, see research protocol) | Footer links |

## Widget selection matrix — lookup, not improvisation

| Content inventory has… | Widget | It teaches… |
|---|---|---|
| A before/after claim ("X fails without Y") | **Simulator** (state machine + toggle) | causality — same inputs, different system, different outcome |
| 2–4 competing approaches/layers | **Explorer** (click-to-open dossiers) | boundaries: what each owns, costs, breaks |
| Easily-confused concepts | **Drill** (instant-feedback quiz + score) | discrimination between lookalikes |
| N types/categories | **Tabs** (color-coded panels) | the taxonomy + per-type failure modes |
| A process / lifecycle | **Pipeline** (clickable stages + auto-play) | stage responsibilities + per-stage failure modes |
| Anything computable | **Playground** (toy live implementation) | the mechanism — real algorithm, toy scale |
| Code | **Annotated walkthrough** (line-highlight stepper) | which lines carry the load and why |
| A "should I?" question | **Decision tree** (branching verdicts + breadcrumbs) | judgment, incl. the "don't build it" verdict |
| Do/don't lists | **Flip cards** | mistake → fix mapping |
| Actionable advice | **Checklist** (localStorage) | transfer to practice |
| Q&A / glossary | **Accordion** | fast lookup |
| Chronology / evolution | **Timeline** | sequence and causality over time |
| Two alternatives head-to-head | **Comparison slider/table** | tradeoffs, not winners |
| Architecture / relationships | **Animated SVG diagram** | structure and data flow |

## Widget implementation notes

**Simulator** — the highest-value widget. Model the scenario as a step array; each step
mutates chat/panes/DOM. A single toggle switches the system between the two worlds the
source contrasts. Always allow replay. Assert both endings in tests.

**Playground** — implement the *real* algorithm at toy scale in vanilla JS (e.g., hash-based
TF-IDF embeddings + cosine similarity for a memory store). Design the demo so the source's
failure modes are **reproducible by the user**: provide preset data chips, a "break it"
mode (noise dump / filter off), visible metrics (scores, ranks), and alerts that name the
failure. Then show the fix (thresholds, filters, delete).

**Pipeline** — stage dots + connector line + detail panel; each stage: key decisions,
failure mode, expert note. Auto-play button steps through with ~2s interval.

**Drill** — 5–8 scenario cards, 3 option chips each; wrong = red shake + explanation,
right = green + reinforcement; live score. Guard against re-counting answered cards.

**Decision tree** — node map {id → question | verdict}, breadcrumb trail of answers,
reset. Always include a "you don't need this" verdict path — it builds trust.

**Annotated walkthrough** — code lines as an array of pre-tokenized HTML strings; steps
declare highlighted line indices; non-highlighted lines dimmed. Side panel: step title,
explanation, "vendor-neutral / beyond" note. Prev/next + dots.

**Checklist** — items with bold action + one-line why; toggle writes to `localStorage`
under a content-namespaced key; progress counter; celebrate completion.

**Tabs / Explorer / Flip cards / Accordion / Timeline** — straightforward; keep per-item
detail structured (where it lives / how it breaks / one-line rule).

## Pedagogical rules

- Every widget must answer: "what exactly does the learner understand after using this?"
- Interactions come *after* the concept in prose; the widget confirms, not replaces.
- Difficulty ramps: read → click → manipulate → break → fix.
- Voice: expert but warm; short sentences; concrete numbers over adjectives.

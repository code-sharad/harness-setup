# Stage 2 — Research & Fact-Check Protocol

The Deep-Dive Engine never teaches unverified content. This stage has three jobs:
**verify** the source, **enrich** it with researched expert material, and **update-check**
anything that drifts (versions, tool names, deprecations).

## Tool routing

| Need | Tool | Command pattern |
|---|---|---|
| Ingest a URL the user gave | firecrawl-scrape | `firecrawl scrape "<url>" --wait-for 3000 -o .firecrawl/<name>.md` (add `--only-main-content`; if it errors, retry without) |
| Verify a claim / find authoritative sources | exa-research (preferred for depth) or firecrawl-search | read the skill at `~/.agents/skills/exa-research/SKILL.md` or `~/.agents/skills/firecrawl-search/SKILL.md` |
| Enrich a topic (failure modes, landscape, open problems) | exa-research | search → scrape top sources → synthesize |
| Practitioner sentiment ("how do people actually do X") | agent-reach | read `~/.agents/skills/agent-reach/SKILL.md`; run `agent-reach doctor --json` first to see live backends |
| Scrape a specific doc page found during research | firecrawl-scrape | as above |

Budget: 2–6 searches for a typical blog. Verify load-bearing claims, not every sentence.

## What MUST be verified

- **Numbers**: benchmarks, prices, limits, dates, dataset sizes, percentages
- **Named things**: papers, studies, frameworks, companies, people — do they exist, is the
  characterization accurate?
- **Currency**: versions, deprecations, "X is the standard" claims, acquisitons/renames
- **Strong causality**: "X causes Y", "X always/never", "studies show"
- **Quotes and attributions**

## Outcomes per claim — pick one and mark it

| Verdict | Action in the site |
|---|---|
| Verified | Keep; add source to References |
| Imprecise | Rewrite with correct numbers/nuance; keep the source's intent |
| Unverifiable | Soften ("the blog claims…", "a common rule of thumb…") — never present as fact |
| Wrong | Do not propagate. Omit, or present as "a common misconception" with the correction |

## Building the "▲ Beyond the text" material

Research, don't invent. The fixed extension menu:
1. **Failure modes** practitioners actually hit (searched, not imagined)
2. **Real numbers** — costs, latencies, scales, error rates
3. **Edge cases** the source ignores
4. **Security / governance / privacy** angle
5. **Evaluation practice** — how professionals measure the thing
6. **Open problems** — what is genuinely unsolved
7. **Landscape map** — neutral comparison of current tools/frameworks (update-check every name)

## Source log & References section

Keep a running list: `[claim] — [verdict] — [source URL]`. The site's footer MUST contain a
References section linking: the original content, every source used for verification or
enrichment. Inline, don't clutter the prose — the badge (▲ Beyond the text) plus footer
references are enough.

## Integrity rules

- Never fabricate a citation. If you can't find a source, don't make the claim.
- Don't let research change the source's *faithful* sections — corrections and additions
  live in badged extension blocks, clearly separated from the author's own content.
- If the source is vendor content, keep the site vendor-neutral: the pattern is the hero,
  the vendor is one worked example (unless the user asks otherwise).

---
name: tailor-resume
description: >
  Tailors your LaTeX resume (cv.tex) and writes a companion cover letter for any job description you paste.
  Maintains a deep context file of your top GitHub repos (assets/github-context.md) so every tailored bullet
  is grounded in real code, not invented claims. Also compiles the final PDF with tectonic.
  Trigger: paste a job description URL or full text, or use /skill:tailor-resume <paste JD>.
---

# Tailor Resume Skill

## Setup (one time)

```bash
# 1. Dependencies
which tectonic || (curl -fsSL https://drop-sh.fullyjustified.net | sh && mv /tmp/tectonic ~/.local/bin/tectonic)

# 2. Verify tectonic compiles your master CV
cd /path/to/your/cv  # set in ~/.pi/settings.json or override via env
tectonic cv.tex

# 3. (Optional) Refresh GitHub context when your repos change
cd ~/.agents/skills/tailor-resume
bash scripts/scan_github.sh
```

## Required Files

- `/path/to/master/cv.tex` — your master LaTeX resume (the one you edit)
- `/path/to/master/find-job/applications/` — output directory (created if absent)
- `~/.agents/skills/tailor-resume/assets/github-context.md` — pre-computed repo analysis
- `~/.agents/skills/tailor-resume/assets/cv.tex` — copy of master CV (auto-copied from path)

## Workflow

When user pastes a job description (or provides a URL to one):

### Phase 1 — Parse the Job Description

1. Extract these from the JD text (the user will paste it directly):
   - **Company** and **Role** name → used for output folder name
   - **Hard requirements**: degree field, grad year range, location, experience level
   - **Tech stack keywords** (languages, frameworks, tools)
   - **Soft skill keywords** (agile, code review, proof-of-concept, data-driven, etc.)
   - **Seniority signal**: fresher/intern/apprentice/graduate vs senior/lead
   - **Exclude-words** to keep out of the tailored CV (senior-level terms not matching this role)
2. **Check eligibility**: compare hard requirements against the user's profile (from `cv.tex` header and education section). If any mismatch, flag it to the user.
3. **Rank the user's repos** by tech-stack overlap with the JD (from `assets/github-context.md`).

### Phase 2 — Select Projects & Tailor

1. Select **3–4 projects** from the ranked repos that best match the JD's tech stack.
2. Copy the master CV (`cv.tex`) to the output folder.
3. Apply these tailoring rules:

   - **Summary section**: Rewrite to (a) name the company and role explicitly, (b) highlight JD-matching tech stack, (c) mention graduation date and full-time availability
   - **Skills section**: Reorder languages to mirror the JD's order; add any JD-missing skill from the user's github-context that is relevant but not currently listed
   - **Work Experience**: Rephrase bullets to use JD keywords (e.g., "worked in agile sprints", "conducted code reviews on API specs", "designed data collection systems"). **Never change the factual claims** — no made-up metrics or technologies.
   - **Projects**: Select the highest-ranked 3–4 from Phase 1. Keep original tech-stack claims. Add project-specific keywords from the JD where they genuinely apply.
   - **Education**: Keep as-is. Ensure grad date aligns with apprenticeship start.
   - **Leadership**: Keep if it signals teamwork/ownership; remove if page is tight.

### Phase 3 — Truthfulness Guard (CRITICAL)

Before writing the final file, check every bullet:

- [ ] Every technical claim (language, framework, tool) is present in the original CV or `github-context.md` for that project
- [ ] Every metric (e.g., "60% reduction", "200+ users") is in the original CV — **never invent numbers**
- [ ] No seniority words from `exclude_terms` leaked in (senior, lead, principal, head)
- [ ] The graduation date and degree field are unchanged
- [ ] The output says "expected June 2026" or whatever the actual date is — not altered for the JD

If any check fails, fix it or ask the user.

### Phase 4 — Compile & Output

1. Copy the master `cv.tex` to `find-job/applications/<Company>-<Role>/cv.tex`
2. Write the tailored LaTeX there.
3. Copy the cover letter template to `find-job/applications/<Company>-<Role>/cover-letter.tex`. Replace all placeholders: `COMPANY_NAME`, `ROLE_TITLE`, `JOB_ID`, `LOCATION` with values from the JD. Fill in the bullet point with a genuine project mention matching the role.
4. Compile both with tectonic:

   ```bash
   cd "find-job/applications/<Company>-<Role>"
   tectonic cv.tex
   tectonic cover-letter.tex
   ```

5. Report to user:
   - **CV tailored** — highlight 2–3 key changes made
   - **Keyword coverage** — which JD keywords were added, which weren't and why
   - **Truthfulness OK** — all claims verified against original
   - **Files created**: link to output folder

## Refresh GitHub Context

When you've built notable new projects, regenerate the context file:

```bash
bash ~/.agents/skills/tailor-resume/scripts/scan_github.sh
```

This scans repos via `gh`, excludes forks, and prompts you to write deep-analysis entries for any new repos. Existing entries are preserved.

## Customization

Set these env vars or adjust in `~/.pi/settings.json`:

| Variable | Default | Description |
|---|---|---|
| `TAILOR_CV_PATH` | `~/jobs/cv.tex` | Path to master CV |
| `TAILOR_OUTPUT_DIR` | `~/jobs/find-job/applications` | Output folder for tailored CVs + cover letters |
| `TAILOR_GITHUB_CONTEXT` | *(skill assets)* | Path to github-context.md |
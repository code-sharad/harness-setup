# Tailoring Rules & ATS Best Practices

## Truthfulness Rules (Hard Constraints)

1. **Every technical claim in the tailored CV must trace back to one of:**
   - The original `cv.tex` (master copy)
   - `assets/github-context.md` (verified code analysis)
   - Explicitly stated by the user during the session
2. **Never invent metrics.** If the original CV says "60% reduction", keep it. If it doesn't, don't add it.
3. **Never change degree name, graduation year, or GPA.** Only rephrase for clarity.
4. **Never claim a technology you don't have code for.** If the JD asks for .NET and you've never written .NET, don't claim it.

## JD-to-CV Keyword Mapping

| JD Keyword | Where to place in CV |
|---|---|
| Java, Python, JavaScript, .NET | Languages list — reorder to mirror JD order |
| Agile, sprints, code reviews | Work Experience bullets (TechlyAssist) |
| API specs, REST APIs | Work Experience + Project sections |
| OAuth, third-party integrations | Work Experience (TechlyAssist) + Projects |
| Customer-facing applications | All projects (they're all web apps) |
| Data collection systems | Form Builder, Invoice System projects |
| Proof of concepts, automation | AI Coding Agent project |
| iOS, Android, web, social | Web projects. If the JD asks for mobile but you have none, omit the mobile claim |
| Production, deployment | Inventory (Docker/GCP), Coding Agent (Vercel deploy) |
| Asynchronous, messaging, BullMQ | TechlyAssist experience |
| LLM, AI, LangChain, vector DB | Form Builder, PDF-QA-RAG, Coding Agent projects |

## Project Selection Rubric

When choosing 3–4 projects for a tailored CV:

1. **Tech stack overlap** (weight: 40%) — which projects use languages/frameworks the JD asks for
2. **Recency** (weight: 20%) — favor recent projects (post-2025)
3. **Substance** (weight: 25%) — measurable outcomes, real deployment, genuine complexity
4. **Differentiation** (weight: 15%) — avoids "another CRUD app" sentiment

If equal, prefer projects with **live demos** (coding-agent, pdf-qa-rag).

## ATS Formatting Rules

- Keep section headers exactly: `Summary`, `Skills`, `Work Experience`, `Projects`, `Education`, `Leadership & Community`
- Skills section: use `\textbf{Languages:}`, `\textbf{Backend \& APIs:}`, etc. — the ATS-friendly format
- Use bullet points only (`\resumeItem`)
- No columns, no tables for body content (tabular is fine)
- Keep dates in consistent format: `MMM YYYY`
- One page for fresher roles; max 2 pages if >2 years experience

## Cover Letter Rules

- Always address by company name (extracted from JD)
- Reference the specific JD title and Job ID (if visible)
- Keep to ~3 paragraphs: Intro (who you are + why this co), Evidence (2 projects matching their stack), Close (availability + enthusiasm)
- Never use "I believe" — use "I have" or "I built"
- One page only
# GitHub Context — Sharad Mohan Bhadait (code-sharad)

This file contains deep code-level analysis of top 6 repos. Generated from actual source code.
Each entry has resume-grade facts (measurable, verifiable, architecture-aware).

---

## 1. AI-Powered Form Generator
- **Repo:** https://github.com/code-sharad/ai-powered-form-generator
- **Live:** N/A (demo video on README)
- **Stack:** Next.js 15 (frontend) + Express/Bun (backend) monorepo, TypeScript, MongoDB (Mongoose), JWT auth, LangChain + Gemini 2.5 Flash, Cloudinary, Zod validation
- **Lines of code:** ~6,900 (excluding node_modules)
- **Last active:** Oct 2025

### Architecture
**Monorepo:** `frontend/` (Next.js 15 app with shadcn/ui, drag-and-drop form builder via dnd-kit) and `backend/` (Express server on Bun, MongoDB via Mongoose, JWT-based auth).

**Key workflow:** User enters a natural-language prompt → POST to `/api/form/generate` → Gemini 2.5 Flash + LangChain StructuredOutputParser extracts Zod schema → creates a form with typed fields (15 types including GRID, RATING, SIGNATURE, FILE_UPLOAD) → drag-and-drop editor to customize → publish to public endpoint → collect submissions with metadata (IP, user-agent).

### Resume-Grade Details
- LangChain `StructuredOutputParser` converts LLM output into a typed Zod schema for forms, not freeform text
- 15 field types (NAME, EMAIL, PHONE, ADDRESS, DROPDOWN, RADIO, CHECKBOX, DATE, SIGNATURE, SINGLE_LINE, MULTI_LINE, MULTIPLE_CHOICE, GRID, FILE_UPLOAD, RATING) — enterprise-grade form coverage
- Server-side Zod validation both for form generation and submission endpoints (Zod-safeParse pattern)
- Submission tracking: metadata capture (IP, user-agent), uploaded images stored on Cloudinary, atomic submission count updates
- Slug-based public form URLs (nanoid-generated, unique)
- JWT auth with bcrypt password hashing, helmet security headers, CORS config, morgan request logging
- Graceful shutdown handlers (SIGTERM/SIGINT)

---

## 2. AI Coding Agent
- **Repo:** https://github.com/code-sharad/coding-agent
- **Live:** https://agent31.vercel.app
- **Stack:** Next.js (App Router), TypeScript, Vercel AI SDK, OpenRouter (multi-model), @vercel/sandbox, Better Auth (GitHub OAuth), PostgreSQL (Neon) + Drizzle ORM, GitHub API
- **Lines of code:** ~2,300
- **Last active:** Aug 2025 – Apr 2026

### Architecture
Single-page Next.js app with two main runtime paths: (1) **Interactive UI** — user picks a repo (fetched live via GitHub API with user's OAuth token), describes a task, runs the agent with live SSE streaming logs; (2) **API** — two endpoints (`/api/jobs` and `/api/jobs/stream`).

**Agent core (`utils/agent.ts`):** Uses `generateText` from Vercel AI SDK with GPT-4.1 (OpenRouter) and 4 tools: `list_files`, `read_file`, `edit_file`, `create_pr`. The agent has a system prompt enforcing complete-task-first behavior, step limit (30), and a sandbox lifecycle.

**Sandbox (`utils/sandbox.ts`):** Wraps `@vercel/sandbox` — creates an ephemeral cloud VM from a git URL (authenticated via user-provided GitHub token), runs commands via `runCommand`, and auto-timeouts after 5 minutes (2 vCPU).

**Auth:** Better Auth with GitHub OAuth — users sign in with GitHub, the app fetches their repos via `getGithubAccessToken()` from the DB, and injects the token into sandbox creation for private repo access.

### Resume-Grade Details
- End-to-end agent loop: clone → explore → edit → PR — all automated in one task
- SSE streaming (Server-Sent Events) for real-time log display (file list, file diff, PR created, error events)
- Conflict-free: sandbox is ephemeral, separate for each run, no local state corruption
- Token scoping: user's GitHub token never leaves the server; sandbox gets authenticated git URL only
- PostgreSQL (Neon/Drizzle) stores user accounts and OAuth access tokens
- Better Auth handles session management, token refresh, and session queries

---

## 3. Appointment Booking System
- **Repo:** https://github.com/code-sharad/appointment-booking-app
- **Live:** Demo video at https://youtu.be/cjrNAxYdAKU
- **Stack:** Next.js 14/15, NextAuth.js (Google OAuth), PostgreSQL + Drizzle ORM, Google Calendar API + googleapis, date-fns-tz, encrypted token storage
- **Lines of code:** ~7,000
- **Last active:** Sep 2025

### Architecture
Full-stack Next.js app with PostgreSQL. **Roles:** `buyer`, `seller`, `both`, `notdefined`. User registers via Google OAuth, selects role, seller creates availability (7-day schedule with time slots), buyer browses → books → Google Calendar event + Meet link auto-generated.

**Schema:** 6 tables — `users`, `sellers`, `seller_availability`, `appointments`, `user_tokens` (encrypted OAuth refresh tokens), plus a review/service framework.

**Critical Implementation Detail — Token Refresh:** The `getValidAccessToken()` function checks token expiry with a 5-minute buffer, auto-refreshes via Google's OAuth endpoint if needed, re-encrypts the new refresh token, and updates DB atomically. Encrypted via `crypto.createCipheriv` in `lib/encryption.ts`.

**Google Calendar:** `GoogleCalendarService` class wraps `googleapis` v3 — creates events with Google Meet conference data, deletes events on cancellation, handles access token refresh transparently.

**Availability Logic:** Server-side timezone-safe slot computation. Date parsed as local to avoid TZ drift, availability fetched per `dayOfWeek`, existing appointments filtered client-side for conflict-free display.

### Resume-Grade Details
- **Real calendar integration** with Google Calendar + Meet — not a mock or stub
- **Encrypted OAuth token storage** with automatic refresh — production-grade credential management
- **Timezone-aware booking** using `date-fns-tz` with `fromZonedTime` for consistent UTC storage
- **Transactional user onboarding** with role-based access control — sequential DB operations with revert on failure
- Cancellation cascades to Google Calendar (both buyer and seller events deleted)

---

## 4. Inventory/Invoice Management System
- **Repo:** https://github.com/code-sharad/inventory-management
- **Live:** N/A
- **Stack:** React + Vite (frontend), Express.js + MongoDB (backend), shadcn/ui, Chart.js, QR codes, Winston logging, rate limiting, helmet security
- **Lines of code:** ~18,400
- **Last active:** Dec 2025

### Architecture
Full-stack inventory + invoice management for small businesses. **Frontend:** React 18 with Vite, shadcn/ui components, React Query (TanStack Query) for server state, Chart.js for analytics dashboard. **Backend:** Express.js with Mongoose ODM, RESTful routes for items, customers, invoices, categories, users.

**Auth:** JWT-based with access + refresh token rotation, HTTP-only cookies, rate limiting (15 requests/15min for auth), email verification flow (Nodemailer), password reset.

**Invoice Flow:** Transactional invoice creation — deducts item quantities atomically using MongoDB sessions, generates QR code linking to public invoice view. Multiple professional PDF template renderers (Modern, Classic, Minimal, Professional).

**Monitoring:** Winston logger with file rotation (error.log, combined.log).

### Resume-Grade Details
- **Inventory sync:** Creating an invoice atomically deducts stock quantities using MongoDB transactions — prevents overselling
- **QR code generation** on every invoice for easy digital access
- **Security:** express-rate-limit, helmet CSP, mongo-sanitize (prevents NoSQL injection), HTTP-only refresh token cookies
- **Email verification flow + password reset** with JWT-based reset tokens
- **Multiple invoice templates** (4 professional layouts) selectable per invoice
- **Full audit trail:** Winston logging with timestamps, levels, colorization

---

## 5. ECESA (College Student Association Website)
- **Repo:** https://github.com/code-sharad/ecesa
- **Live:** Part of https://iamsharad.in (was deployed)
- **Stack:** Next.js (App Router), TypeScript, Prisma (PostgreSQL), Razorpay, Cloudinary, Resend (email), Nodemailer (contact form), TanStack React Query
- **Lines of code:** ~6,500
- **Last active:** Oct 2025

### Architecture
College engineering association (ECESA) website with workshop management, payments, student registrations, and team management.

**Payment:** Razorpay integration — creates order on backend (Razorpay SDK), client-side checkout, server-side HMAC-SHA256 signature verification, Prisma transaction for order+student creation.

**Registration:** Team workshops supported — team lead + team members (stored as JSON array), per-student DB records linked to workshops.

**Email:** Resend API with custom HTML templates for payment success receipts (gradient header, team details, workshop info, personalized).

**Content:** Workshop CRUD with server actions (Cloudinary image upload via base64), Prisma Accelerate caching (ttl=60s, swr=30s).

### Resume-Grade Details
- **Real payment system** — Razorpay order creation with HMAC verification before granting access (200+ students served)
- **Team registration** — full team member management with max_team_size enforcement
- **Automated email receipts** via Resend with branded HTML templates (gradient headers, team details)
- **Prisma Accelerate caching** for optimized PostgreSQL queries (workshop listings, student data)
- **Dual email system:** Resend (transactional receipts) + Gmail/Nodemailer (contact form)

---

## 6. PDF Q&A RAG Application
- **Repo:** https://github.com/code-sharad/pdf-qa-rag
- **Live:** https://pdf-qa-rag.vercel.app (Token: `hello`)
- **Stack:** Next.js 15, TypeScript, LangChain (community, core, text-splitters), OpenAI (embeddings + GPT-4.1-nano), Pinecone vector DB, Vercel Blob storage, Vercel AI SDK
- **Lines of code:** ~860
- **Last active:** Jan 2026

### Architecture
Minimal but complete RAG pipeline. **Upload:** PDF → Vercel Blob (persistent file storage) → LangChain PDFLoader (text extraction) → RecursiveCharacterTextSplitter (chunk 1000, overlap 200) → OpenAI text-embedding-3-small → Pinecone upsert. **Query:** User question → Pinecone asRetriever(k=5) → context injection → OpenAI GPT-4.1-nano → streaming response via Vercel AI SDK.

**Auth:** Token-based API authentication on both upload and query endpoints (Bearer token check).

**UI:** Clean black-and-white theme, file upload button, text input, streaming response rendering with React Markdown (GFM + syntax highlighting via rehype-highlight).

### Resume-Grade Details
- **Full RAG pipeline** — not a wrapper around a single API
- **Streaming responses** with chunked rendering (Vercel AI SDK `streamText`)
- **Multi-vector-store support** — Pinecone is primary but Qdrant dependency also present in package.json
- **Real-time status indicators** during upload → processing → indexing → query flow
- **Token auth** on all API endpoints (pre-production-grade security)
- Live demo: https://pdf-qa-rag.vercel.app (works with Token: `hello`)

---

## Coverage Summary

| Attribute | Coverage |
|---|---|
| **Java** | Not in top-6. For JD that needs Java, add `forage-midas` (JPMC, Java/Spring) |
| **Python** | For AI agent components (LangChain orchestration). Not a primary language in these repos |
| **JavaScript/TypeScript** | Primary across all 6 repos |
| **.NET** | Not present |
| **API specs** | RESTful API design in all repos (Express/Drizzle/Next.js API routes) |
| **Agile/Sprints** | TechlyAssist experience (not captured in repo code) |
| **OAuth** | GitHub OAuth (coding-agent, Better Auth), Google OAuth (booking, NextAuth), custom OAuth integration (TechlyAssist) |
| **Code reviews** | Automated PR creation (coding-agent); TechlyAssist experience |
| **Data collection** | Form builder submissions, invoice data collection, appointment metadata |
| **Customer-facing apps** | All 6 repos are customer-facing web apps |
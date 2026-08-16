# Design & Motion System

## Themes (token swap, same structure)

Default: **warm-paper editorial**. Alternates: `dark-terminal`, `minimal`. Implement as CSS
custom properties on `:root`; dark via `body.theme-dark` override block.

Core tokens (warm-paper values shown):

```css
--paper:#f6f2ea; --paper-2:#fdfbf6; --ink:#211d16; --ink-soft:#4a443a; --muted:#857c6d;
--line:#e3dccc; --line-strong:#cfc5ae;
--brand:#c2410c;                       /* primary accent */
--good:#15803d; --bad:#b91c1b;         /* feedback */
--code-bg:#26221c; --code-ink:#f3ead9;
/* one accent per concept category, assigned during widget build, e.g.: */
--cat-a:#b45309; --cat-b:#6d28d9; --cat-c:#0f766e; --cat-d:#be123c;
```

## Typography

- Display: **Fraunces** (Google Fonts) — section headings, hero; `letter-spacing:-.015em`
- Body: **Inter** — 17px/1.72 prose
- Mono: **JetBrains Mono** — code, labels, eyebrows, badges (10–12px, uppercase, letterspaced)
- Hero: clamp(46px,7.4vw,88px); section H2: clamp(30px,4.6vw,44px)
- Optional drop cap on the lede of section 2; section numbers as mono eyebrows (`01 · name` + rule)

## Layout

- Prose column: `max-width:740px`; widget band: `max-width:1080px`; gutters 24px
- Section padding ~90px top; `hr.soft` separators rarely — whitespace does the work
- Widget shell: `background:--paper-2; border:1px solid --line; border-radius:20px;
  box-shadow:sm;` with `w-head` (mono title + live LED), `w-body`, `w-foot` (italic hint)

## Callouts (typed)

| Class | Use |
|---|---|
| `.co-analogy` | mental models / "the test" boxes |
| `.co-beyond` | **▲ Beyond the text** — ALL researched extensions (gradient top border, dark tag) |
| `.co-warn` | security/governance/privacy |
| `.co-good` | best practices, green-light patterns |

## Motion rules

1. **Functional only** — every animation explains (state transition) or confirms
   (right/wrong). No decoration-only motion.
2. **Scroll system**: `.reveal` + IntersectionObserver (threshold .12, unobserve after);
   stagger via `.d1/.d2/.d3` delays; top reading-progress bar; left dot-nav with active
   tracking (hide < 1240px).
3. **Micro**: hover lift (`translateY(-2..4px)` + shadow), wrong-answer `shake` keyframe,
   message/pane-item `msgin` fly-in, bar `barin` fill, toggle slide.
4. **Performance**: transform/opacity only; no layout-thrash animations; no JS animation
   libraries; single file; total budget < 200KB before fonts.
5. **Accessibility**: `@media (prefers-reduced-motion:reduce)` kills reveals/smooth scroll;
   all widgets keyboard-clickable (use `<button>`); color never the sole signal (pair with
   icons/text); focus-visible states on interactive elements.

## Copy tone

Expert but warm. Short sentences. Concrete numbers over adjectives. Playful micro-copy in
widget footers ("go on, press it") is allowed; snark is not. Never talk down to the learner.

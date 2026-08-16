# Stage 6 — Verification Harness (the L5 gate)

No Deep-Dive ships without: (a) valid JS, (b) balanced HTML, (c) a passing headless-browser
assertion suite, (d) zero console/page errors.

## 1 · Static checks

```bash
# extract inline scripts, syntax-check each
python3 - << 'EOF'
import re
from html.parser import HTMLParser
html = open('index.html').read()
for i, s in enumerate(re.findall(r'<script>(.*?)</script>', html, re.S)):
    open(f'/tmp/dd-check{i}.js','w').write(s)
class P(HTMLParser):
    def __init__(self):
        super().__init__(); self.stack=[]; self.errs=[]
        self.void={'meta','link','br','img','input','hr','source'}
    def handle_starttag(self,t,a):
        if t not in self.void: self.stack.append(t)
    def handle_endtag(self,t):
        if self.stack and self.stack[-1]==t: self.stack.pop()
        else: self.errs.append('mismatch: '+t)
p=P(); p.feed(html); print('stack:', p.stack, 'errors:', p.errs[:10])
EOF
node --check /tmp/dd-check0.js && node --check /tmp/dd-check1.js
```

## 2 · Headless browser suite (Playwright)

Module resolution on this machine (adapt if moved):

```js
// Find the module: ls ~/.npm/_npx/*/node_modules/playwright | head -1
const { chromium } = require('/home/ram/.npm/_npx/705bc6b22212b352/node_modules/playwright');
// Launch needs shared libs on this machine:
// LD_LIBRARY_PATH="/home/ram/.local/share/chrome-libs/usr/lib/x86_64-linux-gnu:/home/ram/.agent-reach/tools/chrome-libs/lib:$LD_LIBRARY_PATH" node suite.js
```

Suite skeleton — one assertion per widget behavior **per state**:

```js
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  const errors = [];
  page.on('pageerror', e => errors.push(e.message));
  page.on('console', m => { if (m.type() === 'error') errors.push(m.text()); });
  await page.goto('file://' + process.argv[2], { waitUntil: 'networkidle' });
  const check = (n, c) => console.log((c ? 'PASS' : 'FAIL') + ' · ' + n);
  // ... widget interactions + assertions ...
  console.log(errors.length ? 'JS ERRORS:\n' + errors.join('\n') : 'NO JS ERRORS');
  await browser.close();
})();
```

## 3 · Required assertion coverage

- **Simulator**: both toggle states produce their distinct endings; state counts correct
- **Playground**: seed → search ranks the right item #1; break-mode produces the failure
  state (leak/noise alert visible); fix restores; delete works
- **Pipeline/walkthrough/tree**: every stage/step reachable; final verdict/detail correct;
  reset works
- **Drill**: wrong then right both register; score updates once per card
- **Checklist**: toggle updates progress (and persists across reload — spot-check)
- **Global**: `.reveal.in` count > 10 after scroll; progress bar > 95% at bottom;
  **zero JS errors**

## 4 · Visual sanity

Screenshots at each widget state (`page.screenshot`) are produced during the suite for the
record even when the model can't view them — keep them in the run directory.

Pass bar: **100% assertions PASS, 0 JS errors.** Anything less is L4-max and must be
disclosed with a fix list.

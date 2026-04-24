# Slide Decks: HTML Slide Production Standards

Creating slide decks is a high-frequency scenario in design work. This document explains how to create high-quality HTML slides—from architecture selection, single-page design, to the complete path for PDF/PPTX export.

**This skill's capabilities cover**:
- HTML playback/PDF export → This document + `scripts/export_deck_pdf.mjs` / `scripts/export_deck_stage_pdf.mjs`
- Editable PPTX export → `references/editable-pptx.md` + `scripts/html2pptx.js` + `scripts/export_deck_pptx.mjs --mode editable`
- Image-based PPTX (non-editable but visually faithful) → `scripts/export_deck_pptx.mjs --mode image`

---

## 🛑 Before Starting: Confirm Delivery Format (The Hardest Checkpoint)

**This decision comes before "single file or multi-file".** Real test from 2026-04-20 option private board project: **Not confirming delivery format before starting = 2-3 hours of rework.**

### Decision Tree

```
│ Question: What needs to be delivered?
├── Just browser fullscreen presentation / local HTML    → Maximum visual freedom, build as you like
├── Need PDF (print / share / archive)      → Maximum visual freedom, any architecture can export
└── Need editable PPTX (colleagues will edit text)    → 🛑 From the first line of HTML, write according to the 4 hard constraints in `references/editable-pptx.md`
```

### Why "Need PPTX means starting from Path A from the beginning"

The prerequisite for PPTX to be editable is that `html2pptx.js` can translate DOM elements into PowerPoint objects one by one. It requires **4 hard constraints**:

1. Body fixed at 720pt × 405pt (not 1920×1080px)
2. All text wrapped in `<p>`/`<h1>`-`<h6>` (prohibit direct text in div, prohibit using `<span>` to carry main text)
3. `<p>`/`<h*>` themselves cannot have background/border/shadow (put in outer div)
4. `<div>` cannot use `background-image` (use `<img>` tag)
5. No CSS gradient, no web component, no complex SVG decoration

**This skill's default HTML has high visual freedom**—lots of spans, nested flex, complex SVGs, web components (like `<deck-stage>`), CSS gradients—**almost none naturally pass html2pptx constraints** (real test: visually-driven HTML directly on html2pptx, pass rate < 30%).

### Cost Comparison of Two Real Paths (Real Pitfalls from 2026-04-20)

| Path | Approach | Result | Cost |
|------|----------|--------|------|
| ❌ **Free HTML first, fix PPTX afterwards** | Single file deck-stage + lots of SVG/span decoration | Want editable PPTX only two paths:<br>A. Hand-write pptxgenjs hundreds of lines hardcoded coordinates<br>B. Rewrite 17 pages HTML to Path A format | 2-3 hours rework, and hand-written version **perpetual maintenance cost** (HTML change one word, PPTX needs manual sync again) |
| ✅ **Write following Path A constraints from first step** | Each page independent HTML + 4 hard constraints + 720×405pt | One command exports 100% editable PPTX, while also browser fullscreen presentation (Path A HTML is browser-playable standard HTML) | Spend 5 more minutes when writing HTML thinking "how to wrap text in `<p>`", zero rework |

### Opening Script (Copy and Use)

> Before starting, confirm delivery format:
> - **Browser presentation / PDF** → I'll use maximum design freedom (can use animation, web component, complex SVG, CSS gradient)
> - **Need editable PPTX** (colleagues will edit text) → I must write HTML following the 4 hard constraints in `references/editable-pptx.md` from the start. Visual capabilities will be less (no gradient, no web component, no complex SVG), but export is just one command
>
> Which one do you choose?

### What about Mixed Delivery

User says "I want HTML presentation **and** editable PPTX"——**this is not mixed**, PPTX requirement covers HTML requirement. HTML written following Path A can itself browser fullscreen presentation (just add a `deck_index.html` concatenator). **No additional cost.**

User says "I want PPTX **and** animation / web component"——**this is real contradiction**. Tell user: editable PPTX means sacrificing these visual capabilities. Let them make tradeoffs, don't secretly make hand-written pptxgenjs solution (will become perpetual maintenance debt).

### What if you only know PPTX is needed afterwards (Emergency Remedy)

Rare cases: HTML already written then discover PPTX needed. At this point neither option is perfect:

1. **Image-based PPTX** (`scripts/export_deck_pptx.mjs` image mode)—visual 100% faithful but text not editable. Suitable for "presentation uses PPT to play, don't change content" scenarios
2. **Hand-write pptxgenjs rebuild** (hand-write addText/addShape for each page + graphic PNG embedding)—text editable, but position, font, alignment all need manual tuning, high maintenance cost. **Only go this path if user explicitly accepts "HTML source change means manually re-tuning PPTX again"**

Always prioritize telling user the options, let them decide. **Never first reaction start hand-writing pptxgenjs**—that's the last fallback.

---

## 🛑 First Decide Architecture: Single File or Multi-file?

**This choice is the first step in making slides, getting it wrong will repeatedly pitfall. Read this section before starting.**

### Two Architecture Comparison

| Dimension | Single File + `deck_stage.js` | **Multi-file + `deck_index.html` Concatenator** |
|------|--------------------------|--------------------------------------|
| Code Structure | One HTML, all slides are `<section>` | Each page independent HTML, `index.html` uses iframe to concatenate |
| CSS Scope | ❌ Global, one page's style might affect all pages | ✅ Naturally isolated, iframes each have their own world |
| Validation Granularity | ❌ Need JS goTo to switch to a page | ✅ Single page file double-click can view in browser |
| Parallel Development | ❌ One file, multiple agents modifying will conflict | ✅ Multiple agents can work on different pages in parallel, zero conflict merge |
| Debugging Difficulty | ❌ One CSS error, whole deck crashes | ✅ One page error only affects itself |
| Embedded Interaction | ✅ Cross-page shared state very simple | 🟡 Need postMessage between iframes |
| Print PDF | ✅ Built-in | ✅ Concatenator beforeprint traverses iframes |
| Keyboard Navigation | ✅ Built-in | ✅ Concatenator built-in |

### Which One to Choose? (Decision Tree)

```
│ Question: How many pages expected for deck?
├── ≤10 pages, need in-deck animation or cross-page interaction, pitch deck → Single file
└── ≥10 pages, academic lecture, courseware, long deck, multi-agent parallel → Multi-file (recommended)
```

**Default go multi-file path**. It's not "alternative", it's **the main path for long decks and team collaboration**. Reason: every advantage of single-file architecture (keyboard navigation, printing, scale) multi-file has, while multi-file's scope isolation and verifiability single-file cannot make up.

### Why is this rule so hard? (Real Incident Record)

Single-file architecture once in AI psychology lecture deck creation hit four pitfalls consecutively:

1. **CSS specificity override**: `.emotion-slide { display: grid }` (specificity 10) knocked down `deck-stage > section { display: none }` (specificity 2), causing all pages to render overlapped simultaneously.
2. **Shadow DOM slot rules suppressed by outer CSS**: `::slotted(section) { display: none }` couldn't block outer rule override, sections refused to hide.
3. **localStorage + hash navigation race**: After refresh not jump to hash position, but stay at localStorage recorded old position.
4. **High validation cost**: Must `page.evaluate(d => d.goTo(n))` to screenshot a page, twice as slow as direct `goto(file://.../slides/05-X.html)`, and often errors.

All root causes are **single global namespace**—multi-file architecture physically eliminates these problems.

---

## Path A (Default): Multi-file Architecture

### Directory Structure

```
MyDeck/
├── index.html              # Copied from assets/deck_index.html, modify MANIFEST
├── shared/
│   ├── tokens.css          # Shared design tokens (color palette/font size/common chrome)
│   └── fonts.html          # <link> import Google Fonts (included in each page)
└── slides/
    ├── 01-cover.html       # Each file is complete 1920×1080 HTML
    ├── 02-agenda.html
    ├── 03-problem.html
    └── ...
```

### Template Skeleton for Each Slide

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>P05 · Chapter Title</title>
<link href="https://fonts.googleapis.com/css2?family=..." rel="stylesheet">
<link rel="stylesheet" href="../shared/tokens.css">
<style>
  /* Styles unique to this page. Use any class name won't pollute other pages. */
  body { padding: 120px; }
  .my-thing { ... }
</style>
</head>
<body>
  <!-- 1920×1080 content (locked by body's width/height in tokens.css) -->
  <div class="page-header">...</div>
  <div>...</div>
  <div class="page-footer">...</div>
</body>
</html>
```

**Key Constraints**:
- `<body>` is the canvas, layout directly on it. Don't wrap `<section>` or other wrapper.
- `width: 1920px; height: 1080px` locked by `body` rule in `shared/tokens.css`.
- Import `shared/tokens.css` to share design tokens (color palette, font sizes, page-header/footer, etc.).
- Font `<link>` written per page (fonts separate import not expensive, and ensures each page independently openable).

### Concatenator: `deck_index.html`

**Copy directly from `assets/deck_index.html`**. You only need to modify one place——`window.DECK_MANIFEST` array, list all slide file names and human-readable labels in order:

```js
window.DECK_MANIFEST = [
  { file: "slides/01-cover.html",    label: "Cover" },
  { file: "slides/02-agenda.html",   label: "Agenda" },
  { file: "slides/03-problem.html",  label: "Problem Statement" },
  // ...
];
```

Concatenator already built-in: keyboard navigation (←/→/Home/End/number keys/P to print), scale + letterbox, bottom-right counter, localStorage memory, hash jump to page, print mode (traverse iframe output PDF by page).

### Single Page Validation (This is Multi-file Architecture's Killer Advantage)

Each slide is independent HTML. **After finishing one, double-click to open in browser to view**:

```bash
open slides/05-personas.html
```

Playwright screenshot also directly `goto(file://.../slides/05-personas.html)`, no need JS page jump, won't be interfered by other pages' CSS. This makes "change a bit verify a bit" workflow cost near zero.

### Parallel Development

Split each slide's task to different agents, run simultaneously——HTML files independent of each other, no conflicts when merge. Long decks using this parallel method can compress production time to 1/N.

### What to Put in `shared/tokens.css`

Only put **truly cross-page shared** things:

- CSS variables (color palette, font size scale, spacing scale)
- `body { width: 1920px; height: 1080px; }` such canvas locking
- `.page-header` / `.page-footer` such chrome used identically on every page

**Don't** stuff single page's layout class in——that will regress to single-file architecture's global pollution problem.

---

## Path B (Small Deck): Single File + `deck_stage.js`

Suitable for ≤10 pages, need cross-page shared state (e.g., a React tweaks panel to control all pages), or doing pitch deck demo such scenarios requiring extreme compactness.

### Basic Usage

1. Read content from `assets/deck_stage.js`, embed in HTML's `<script>` (or `<script src="deck_stage.js">`)
2. Use `<deck-stage>` to wrap slides in body
3. 🛑 **script tag must be placed after `</deck-stage>`** (see hard constraints below)

```html
<body>

  <deck-stage>
    <section>
      <h1>Slide 1</h1>
    </section>
    <section>
      <h1>Slide 2</h1>
    </section>
  </deck-stage>

  <!-- ✅ Correct: script after deck-stage -->
  <script src="deck_stage.js"></script>

</body>
```

### 🛑 Script Position Hard Constraint (Real Pitfall from 2026-04-20)

**Cannot put `<script src="deck_stage.js">` in `<head>`**. Even if it can define `customElements` in `<head>`, parser when parsing to `<deck-stage>` start tag will trigger `connectedCallback`——at this time child `<section>` not yet parsed, `_collectSlides()` gets empty array, counter shows `1 / 0`, all pages render overlapped simultaneously.

**Three Compliant Writing Methods** (choose any one):

```html
<!-- ✅ Most recommended: script after </deck-stage> -->
</deck-stage>
<script src="deck_stage.js"></script>

<!-- ✅ Also OK: script in head but add defer -->
<head><script src="deck_stage.js" defer></script></head>

<!-- ✅ Also OK: module script naturally defer -->
<head><script src="deck_stage.js" type="module"></script></head>
```

`deck_stage.js` itself has built-in `DOMContentLoaded` delay collection defense, even if script in head won't completely explode——but `defer` or put at body bottom is still cleaner approach, avoid relying on defense branch.

### ⚠️ Single-file Architecture's CSS Trap (Must Read)

Single-file architecture's most common pitfall——**`display` property stolen by single-page style**.

Common Error Posture 1 (directly write display: flex to section):

```css
/* ❌ Outer CSS specificity 2, overrides shadow DOM's ::slotted(section){display:none} (also 2) */
deck-stage > section {
  display: flex;            /* All pages will render overlapped simultaneously! */
  flex-direction: column;
  padding: 80px;
  ...
}
```

Common Error Posture 2 (section has higher specificity class):

```css
.emotion-slide { display: grid; }   /* Specificity: 10, worse */
```

Both cause **all slides render overlapped simultaneously**——counter might show `1 / 10` pretending normal, but visually first page overlays second page overlays third page.

### ✅ Starter CSS (Copy Directly When Starting, Avoid Pitfalls)

**Section itself** only manages "visible/invisible"; **layout (flex/grid etc.) write to `.active`**:

```css
/* Section only defines non-display common styles */
deck-stage > section {
  background: var(--paper);
  padding: 80px 120px;
  overflow: hidden;
  position: relative;
  /* ⚠️ Don't write display here! */
}

/* Lock "non-active means hidden"——specificity+weight double insurance */
deck-stage > section:not(.active) {
  display: none !important;
}

/* Active page only write needed display + layout */
deck-stage > section.active {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

/* Print mode: all pages need to show, override :not(.active) */
@media print {
  deck-stage > section { display: flex !important; }
  deck-stage > section:not(.active) { display: flex !important; }
}
```

Alternative approach: **write single page's flex/grid to inner wrapper `<div>`**, section itself forever only `display: block/none` switcher. This is cleanest approach:

```html
<deck-stage>
  <section>
    <div class="slide-content flex-layout">...</div>
  </section>
</deck-stage>
```

### Custom Dimensions

```html
<deck-stage width="1080" height="1920">
  <!-- 9:16 portrait -->
</deck-stage>
```

---

## Slide Labels

Deck_stage and deck_index both label each page (counter displays). Give them **more meaningful** labels:

**Multi-file**: Write in `MANIFEST` `{ file, label: "04 Problem Statement" }`
**Single-file**: Add on section `<section data-screen-label="04 Problem Statement">`

**Key: Slide numbering starts from 1, not 0**.

When user says "slide 5", they mean the 5th slide, never array position `[4]`. Humans don't speak 0-indexed.

---

## Speaker Notes

**Default not added**, only add when user explicitly requests.

Added speaker notes lets you reduce slide text to minimum, focus on impactful visuals——notes carry complete script.

### Format

**Multi-file**: Write in `<head>` of `index.html`:

```html
<script type="application/json" id="speaker-notes">
[
  "Script for page 1...",
  "Script for page 2...",
  "..."
]
</script>
```

**Single-file**: Same location.

### Notes Writing Points

- **Complete**: Not outline, but actual words to speak
- **Conversational**: Like normal speech, not written language
- **Correspond**: Array Nth corresponds to Nth slide
- **Length**: 200-400 words optimal
- **Emotional Line**: Mark stress, pause, emphasis points

---

## Slide Design Patterns

### 1. Establish a System (Must Do)

After exploring design context, **first verbally say the system you'll use**:

```markdown
Deck System:
- Background colors: Max 2 types (90% white + 10% dark section divider)
- Typography: display uses Instrument Serif, body uses Geist Sans
- Rhythm: section divider uses full-bleed color + white text, normal slide white background
- Images: hero slide uses full-bleed photo, data slide uses chart

I'll work following this system, tell me if any issues.
```

After user confirms then continue.

### 2. Common Slide Layouts

- **Title slide**: Solid color background + huge title + subtitle + author/date
- **Section divider**: Color background + section number + section title
- **Content slide**: White background + title + 1-3 bullet points
- **Data slide**: Title + large chart/numbers + brief explanation
- **Image slide**: Full-bleed photo + bottom small caption
- **Quote slide**: Whitespace + huge quote + attribution
- **Two-column**: Left-right contrast (vs / before-after / problem-solution)

One deck uses at most 4-5 layout types.

### 3. Scale (Emphasize Again)

- Body text minimum **24px**, optimal 28-36px
- Title **60-120px**
- Hero text **180-240px**
- Slides are viewed from 10 meters away, text must be large enough

### 4. Visual Rhythm

Deck needs **intentional variety**:

- Color rhythm: mostly white background + occasional color section divider + occasional dark segments
- Density rhythm: several text-heavy + several image-heavy + several quote whitespace
- Font size rhythm: normal title + occasional giant hero text

**Don't make every slide look same**——that's PPT template, not design.

### 5. Spatial Breathing (Data-Dense Pages Must Read)

**Newcomer's easiest pitfall**: stuff all possible information into one page.

Information density ≠ effective information delivery. Academic/presentation decks especially need restraint:

- List/matrix pages: Don't draw all N elements same size. Use **primary-secondary layering**——magnify 5 to discuss today as protagonists, shrink remaining 16 as background hints.
- Big number pages: Number itself is visual protagonist. Surrounding caption should not exceed 3 lines, otherwise audience eyes jump back and forth.
- Quote pages: Need whitespace between quote and attribution, don't stick together.

Self-check against "is data the protagonist", "is text squeezed together", revise until whitespace makes you somewhat uneasy.

---

## Print to PDF

**Multi-file**: `deck_index.html` already handles `beforeprint` event, output PDF by page.

**Single-file**: `deck_stage.js` similarly handles.

Print styles already written, no need to additionally write `@media print` CSS.

---

## Export to PPTX / PDF (Self-Service Scripts)

HTML is first-class citizen. But users often need PPTX/PDF delivery. Provide two universal scripts, **any multi-file deck can use**, located in `scripts/`:

### `export_deck_pdf.mjs` — Export Vector PDF (Multi-file Architecture)

```bash
node scripts/export_deck_pdf.mjs --slides <slides-dir> --out deck.pdf
```

**Features**:
- Text **retains vector** (copyable, searchable)
- Visual 100% faithful (Playwright embedded Chromium rendering then print)
- **Doesn't need to change HTML a single word**
- Each slide independent `page.pdf()`, then merge with `pdf-lib`

**Dependencies**: `npm install playwright pdf-lib`

**Limitations**: PDF cannot edit text anymore——to change return to HTML to change.

### `export_deck_stage_pdf.mjs` — Single File deck-stage Architecture Exclusive ⚠️

**When to use**: Deck is single HTML file + `<deck-stage>` web component wrapping N `<section>` (i.e., Path B architecture). At this time `export_deck_pdf.mjs` that "each HTML once `page.pdf()`" doesn't work, need to use this exclusive script.

```bash
node scripts/export_deck_stage_pdf.mjs --html deck.html --out deck.pdf
```

**Why Cannot Reuse export_deck_pdf.mjs** (Real Pitfall Record from 2026-04-20):

1. **Shadow DOM Wins Over `!important`**: deck-stage's shadow CSS has `::slotted(section) { display: none }` (only active that one `display: block`). Even if use `@media print { deck-stage > section { display: block !important } }` in light DOM can't suppress——`page.pdf()` triggers print media after Chromium final render only has active that one, result **entire PDF only 1 page** (current active slide's repetition).

2. **Loop goto each page still only outputs 1 page**: Intuitive solution "for each `#slide-N` navigate once then `page.pdf({pageRanges:'1'})`" also fails——because print CSS outside shadow DOM also has `deck-stage > section { display: block }` rule after override, final render always section list's first (not the page you navigate to). Result 17 loops get 17 P01 covers.

3. **Absolute child elements run to next page**: Even if successfully make all sections render, section itself if `position: static`, its absolute positioned `cover-footer`/`slide-footer` will position relative to initial containing block——when section forced by print to 1080px height, absolute footer might be pushed to next page (manifests as PDF one more page than section count, extra page only contains orphan footer).

**Fix Strategy** (Script Already Implemented):

```js
// After opening HTML, use page.evaluate to extract section from deck-stage slot,
// Directly hang under body a normal div, and inline style ensure position:relative + fixed dimensions
await page.evaluate(() => {
  const stage = document.querySelector('deck-stage');
  const sections = Array.from(stage.querySelectorAll(':scope > section'));
  document.head.appendChild(Object.assign(document.createElement('style'), {
    textContent: `
      @page { size: 1920px 1080px; margin: 0; }
      html, body { margin: 0 !important; padding: 0 !important; }
      deck-stage { display: none !important; }
    `,
  }));
  const container = document.createElement('div');
  sections.forEach(s => {
    s.style.cssText = 'width:1920px!important;height:1080px!important;display:block!important;position:relative!important;overflow:hidden!important;page-break-after:always!important;break-after:page!important;background:#F7F4EF;margin:0!important;padding:0!important;';
    container.appendChild(s);
  });
  // Last page disable pagination, avoid tail blank page
  sections[sections.length - 1].style.pageBreakAfter = 'auto';
  sections[sections.length - 1].style.breakAfter = 'auto';
  document.body.appendChild(container);
});

await page.pdf({ width: '1920px', height: '1080px', printBackground: true, preferCSSPageSize: true });
```

**Why This Works**:
- Extract section from shadow DOM slot to light DOM's normal div——completely bypass `::slotted(section) { display: none }` rule
- Inline `position: relative` makes absolute child elements position relative to section, won't overflow
- `page-break-after: always` makes browser print each section independent page
- `:last-child` no pagination avoid tail blank page

**When using `mdls -name kMDItemNumberOfPages` to verify note**: macOS's Spotlight metadata has cache, PDF rewrite needs run `mdimport file.pdf` force refresh, otherwise displays old page count. Use `pdfinfo` or `pdftoppm` count files is real count.

---

### `export_deck_pptx.mjs` — Export PPTX (Two Modes)

```bash
# Image-based (visual 100% faithful, non-editable text)
node scripts/export_deck_pptx.mjs --slides <dir> --out deck.pptx --mode image

# Each text independent text box (editable, but font fallback)
node scripts/export_deck_pptx.mjs --slides <dir> --out deck.pptx --mode editable
```

| Mode | Visual Fidelity | Text Editable | How It Works | Limitations |
|------|---------|----------|---------|------|
| `image` | ✅ 100% | ❌ | Playwright screenshot → pptxgenjs addImage | Text becomes image |
| `editable` | 🟡 ~70% | ✅ | html2pptx extract each text box | See constraints below |

**Hard constraints of editable mode** (user HTML must satisfy, otherwise that page skip):
- All text must be in `<p>`/`<h1>`-`<h6>`/`<ul>`/`<ol>` (prohibit bare text div)
- `<p>`/`<h*>` tags themselves cannot have background/border/shadow (put in outer div)
- Don't use `::before`/`::after` insert decoration text (pseudo-elements cannot be extracted)
- Inline elements (span/em/strong) cannot have margin
- Don't use CSS gradient (not renderable)
- Div doesn't use `background-image` (use `<img>`)

Script already built-in **automatic preprocessor**——automatically wrap "bare text in leaf div" into `<p>` (preserve class). This solves most common violation (bare text). But other violations (border on p, margin on span etc.) still need HTML source compliant.

**Another caveat of editable mode——font fallback**:
- Playwright uses webfont measure text-box dimensions; PowerPoint/Keynote uses local machine font rendering
- When differ, there's **overflow or misalignment**——each page needs visual check
- Suggest target machine install fonts used in HTML, or fallback to `system-ui`

### Make HTML Export-Friendly from the Start

Most stable deck for performance: **write HTML following editable mode constraints from start**. This way `--mode editable` can directly all pass. Extra cost not large:

```html
<!-- ❌ Not good -->
<div class="title">Key Findings</div>

<!-- ✅ Good (p wraps, class inherits) -->
<p class="title">Key Findings</p>

<!-- ❌ Not good (border on p) -->
<p class="stat" style="border-left: 3px solid red;">41%</p>

<!-- ✅ Good (border on outer div) -->
<div class="stat-wrap" style="border-left: 3px solid red;">
  <p class="stat">41%</p>
</div>
```

### When to Choose Which

| Scenario | Recommended |
|------|------|
| Give organizer/archive storage | **PDF** (universal, high fidelity, text searchable) |
| Send to collaborators let them tweak text | **PPTX editable** (accept font fallback) |
| Need live presentation, don't change content | **PDF** or **PPTX image** |
| HTML is preferred presentation medium | Direct browser playback, export just backup |

## Deep Path to Export Editable PPTX (Long-term Projects Only)

If your deck will be long-term maintained, repeatedly modified, team collaboration——suggest **write HTML following html2pptx constraints from start**, make `--mode editable` stably pass. See details in `references/editable-pptx.md` (4 hard constraints + HTML templates + common errors quick reference).

---

## Common Questions

**Multi-file: Pages in iframe won't open / white screen**
→ Check `MANIFEST`'s `file` path relative to `index.html` correct. Use browser DevTools to see if iframe's src can directly access.

**Multi-file: One page's style conflicts with other pages**
→ Impossible (iframe isolation). If feel conflict, that's cache——Cmd+Shift+R force refresh.

**Single-file: Multiple slides render overlapped simultaneously**
→ CSS specificity issue. See above "Single-file Architecture's CSS Trap" section.

**Single-file: Scale looks wrong**
→ Check if all slides directly hang under `<deck-stage>` as `<section>`. Cannot wrap `<div>` in middle.

**Single-file: Want to jump to specific slide**
→ URL add hash: `index.html#slide-5` jump to 5th slide.

**Both architectures apply: Text position inconsistent across different screens**
→ Use fixed dimensions (1920×1080) and `px` units, don't use `vw`/`vh` or `%`. Scaling uniformly handled.

---

## Validation Checklist (Must Pass After Finishing Deck)

1. [ ] Browser directly open `index.html` (or main HTML), check homepage no broken images, fonts loaded
2. [ ] Press → key flip through each page, no blank pages, no layout misalignment
3. [ ] Press P key print preview, each page exactly one A4 (or 1920×1080) and no cropping
4. [ ] Randomly select 3 pages Cmd+Shift+R force refresh, localStorage memory works normally
5. [ ] Playwright batch screenshots (single-page architecture: traverse `slides/*.html`; single-file architecture: use goTo to switch), manual visual review once
6. [ ] Search for `TODO` / `placeholder` residue, confirm all cleaned

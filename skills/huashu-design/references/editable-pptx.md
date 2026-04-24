# Editable PPTX Export: HTML Hard Constraints + Size Decisions + Common Mistakes

This document covers **using `scripts/html2pptx.js` + `pptxgenjs` to translate HTML element-by-element into truly editable PowerPoint text boxes**. This is completely different from `export_deck_pptx.mjs --mode image` (screenshots as background, text becomes images, not editable).

> **Core premise**: To follow this path, HTML must be written according to the following 4 constraints from the very first line. **Don't write it first then convert** — post-hoc fixes will trigger 2-3 hours of rework (actual pain point from the 2026-04-20 equity private board project).

---

## Canvas Size: Use 960×540pt (LAYOUT_WIDE)

PPTX units are **inches** (physical dimensions), not px. Decision principle: body's computedStyle dimensions must **match the presentation layout's inch dimensions** (±0.1", enforced by `html2pptx.js`'s `validateDimensions`).

### Comparison of 3 candidate sizes

| HTML body | Physical size | Corresponding PPT layout | When to choose |
|---|---|---|---|
| **`960pt × 540pt`** | **13.333″ × 7.5″** | **pptxgenjs `LAYOUT_WIDE`** | ✅ **Default recommended** (modern PowerPoint 16:9 standard) |
| `720pt × 405pt` | 10″ × 5.625″ | Custom | Only when user specifies "old PowerPoint Widescreen" template |
| `1920px × 1080px` | 20″ × 11.25″ | Custom | ❌ Non-standard size, fonts appear abnormally small after projection |

**Don't think of HTML dimensions as resolution.** PPTX is a vector document; body dimensions determine **physical size**, not clarity. Oversized body (20″×11.25″) won't make text clearer — it only makes font-size pt relatively smaller against the canvas, making it worse for projection/printing.

### Three equivalent body writing methods

```css
body { width: 960pt;  height: 540pt; }    /* Clearest, recommended */
body { width: 1280px; height: 720px; }    /* Equivalent, px habit */
body { width: 13.333in; height: 7.5in; }  /* Equivalent, inch intuition */
```

Matching pptxgenjs code:

```js
const pptx = new pptxgen();
pptx.layout = 'LAYOUT_WIDE';  // 13.333 × 7.5 inch, no customization needed
```

---

## 4 Hard Constraints (violations will throw errors directly)

`html2pptx.js` translates HTML DOM element-by-element into PowerPoint objects. PowerPoint's format constraints projected onto HTML = the following 4 rules.

### Rule 1: DIVs cannot contain raw text — must wrap with `<p>` or `<h1>`-`<h6>`

```html
<!-- ❌ Wrong: text directly in div -->
<div class="title">Q3 revenue grew 23%</div>

<!-- ✅ Correct: text in <p> or <h1>-<h6> -->
<div class="title"><h1>Q3 revenue grew 23%</h1></div>
<div class="body"><p>New users are the main driver</p></div>
```

**Why**: PowerPoint text must exist in a text frame, which corresponds to HTML's paragraph-level elements (p/h*/li). Bare `<div>` has no corresponding text container in PPTX.

**Also cannot use `<span>` for main text** — span is an inline element and cannot be independently aligned into a text box. span can only be **nested inside p/h*** for local styling (bold, color change).

### Rule 2: CSS gradients not supported — solid colors only

```css
/* ❌ Wrong */
background: linear-gradient(to right, #FF6B6B, #4ECDC4);

/* ✅ Correct: solid color */
background: #FF6B6B;

/* ✅ If multi-color stripes are necessary, use flex child elements with individual solid colors */
.stripe-bar { display: flex; }
.stripe-bar div { flex: 1; }
.red   { background: #FF6B6B; }
.teal  { background: #4ECDC4; }
```

**Why**: PowerPoint's shape fill only supports solid/gradient-fill types, but pptxgenjs's `fill: { color: ... }` only maps solid. Gradients via PowerPoint's native gradient require separate structure, currently not supported by the toolchain.

### Rule 3: Background/border/shadow only on DIVs, not on text tags

```html
<!-- ❌ Wrong: <p> has background color -->
<p style="background: #FFD700; border-radius: 4px;">Key content</p>

<!-- ✅ Correct: outer div carries background/border, <p> only handles text -->
<div style="background: #FFD700; border-radius: 4px; padding: 8pt 12pt;">
  <p>Key content</p>
</div>
```

**Why**: In PowerPoint, shape (rectangle/rounded rectangle) and text frame are two separate objects. HTML's `<p>` only translates to text frame; background/border/shadow belong to shape — must be written on the **div wrapping the text**.

### Rule 4: DIVs cannot use `background-image` — use `<img>` tag instead

```html
<!-- ❌ Wrong -->
<div style="background-image: url('chart.png')"></div>

<!-- ✅ Correct -->
<img src="chart.png" style="position: absolute; left: 50%; top: 20%; width: 300pt; height: 200pt;" />
```

**Why**: `html2pptx.js` only extracts image paths from `<img>` elements, does not parse CSS `background-image` URLs.

---

## Path A HTML Template Skeleton

Each slide is a separate HTML file with isolated scopes (avoiding CSS pollution from single-file decks).

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    width: 960pt; height: 540pt;           /* ⚠️ Match LAYOUT_WIDE */
    font-family: system-ui, -apple-system, "PingFang SC", sans-serif;
    background: #FEFEF9;                    /* Solid color, no gradients */
    overflow: hidden;
  }
  /* DIVs handle layout/background/border */
  .card {
    position: absolute;
    background: #1A4A8A;                    /* Background on DIV */
    border-radius: 4pt;
    padding: 12pt 16pt;
  }
  /* Text tags only handle font styles, no background/border */
  .card h2 { font-size: 24pt; color: #FFFFFF; font-weight: 700; }
  .card p  { font-size: 14pt; color: rgba(255,255,255,0.85); }
</style>
</head>
<body>

  <!-- Title area: outer div for positioning, inner text tags -->
  <div style="position: absolute; top: 40pt; left: 60pt; right: 60pt;">
    <h1 style="font-size: 36pt; color: #1A1A1A; font-weight: 700;">Title uses declarative statements, not topic words</h1>
    <p style="font-size: 16pt; color: #555555; margin-top: 10pt;">Subtitle provides additional explanation</p>
  </div>

  <!-- Content card: div handles background, h2/p handle text -->
  <div class="card" style="top: 130pt; left: 60pt; width: 240pt; height: 160pt;">
    <h2>Key Point One</h2>
    <p>Brief explanatory text</p>
  </div>

  <!-- List: use ul/li, not manual • symbols -->
  <div style="position: absolute; top: 320pt; left: 60pt; width: 540pt;">
    <ul style="font-size: 16pt; color: #1A1A1A; padding-left: 24pt; list-style: disc;">
      <li>First bullet point</li>
      <li>Second bullet point</li>
      <li>Third bullet point</li>
    </ul>
  </div>

  <!-- Illustration: use <img> tag, not background-image -->
  <img src="illustration.png" style="position: absolute; right: 60pt; top: 110pt; width: 320pt; height: 240pt;" />

</body>
</html>
```

---

## Common Errors Quick Reference

| Error message | Cause | Fix method |
|---------|------|---------|
| `DIV element contains unwrapped text "XXX"` | div has bare text | Wrap text in `<p>` or `<h1>`-`<h6>` |
| `CSS gradients are not supported` | Used linear/radial-gradient | Change to solid color, or use flex child elements for segments |
| `Text element <p> has background` | `<p>` tag has background color | Wrap with `<div>` to carry background, `<p>` only for text |
| `Background images on DIV elements are not supported` | div used background-image | Change to `<img>` tag |
| `HTML content overflows body by Xpt vertically` | Content exceeds 540pt | Reduce content or shrink font size, or `overflow: hidden` to truncate |
| `HTML dimensions don't match presentation layout` | body dimensions don't match pres layout | body use `960pt × 540pt` with `LAYOUT_WIDE`; or defineLayout for custom dimensions |
| `Text box "XXX" ends too close to bottom edge` | Large font-size `<p>` is < 0.5 inch from body bottom edge | Move up, leave sufficient bottom margin; PPT bottom is partially obscured anyway |

---

## Basic Workflow (3 steps to PPTX)

### Step 1: Write each page as independent HTML following constraints

```
MyDeck/
├── slides/
│   ├── 01-cover.html    # Each file is a complete 960×540pt HTML
│   ├── 02-agenda.html
│   └── ...
└── illustration/        # All images referenced by <img>
    ├── chart1.png
    └── ...
```

### Step 2: Write build.js to call `html2pptx.js`

```js
const pptxgen = require('pptxgenjs');
const html2pptx = require('../scripts/html2pptx.js');  // This skill's script

(async () => {
  const pres = new pptxgen();
  pres.layout = 'LAYOUT_WIDE';  // 13.333 × 7.5 inch, matches HTML's 960×540pt

  const slides = ['01-cover.html', '02-agenda.html', '03-content.html'];
  for (const file of slides) {
    await html2pptx(`./slides/${file}`, pres);
  }

  await pres.writeFile({ fileName: 'deck.pptx' });
})();
```

### Step 3: Open and verify

- Open exported PPTX in PowerPoint/Keynote
- Double-click any text should be directly editable (if it's an image, Rule 1 was violated)
- Verify overflow: each page should be within body bounds, not truncated

---

## This Path vs Other Options (when to choose what)

| Need | What to choose |
|------|------|
| Colleagues will edit text in PPTX / send to non-technical staff for further editing | **This path** (editable, requires writing HTML following 4 constraints from start) |
| Only for presentation / archiving, no further changes | `export_deck_pdf.mjs` (multi-file) or `export_deck_stage_pdf.mjs` (single-file deck-stage), output vector PDF |
| Visual freedom priority (animations, web components, CSS gradients, complex SVG), accept non-editable | `export_deck_pptx.mjs --mode image` (image-background PPTX) |

**Never run html2pptx on HTML written for visual freedom** — actual tests show visually-driven HTML pass rate < 30%, remaining page-by-page retrofitting is slower than rewriting.

---

## Why 4 Constraints Are Not Bugs But Physical Constraints

These 4 are not due to `html2pptx.js` author laziness — they are the result of **PowerPoint file format (OOXML) constraints themselves** projected onto HTML:

- PPTX text must be in text frame (`<a:txBody>`), corresponding to paragraph-level HTML elements
- PPTX's shape and text frame are two objects, cannot draw background and write text on same element simultaneously
- PPTX's shape fill has limited gradient support (only certain preset gradients, not CSS arbitrary-angle gradients)
- PPTX's picture object must reference actual image files, not CSS properties

Understanding this, **don't expect the tool to become smarter** — it's the HTML writing that must adapt to PPTX format, not the reverse.

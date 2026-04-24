# Gallery Ripple + Multi-Focus · Scene Orchestration Philosophy

> A **reusable visual orchestration structure** distilled from huashu-design hero animation v9 (25 seconds, 8 scenes).
> Not an animation production pipeline, but **when this orchestration is "the right choice"**.
> Practical reference: [demos/hero-animation-v9.mp4](../demos/hero-animation-v9.mp4) · [https://www.huasheng.ai/huashu-design-hero/](https://www.huasheng.ai/huashu-design-hero/)

## One-Line Summary

> **When you have 20+ homogeneous visual materials and need to "express scale and depth," prioritize Gallery Ripple + Multi-Focus orchestration instead of stacking layouts.**

Universal SaaS feature animations, product launches, skill promotions, series portfolio showcases—as long as you have enough materials and consistent style, this structure almost always delivers results.

---

## What This Technique Actually Expresses

Not "showing off materials"—but telling a narrative through **two rhythmic changes**:

**First Beat · Ripple Expansion (~1.5s)**: 48 cards spread outward from the center to the surroundings, the audience is struck by the "quantity"—"Oh, this thing has so much output."

**Second Beat · Multi-Focus (~8s, 4 cycles)**: While the camera pans slowly, 4 times the background is dimmed + desaturated, and a single card is magnified to the center of the screen—the audience shifts from "quantity shock" to "quality gaze," with a steady 1.7s rhythm each time.

**Core Narrative Structure**: **Scale (Ripple) → Gaze (Focus × 4) → Fade Out (Walloff)**. These three beats combined express "Breadth × Depth"—not just capable of doing a lot, but each one worth stopping to look at.

Compare with counter-examples:

| Approach | Audience Perception |
|---------|-------------------|
| 48 cards statically arranged (no Ripple) | Nice but no narrative, like a grid screenshot |
| Fast cutting one by one (no Gallery context) | Like a slideshow, loses "sense of scale" |
| Only Ripple without Focus | Shocked but didn't make anyone remember any specific one |
| **Ripple + Focus × 4 (this recipe)** | **First shocked by quantity, then gaze at quality, finally calm fade-out—complete emotional arc** |

---

## Prerequisites (Must All Be Satisfied)

This orchestration **is not universal**, all 4 conditions below are indispensable:

1. **Material scale ≥ 20, preferably 30+**
   Less than 20 makes Ripple appear "empty"—only when every cell is moving in a 48-grid creates density. v9 used 48 cells × 32 images (cycled).

2. **Visual style of materials is consistent**
   All 16:9 slide previews / all app screenshots / all cover designs—aspect ratio, color tone, layout must look like "a set." Mixing makes the Gallery look like a clipboard.

3. **Materials remain readable when magnified individually**
   Focus magnifies a card to 960px wide; if the original image becomes blurry or information-sparse when enlarged, the Focus beat is wasted. Reverse validation: can you pick 4 "most representative" ones from the 48? If not, material quality is uneven.

4. **Scene itself is landscape or square, not portrait**
   Gallery's 3D tilt (`rotateX(14deg) rotateY(-10deg)`) requires horizontal extension, portrait makes the tilt effect look narrow and awkward.

**Fallback paths for missing conditions**:

| Missing What | Degrades To |
|-------------|------------|
| Materials < 20 | Use "3-5 side-by-side static display + individual focus" |
| Inconsistent style | Use "cover + 3 chapter large images" keynote-style |
| Sparse information | Use "data-driven dashboard" or "golden quote + large text" |
| Portrait scene | Use "vertical scroll + sticky cards" |

---

## Technical Recipe (v9 Practical Parameters)

### 4-Layer Structure

```
viewport (1920×1080, perspective: 2400px)
  └─ canvas (4320×2520, ultra-large overflow) → 3D tilt + pan
      └─ 8×6 grid = 48 cards (gap 40px, padding 60px)
          └─ img (16:9, border-radius 9px)
      └─ focus-overlay (absolute center, z-index 40)
          └─ img (matches selected slide)
```

**Key**: canvas is 2.25× larger than viewport, so pan creates the feeling of "peeking into a larger world."

### Ripple Expansion (Distance Delay Algorithm)

```js
// Entry time for each card = distance from center × 0.8s delay
const col = i % 8, row = Math.floor(i / 8);
const dc = col - 3.5, dr = row - 2.5;       // offset to center
const dist = Math.hypot(dc, dr);
const maxDist = Math.hypot(3.5, 2.5);
const delay = (dist / maxDist) * 0.8;       // 0 → 0.8s
const localT = Math.max(0, (t - rippleStart - delay) / 0.7);
const opacity = expoOut(Math.min(1, localT));
```

**Core Parameters**:
- Total duration 1.7s (`T.s3_ripple: [8.3, 10.0]`)
- Maximum delay 0.8s (center appears first, corners last)
- Each card entry duration 0.7s
- Easing: `expoOut` (explosive feel, not smooth)

**Simultaneous action**: canvas scale from 1.25 → 0.94 (zoom out to reveal)—synchronous push-back feeling paired with appearance.

### Multi-Focus (4-Beat Rhythm)

```js
T.focuses = [
  { start: 11.0, end: 12.7, idx: 2  },  // 1.7s
  { start: 13.3, end: 15.0, idx: 3  },  // 1.7s
  { start: 15.6, end: 17.3, idx: 10 },  // 1.7s
  { start: 17.9, end: 19.6, idx: 16 },  // 1.7s
];
```

**Rhythm pattern**: Each focus 1.7s, 0.6s pause interval. Total 8s (11.0–19.6s).

**Inside each focus**:
- In ramp: 0.4s (`expoOut`)
- Hold: Middle 0.9s (`focusIntensity = 1`)
- Out ramp: 0.4s (`easeOut`)

**Background changes (this is key)**:

```js
if (focusIntensity > 0) {
  const dimOp = entryOp * (1 - 0.6 * focusIntensity);  // dim to 40%
  const brt = 1 - 0.32 * focusIntensity;                // brightness 68%
  const sat = 1 - 0.35 * focusIntensity;                // saturate 65%
  card.style.filter = `brightness(${brt}) saturate(${sat})`;
}
```

**Not just opacity—simultaneously desaturate + darken**. This makes the foreground overlay's colors "pop out" instead of just "getting brighter."

**Focus overlay size animation**:
- From 400×225 (entry) → 960×540 (hold state)
- Perimeter has 3 shadow layers + 3px accent color outline ring, creating "framed feeling"

### Pan (Continuity Makes Static Not Boring)

```js
const panT = Math.max(0, t - 8.6);
const panX = Math.sin(panT * 0.12) * 220 - panT * 8;
const panY = Math.cos(panT * 0.09) * 120 - panT * 5;
```

- Sine wave + linear drift dual-layer motion—not pure cycle, each moment's position is different
- X/Y frequencies different (0.12 vs 0.09) to avoid visually detecting "regular cycle"
- Clamped at ±900/500px to prevent drifting out

**Why not pure linear pan**: Pure linear makes the audience "predict" where the next second is; sine+drift makes every second new, under 3D tilt creates "slight seasickness feeling" (the good kind), attention is grabbed.

---

## 5 Reusable Patterns (Distilled from v6→v9 Iteration)

### 1. **expoOut as Primary Easing, Not cubicOut**

`easeOut = 1 - (1-t)³` (smooth) vs `expoOut = 1 - 2^(-10t)` (explosive then rapid convergence).

**Rationale**: expoOut's first 30% quickly reaches 90%, more like physical damping, matches the intuition of "heavy things landing." Particularly suitable for:
- Card entry (weight feel)
- Ripple expansion (shockwave)
- Brand float-up (settling feel)

**When to still use cubicOut**: focus out ramp, symmetrical micro-animations.

### 2. **Paper-feel Base + Terracotta Accent (Anthropic Heritage)**

```css
--bg: #F7F4EE;        /* warm paper */
--ink: #1D1D1F;       /* almost black */
--accent: #D97757;    /* terracotta orange */
--hairline: #E4DED2;  /* warm line */
```

**Why**: Warm base colors retain "breathing feel" even after GIF compression, unlike pure white which appears "screen-like." Terracotta orange as the sole accent runs through terminal prompt, dir-card selection, cursor, brand hyphen, focus ring—all visual anchors are strung together by this one color.

**v5 lesson**: Added noise overlay to simulate "paper grain," result was GIF frame compression destroyed everything (every frame different). v6 changed to "only base color + warm shadow," paper feel retained 90%, GIF size reduced 60%.

### 3. **Two-Tier Shadow Simulates Depth, No Real 3D**

```css
.gallery-card.depth-near { box-shadow: 0 32px 80px -22px rgba(60,40,20,0.22), ... }
.gallery-card.depth-far  { box-shadow: 0 14px 40px -16px rgba(60,40,20,0.10), ... }
```

Use `sin(i × 1.7) + cos(i × 0.73)` deterministic algorithm to assign each card near/mid/far three-tier shadow—**visually has "3D stacking" feel, but each frame's transform completely unchanged, GPU consumption 0**.

**Cost of real 3D**: Each card individually `translateZ`, GPU calculates 48 transforms + shadow blur every frame. v4 tried this, Playwright recording at 25fps struggled. v6's two-tier shadow visual effect difference <5%, but cost difference 10×.

### 4. **Font Weight Variation (font-variation-settings) More Cinematic Than Font Size Change**

```js
const wght = 100 + (700 - 100) * morphP;  // 100 → 700 over 0.9s
wordmark.style.fontVariationSettings = `"wght" ${wght.toFixed(0)}`;
```

Brand wordmark from Thin → Bold using 0.9s gradient, paired with letter-spacing micro-adjustment (-0.045 → -0.048em).

**Why better than zooming**:
- Zooming in/out audiences have seen too much, expectations solidified
- Font weight change is "intrinsic fullness feel," like balloon being inflated, not "being pushed closer"
- Variable fonts are features only popularized 2020+, audiences subconsciously feel "modern"

**Limitation**: Must use variable font-supporting fonts (Inter/Roboto Flex/Recursive, etc.). Ordinary static fonts can only mimic (switching a few fixed weights has jumps).

### 5. **Corner Brand Low-Intensity Continuous Signature**

During Gallery phase there's a `HUASHU · DESIGN` small mark in top-left, 16% opacity color value, 12px font size, wide letter-spacing.

**Why add this**:
- After Ripple explosion audience easily "loses focus" forgetting what they're watching, top-left light mark helps anchor
- More premium than full-screen large logo—branders know, brand signature doesn't need to shout
- Still leaves attribution signal when GIF is screenshotted and shared

**Rule**: Only appears in mid-section (screen busy), opening off (doesn't block terminal), ending off (brand reveal is protagonist).

---

## Counter-Examples: When Not to Use This Orchestration

**❌ Product Demo (showing features)**: Gallery makes each one flash by, audience can't remember any function. Use "single-screen focus + tooltip annotation" instead.

**❌ Data-Driven Content**: Audience needs to read numbers, Gallery's fast rhythm gives no time to read. Use "data charts + item-by-item reveal" instead.

**❌ Story Narrative**: Gallery is "parallel" structure, stories need "causality." Use keynote chapter switching instead.

**❌ Only 3-5 Materials**: Ripple density insufficient, looks like "patches." Use "static arrangement + individual highlight" instead.

**❌ Portrait (9:16)**: 3D tilt needs horizontal extension, portrait makes tilt feel "crooked" not "expanding."

---

## How to Judge If Your Task Fits This Orchestration

Three-step quick check:

**Step 1 · Material Count**: Count how many similar visual materials you have. <15 → stop; 15-25 → scrape together; 25+ → use directly.

**Step 2 · Consistency Test**: Put 4 random materials side by side, do they look like "a set"? If not → unify style first or change plan.

**Step 3 · Narrative Match**: Are you expressing "Breadth × Depth" (quantity × quality)? Or "process," "function," "story"? If not the former, don't force it.

All three steps yes, directly fork v6 HTML, modify `SLIDE_FILES` array and timeline to reuse. Change palette by modifying `--bg / --accent / --ink`, reskin without changing structure.

---

## Related References

- Complete technical process: [references/animations.md](animations.md) · [references/animation-best-practices.md](animation-best-practices.md)
- Animation export pipeline: [references/video-export.md](video-export.md)
- Audio configuration (BGM + SFX dual track): [references/audio-design-rules.md](audio-design-rules.md)
- Apple gallery-style horizontal reference: [references/apple-gallery-showcase.md](apple-gallery-showcase.md)
- Source HTML (v6 + audio integrated version): `www.huasheng.ai/huashu-design-hero/index.html`

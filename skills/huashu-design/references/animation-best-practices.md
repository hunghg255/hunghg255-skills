# Animation Best Practices · Forward Animation Design Grammar

> Based on deep analysis of Anthropic's official product animations (Claude Design / Claude Code Desktop / Claude for Word),
> extracted "Anthropic-level" animation design rules.
>
> Use alongside `animation-pitfalls.md` (avoidance checklist) — this file is "**DO THIS**",
> pitfalls is "**DON'T DO THIS**", both are orthogonal and should be read.
>
> **Constraint Statement**: This file only covers **motion logic and expression style**,
> **does not introduce any specific brand color values**.
> Color decisions follow §1.a Core Asset Protocol (extracted from brand spec) or "Design Direction Advisor"
> (20 philosophies and their respective color schemes). This reference discusses "**HOW TO MOVE**", not "**WHAT COLOR**".

---

## §0 · Who Are You · Identity and Taste

> Before reading any technical rules below, read this section first. Rules **emerge from identity** —
> not the other way around.

### §0.1 Identity Anchor

**You are a motion designer who has studied Anthropic / Apple / Pentagram / Field.io motion archives.**

When doing animation, you're not just tweaking CSS transitions — you're using digital elements to **simulate a physical world**,
making the viewer's subconscious believe "these are objects with weight, inertia, and overflow potential."

You don't do PowerPoint-style animation. You don't do "fade in fade out" animation. Your animation **makes people believe the screen
is a space they can reach into.**

### §0.2 Core Beliefs (3 Principles)

1. **Animation is physics, not animation curves**
   `linear` is digital, `expoOut` is object. You believe pixels on screen deserve to be treated as "objects."
   Every easing choice is answering the physical question: "How heavy is this element? What's the friction coefficient?"

2. **Time allocation matters more than curve shape**
   Slow-Fast-Boom-Stop is your breath. **Uniform rhythm animation is technical demo, rhythmic animation is narrative.**
   Slowing down at the right moment — is more important than using the right easing at the wrong moment.

3. **Respecting the audience is harder than showing off**
   Pausing 0.5 seconds before key results is **technique**, not compromise. **Giving the human brain reaction time is the animator's highest virtue.**
   AI defaults to animation without pauses, maximum information density — that's amateur. You need restraint.

### §0.3 Taste Standards · What is Beauty

Your judgment criteria for "good" vs "great" are as follows. Each has **identification method** — when you see a candidate animation,
use these questions to judge if it meets standards, rather than mechanically checking against 14 rules.

| Beauty Dimension | Identification Method (Audience Reaction) |
|---|---|
| **Physical Weight** | When animation ends, element "**lands**" firmly — not "**stops**" there. Audience subconscious feels "this has weight" |
| **Audience Respect** | There's a perceptible pause (≥300ms) before key info appears — audience has time to "**see**" before continuing |
| **Negative Space** | Ending is abrupt stop + hold, not fade to black. Final frame is clear, decisive, has finality |
| **Restraint** | Entire piece has only one "120% exquisite" moment, rest 80% is just right — **showing off everywhere is cheap signal** |
| **Hand Feel** | Arcs (not straight lines), irregular (not mechanical setInterval rhythm), breathing quality |
| **Respect** | Show the tweak process, show bug fixes — **don't hide work, don't give "magic"**. AI is collaborator not magician |

### §0.4 Self-Check · Audience First Reaction Method

After finishing an animation, **what's the audience's first reaction?** — this is your only metric to optimize.

| Audience Reaction | Rating | Diagnosis |
|---|---|---|
| "Looks pretty smooth" | good | Passable but unremarkable, you're doing PowerPoint |
| "This animation is really smooth" | good+ | Technique is right, but not stunning |
| "This thing really looks like it **floated up from the desktop**" | great | You touched physical weight sensation |
| "This doesn't look like AI did it" | great+ | You reached Anthropic's threshold |
| "I want to **screenshot** and share this" | great++ | You achieved active audience sharing |

**The difference between great and good is not technical correctness, but taste judgment**. Technical correctness + taste right = great.
Technical correctness + taste empty = good. Technical error = not entry-level.

### §0.5 Relationship Between Identity and Rules

The technical rules in §1-§8 below are **execution methods** for this identity in specific scenarios — not independent rule checklists.

- When encountering scenarios not covered by rules → return to §0, use **identity** to judge, don't guess
- When conflicts arise between rules → return to §0, use **taste standards** to judge which is more important
- When wanting to break a rule → first answer: "Which beauty in §0.3 does this align with?" If you can answer, break it; if not, don't

Good. Continue reading.

---

## Overview · Animation is Three-Layer Physics Unfolding

Most AI-generated animations have cheap feel because — **they behave like "digits" not "objects"**.
Real-world objects have mass, inertia, elasticity, overflow potential. The "premium feel" source of Anthropic's three films
lies in giving digital elements a set of **physical world motion rules**.

This rule system has 3 layers:

1. **Narrative Rhythm Layer**: Slow-Fast-Boom-Stop time allocation
2. **Motion Curve Layer**: Expo Out / Overshoot / Spring, reject linear
3. **Expression Language Layer**: Show process, mouse arcs, Logo morph convergence

---

## 1. Narrative Rhythm · Slow-Fast-Boom-Stop 5-Stage Structure

All three Anthropic films follow this structure without exception:

| Stage | Percentage | Rhythm | Role |
|---|---|---|---|
| **S1 Trigger** | ~15% | Slow | Give human reaction time, establish realism |
| **S2 Generate** | ~15% | Medium | Visual wow moment appears |
| **S3 Process** | ~40% | Fast | Show controllability/density/details |
| **S4 Burst** | ~20% | Boom | Camera pull back/3D pop-out/multi-panel emergence |
| **S5 Land** | ~10% | Static | Brand Logo + abrupt stop |

**Specific Duration Mapping** (15-second animation as example):
S1 Trigger 2s · S2 Generate 2s · S3 Process 6s · S4 Burst 3s · S5 Land 2s

**Prohibited Actions**:
- ❌ Uniform rhythm (same information density every second) — audience fatigue
- ❌ Continuous high density — no peaks, no memory points
- ❌ Fade out ending (fade out to transparent) — should **abruptly stop**

**Self-Check**: Use paper to draw 5 thumbnails, each representing the climax frame of one stage. If 5 frames are not very different,
rhythm wasn't achieved.

---

## 2. Easing Philosophy · Reject Linear, Embrace Physics

All motion effects in Anthropic's three films use Bezier curves with "damping feel". Default cubic easeOut
(`1-(1-t)³`) **is not sharp enough** — start not fast enough, stop not stable enough.

### Three Core Easings (built into animations.jsx)

```js
// 1. Expo Out · Quick start slow brake (most common, default main easing)
// Corresponds to CSS: cubic-bezier(0.16, 1, 0.3, 1)
Easing.expoOut(t) // = t === 1 ? 1 : 1 - Math.pow(2, -10 * t)

// 2. Overshoot · Elastic toggle/button pop-up
// Corresponds to CSS: cubic-bezier(0.34, 1.56, 0.64, 1)
Easing.overshoot(t)

// 3. Spring Physics · Geometry return to position, natural landing
Easing.spring(t)
```

### Usage Mapping

| Scene | Which Easing to Use |
|---|---|
| Card rise-in / panel entry / Terminal fade / focus overlay | **`expoOut`** (main easing, most common) |
| Toggle switch / button pop / emphasis interaction | `overshoot` |
| Preview geometry return / physical landing / UI element shake-bounce | `spring` |
| Continuous motion (like mouse trajectory interpolation) | `easeInOut` (maintain symmetry) |

### Counter-Intuitive Insight

Most product promo animations are **too fast too hard**. `linear` makes digital elements like machines, `easeOut` is baseline,
`expoOut` is the technical root of "premium feel" — it gives digital elements a **physical world weight sensation**.

---

## 3. Motion Language · 8 Common Principles

### 3.1 Background Not Pure Black or Pure White

None of Anthropic's three films use `#FFFFFF` or `#000000` as main background. **Neutral colors with temperature**
(either warm or cool) have "paper / canvas / desktop" materiality, reducing machine feel.

**Specific color value decisions** follow §1.a Core Asset Protocol (extracted from brand spec) or "Design Direction Advisor"
(20 philosophies and their respective background schemes). This reference gives no specific color values — that's **brand decision**, not motion rule.

### 3.2 Easing Absolutely Not Linear

See §2.

### 3.3 Slow-Fast-Boom-Stop Narrative

See §1.

### 3.4 Show "Process" Not "Magic Result"

- Claude Design shows tweaking parameters, dragging sliders (not one-click perfect result generation)
- Claude Code shows code errors + AI fixes (not success on first try)
- Claude for Word shows Redline red-delete green-add modification process (not directly giving final draft)

**Common Subtext**: Product is **collaborator, pair engineer, senior editor** — not one-click magician.
This precisely targets professional users' pain points about "controllability" and "authenticity".

**Anti-AI Slop**: AI defaults to "magic one-click success" animation (one-click generate → perfect result),
this is universal common denominator. **Do the opposite** — show process, show tweak, show bug and fix —
is the source of brand recognition.

### 3.5 Mouse Trajectory Hand-Drawn (Arc + Perlin Noise)

Real human mouse motion is not straight line, it's "start accelerate → arc → decelerate correction → click".
AI direct linear interpolated mouse trajectory **has subconscious rejection feel**.

```js
// Quadratic Bezier curve interpolation (start → control point → end)
function bezierQuadratic(p0, p1, p2, t) {
  const x = (1-t)*(1-t)*p0[0] + 2*(1-t)*t*p1[0] + t*t*p2[0];
  const y = (1-t)*(1-t)*p0[1] + 2*(1-t)*t*p1[1] + t*t*p2[1];
  return [x, y];
}

// Path: start → deviated midpoint → end (make arc)
const path = [[100, 100], [targetX - 200, targetY + 80], [targetX, targetY]];

// Then overlay very small Perlin Noise (±2px) to create "hand shake"
const jitterX = (simpleNoise(t * 10) - 0.5) * 4;
const jitterY = (simpleNoise(t * 10 + 100) - 0.5) * 4;
```

### 3.6 Logo "Morph Convergence" (Morph)

Logo appearance in all three Anthropic films **is not simple fade-in**, but **morphed from previous visual element**.

**Common Pattern**: In last 1-2 seconds do Morph / Rotate / Converge, making entire narrative "collapse" at brand point.

**Low-Cost Implementation** (without real morph):
Make previous visual element "collapse" into a color block (scale → 0.1, translate to center),
color block then "expand" to unfold as wordmark. Transition uses 150ms fast cut + motion blur
(`filter: blur(6px)` → `0`).

```js
<Sprite start={13} end={14}>
  {/* Collapse: previous element scale 0.1, opacity maintain, filter blur increase */}
  const scale = interpolate(t, [0, 0.5], [1, 0.1], Easing.expoOut);
  const blur = interpolate(t, [0, 0.5], [0, 6]);
</Sprite>
<Sprite start={13.5} end={15}>
  {/* Expand: Logo from color block center scale 0.1 → 1, blur 6 → 0 */}
  const scale = interpolate(t, [0, 0.6], [0.1, 1], Easing.overshoot);
  const blur = interpolate(t, [0, 0.6], [6, 0]);
</Sprite>
```

### 3.7 Serif + Sans-Serif Dual Font

- **Brand / Narration**: Serif (has "academic feel / publication feel / taste")
- **UI / Code / Data**: Sans-serif + Monospace

**Single font is wrong**. Serif gives "taste", sans-serif gives "function".

Specific font selection follows brand spec (brand-spec.md's Display / Body / Mono three stacks) or design direction
advisor's 20 philosophies. This reference gives no specific font — that's **brand decision**.

### 3.8 Focus Switch = Background Dim + Foreground Sharpen + Flash Guide

Focus switching is **not just** reducing opacity. Complete recipe is:

```js
// Non-focus element filter combination
tile.style.filter = `
  brightness(${1 - 0.5 * focusIntensity})
  saturate(${1 - 0.3 * focusIntensity})
  blur(${focusIntensity * 4}px)        // ← Key: add blur to really "step back"
`;
tile.style.opacity = 0.4 + 0.6 * (1 - focusIntensity);

// After focus completion, do 150ms Flash highlight at focus position to guide gaze return
focusOverlay.animate([
  { background: 'rgba(255,255,255,0.3)' },
  { background: 'rgba(255,255,255,0)' }
], { duration: 150, easing: 'ease-out' });
```

**Why blur is necessary**: With only opacity + brightness, out-of-focus elements are still "sharp",
visually no "recede to background" effect. blur(4-8px) makes non-focus really recede one depth layer.

---

## 4. Specific Motion Techniques (Directly Copiable Code Snippets)

### 4.1 FLIP / Shared Element Transition

Button "expand" into input box, **NOT** button disappear + new panel appear. Core is **same DOM element**
transitioning between two states, not two elements cross-fading.

```jsx
// Use Framer Motion layoutId
<motion.div layoutId="design-button">Design</motion.div>
// ↓ After click, same layoutId
<motion.div layoutId="design-button">
  <input placeholder="Describe your design..." />
</motion.div>
```

Native implementation reference https://aerotwist.com/blog/flip-your-animations/

### 4.2 "Breathing" Expansion (width→height)

Panel expansion **NOT simultaneously pulling width and height**, but:
- First 40% time: only pull width (maintain height small)
- Last 60% time: width maintain, stretch height

This simulates physical world "first expand, then fill" feeling.

```js
const widthT = interpolate(t, [0, 0.4], [0, 1], Easing.expoOut);
const heightT = interpolate(t, [0.3, 1], [0, 1], Easing.expoOut);
style.width = `${widthT * targetW}px`;
style.height = `${heightT * targetH}px`;
```

### 4.3 Staggered Fade-up (30ms stagger)

Table rows, card columns, list items on entry, **each element delays 30ms**, `translateY` returns from 10px to 0.

```js
rows.forEach((row, i) => {
  const localT = Math.max(0, t - i * 0.03);  // 30ms stagger
  row.style.opacity = interpolate(localT, [0, 0.3], [0, 1], Easing.expoOut);
  row.style.transform = `translateY(${
    interpolate(localT, [0, 0.3], [10, 0], Easing.expoOut)
  }px)`;
});
```

### 4.4 Non-linear Breathing · Hover 0.5s Before Key Result

Machine execution is fast and coherent, but **hover 0.5 seconds before key result appears**,
giving audience brain reaction time.

```jsx
// Typical scene: AI generation complete → hover 0.5s → result appears
<Sprite start={8} end={8.5}>
  {/* 0.5s pause — nothing moves, let audience stare at loading state */}
  <LoadingState />
</Sprite>
<Sprite start={8.5} end={10}>
  <ResultAppear />
</Sprite>
```

**Anti-example**: AI generation complete immediately seamless cut to result — audience has no reaction time, information loss.

### 4.5 Chunk Reveal · Simulate Token Streaming

AI generating text **DON'T use `setInterval` single character pop** (like old movie subtitles), use **chunk reveal**
— 2-5 characters appear at once, irregular interval, simulating real token streaming output.

```js
// Split by chunk not character
const chunks = text.split(/(\s+|,\s*|\.\s*|;\s*)/);  // Cut by word + punctuation
let i = 0;
function reveal() {
  if (i >= chunks.length) return;
  element.textContent += chunks[i++];
  const delay = 40 + Math.random() * 80;  // Irregular 40-120ms
  setTimeout(reveal, delay);
}
reveal();
```

### 4.6 Anticipation → Action → Follow-through

3 principles from Disney 12 principles. Anthropic uses very explicitly:

- **Anticipation**: Small reverse action before action starts (button slightly shrinks then pops)
- **Action**: Main action itself
- **Follow-through**: Aftermath after action ends (card slight bounce after landing)

```js
// Complete three-stage card entry
const anticip = interpolate(t, [0, 0.2], [1, 0.95], Easing.easeIn);     // Anticipation
const action  = interpolate(t, [0.2, 0.7], [0.95, 1.05], Easing.expoOut); // Action
const settle  = interpolate(t, [0.7, 1], [1.05, 1], Easing.spring);       // Settle
// Final scale = product of three stages or apply separately
```

**Anti-example**: Animation with only Action no Anticipation + Follow-through, like "PowerPoint animation".

### 4.7 3D Perspective + translateZ Layering

Want "tilted 3D + floating card" temperament, add perspective to container, give individual elements different translateZ:

```css
.stage-wrap {
  perspective: 2400px;
  perspective-origin: 50% 30%;  /* Gaze slightly overlook */
}
.card-grid {
  transform-style: preserve-3d;
  transform: rotateX(8deg) rotateY(-4deg);  /* Golden ratio */
}
.card:nth-child(3n) { transform: translateZ(30px); }
.card:nth-child(5n) { transform: translateZ(-20px); }
.card:nth-child(7n) { transform: translateZ(60px); }
```

**Why rotateX 8° / rotateY -4° is golden ratio**:
- Greater than 10° → Element distortion too strong, looks like "falling down"
- Less than 5° → Like "shear" not "perspective"
- 8° × -4° asymmetric ratio simulates natural angle of "camera at desktop top-left corner overlooking"

### 4.8 Diagonal Pan · Move XY Simultaneously

Camera motion is not pure up-down or pure left-right, but **simultaneously move XY** simulating diagonal movement:

```js
const panX = Math.sin(flowT * 0.22) * 40;
const panY = Math.sin(flowT * 0.35) * 30;
stage.style.transform = `
  translate(-50%, -50%)
  rotateX(8deg) rotateY(-4deg)
  translate3d(${panX}px, ${panY}px, 0)
`;
```

**Key**: X and Y have different frequencies (0.22 vs 0.35), avoid Lissajous loop regularization.

---

## 5. Scene Recipes (Three Narrative Templates)

Three videos in reference materials correspond to three product personalities. **Choose one closest to your product**, don't mix.

### Recipe A · Apple Keynote Dramatic Style (Claude Design Type)

**Suitable for**: Major version releases, hero animations, visual wow priority
**Rhythm**: Slow-Fast-Boom-Stop strong arc
**Easing**: Full `expoOut` + small amount of `overshoot`
**SFX Density**: High (~0.4/s), SFX pitch tuned to BGM scale
**BGM**: IDM / Minimal tech electronic, calm+precise
**Convergence**: Camera rapid pull back → drop → Logo morph → ethereal single tone → abrupt stop

### Recipe B · One-Shot Tool Style (Claude Code Type)

**Suitable for**: Developer tools, productivity apps, flow scenarios
**Rhythm**: Continuous stable flow, no obvious peaks
**Easing**: `spring` physics + `expoOut`
**SFX Density**: **0** (Pure BGM-driven editing rhythm)
**BGM**: Lo-fi Hip-hop / Boom-bap, 85-90 BPM
**Core Technique**: Key UI actions step on BGM kick/snare transients — "**music rhythm = interaction sound effect**"

### Recipe C · Office Efficiency Narrative Style (Claude for Word Type)

**Suitable for**: Enterprise software, document/spreadsheet/calendar type, professional feel priority
**Rhythm**: Multi-scene hard cut + Dolly In/Out
**Easing**: `overshoot` (toggle) + `expoOut` (panel)
**SFX Density**: Medium (~0.3/s), UI click primarily
**BGM**: Jazzy Instrumental, minor key, BPM 90-95
**Core Highlight**: One scene must have "full film highlight" — 3D pop-out / break away from plane and float up

---

## 6. Anti-Examples · Doing This Is AI Slop

| Anti-pattern | Why Wrong | Correct Approach |
|---|---|---|
| `transition: all 0.3s ease` | `ease` is linear's relative, all elements same speed | Use `expoOut` + element-wise stagger |
| All entry `opacity 0→1` | No motion direction sense | Pair with `translateY 10→0` + Anticipation |
| Logo fade-in | No narrative convergence feel | Morph / Converge / collapse-expand |
| Mouse straight line movement | Subconscious machine feel | Bezier arc + Perlin Noise |
| Typing single character pop (setInterval) | Like old movie subtitles | Chunk Reveal, random interval |
| Key result no hover | Audience no reaction time | Hover 0.5s before result |
| Focus switch only change opacity | Non-focus elements still sharp | opacity + brightness + **blur** |
| Pure black / pure white background | Cyber feel / reflection fatigue | Neutral color with temperature (follow brand spec) |
| All animations same speed | No rhythm | Slow-Fast-Boom-Stop |
| Fade out ending | No decisiveness | Abrupt stop (hold last frame) |

---

## 7. Self-Check List (60 Seconds Before Animation Delivery)

- [ ] Narrative structure is Slow-Fast-Boom-Stop, not uniform rhythm?
- [ ] Default easing is `expoOut`, not `easeOut` or `linear`?
- [ ] Toggle / button pop used `overshoot`?
- [ ] Card / list entry has 30ms stagger?
- [ ] Key result has 0.5s hover before?
- [ ] Typing uses Chunk Reveal, not setInterval single character?
- [ ] Focus switch added blur (not just opacity)?
- [ ] Logo is morph convergence (Morph), not fade-in?
- [ ] Background not pure black / pure white (with temperature)?
- [ ] Text has serif + sans-serif hierarchy?
- [ ] Ending is abrupt stop, not fade out?
- [ ] (If mouse present) mouse trajectory is arc, not straight line?
- [ ] SFX density matches product personality (see recipes A/B/C)?
- [ ] BGM and SFX have 6-8dB loudness difference? (see `audio-design-rules.md`)

---

## 8. Relationship With Other References

| Reference | Positioning | Relationship |
|---|---|---|
| `animation-pitfalls.md` | Technical pitfall avoidance (16 items) | "**DON'T DO THIS**" · Opposite of this file |
| `animations.md` | Stage/Sprite engine usage | Animation **how to write** basics |
| `audio-design-rules.md` | Dual-track audio rules | Animation **with audio** rules |
| `sfx-library.md` | 37 SFX inventory | Sound effect **asset library** |
| `apple-gallery-showcase.md` | Apple gallery showcase style | Specific motion style topic |
| **This File** | Forward motion design grammar | "**DO THIS**" |

**Call Order**:
1. First read SKILL.md workflow Step 3's position four questions (decide narrative role and visual temperature)
2. After selecting direction, read this file to determine **motion language** (recipes A/B/C)
3. When writing code, reference `animations.md` and `animation-pitfalls.md`
4. When exporting video, follow `audio-design-rules.md` + `sfx-library.md`

---

## Appendix · This File Material Sources

- Anthropic official animation breakdown: `reference-animation/BEST-PRACTICES.md` in Huashu project directory
- Anthropic audio breakdown: `AUDIO-BEST-PRACTICES.md` in same directory
- 3 reference videos: `ref-{1,2,3}.mp4` + corresponding `gemini-ref-*.md` / `audio-ref-*.md`
- **Strict Filtering**: This reference does not include any specific brand color values, font names, product names.
  Color/font decisions follow §1.a Core Asset Protocol or 20 design philosophies.
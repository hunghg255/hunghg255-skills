# Design Critique In-Depth Guide

> Detailed reference for Phase 7. Provides scoring criteria, scenario-specific focus areas, and a checklist of common issues.

---

## Scoring Criteria Explained

### 1. Philosophy Alignment

| Score | Criteria |
|------|----------|
| 9-10 | Design perfectly embodies the core spirit of the selected philosophy, every detail has a philosophical basis |
| 7-8 | Overall direction is correct, core characteristics are in place, individual details deviate |
| 5-6 | Intention is visible, but other stylistic elements got mixed in during execution, not pure enough |
| 3-4 | Only surface-level imitation, without understanding the philosophical core |
| 1-2 | Basically unrelated to the selected philosophy |

**Critique Points**:
- Does it use the signature techniques of that designer/institution?
- Do colors, typography, and layout align with that philosophy system?
- Are there "self-contradictory" elements? (e.g., choosing Kenya Hara but stuffing it full of content)

### 2. Visual Hierarchy

| Score | Criteria |
|------|----------|
| 9-10 | User's gaze naturally flows along the designer's intent, zero friction in information acquisition |
| 7-8 | Primary-secondary relationships are clear, occasional 1-2 places with ambiguous hierarchy |
| 5-6 | Can distinguish headings from body text, but intermediate levels are chaotic |
| 3-4 | Information is flat, no clear visual entry point |
| 1-2 | Chaotic, users don't know where to look first |

**Critique Points**:
- Is the font size contrast between headings and body text sufficient? (at least 2.5x)
- Do color/weight/size establish 3-4 clear hierarchy levels?
- Is whitespace guiding the line of sight?
- "Squint Test": When you squint, is the hierarchy still clear?

### 3. Craft Quality

| Score | Criteria |
|------|----------|
| 9-10 | Pixel-level precision, no flaws in alignment, spacing, or color |
| 7-8 | Overall refined, 1-2 minor alignment/spacing issues |
| 5-6 | Basically aligned, but spacing is inconsistent, color use is not systematic |
| 3-4 | Obvious alignment errors, chaotic spacing, too many colors |
| 1-2 | Rough, looks like a draft |

**Critique Points**:
- Is a unified spacing system used (e.g., 8pt grid)?
- Is spacing consistent for similar elements?
- Is the color count controlled? (usually no more than 3-4 types)
- Is the font family unified? (usually no more than 2 types)
- Is edge alignment precise?

### 4. Functionality

| Score | Criteria |
|------|----------|
| 9-10 | Every design element serves the goal, zero redundancy |
| 7-8 | Clear functional orientation, a few decorative elements that could be removed |
| 5-6 | Basically usable, but obvious decorative elements distract attention |
| 3-4 | Form over function, users need to work to find information |
| 1-2 | Completely drowned by decoration, lost the ability to convey information |

**Critique Points**:
- If you remove any element, would the design get worse? (If not, it should be removed)
- Are CTAs/key information in the most prominent positions?
- Are there elements that were "added just because they look good"?
- Does information density match the medium? (PPT shouldn't be too dense, PDF can be denser)

### 5. Originality

| Score | Criteria |
|------|----------|
| 9-10 | Refreshing, found unique expression within that philosophy framework |
| 7-8 | Has its own ideas, not simple template application |
| 5-6 | Conventional, looks like a template |
| 3-4 | Heavily used clichés (e.g., gradient spheres representing AI) |
| 1-2 | Completely template or asset pieced together |

**Critique Points**:
- Does it avoid common clichés? (see "Common Issues Checklist" below)
- Is there personal expression while following the design philosophy?
- Are there "unexpected but reasonable" design decisions?

---

## Scenario-Specific Critique Focus

Different output types have different critique priorities:

| Scenario | Most Important Dimension | Second Important | Can Relax |
|----------|------------------------|------------------|-----------|
| WeChat Official Account cover/image | Originality, Visual Hierarchy | Philosophy Alignment | Functionality (single image doesn't involve interaction) |
| Infographic | Functionality, Visual Hierarchy | Craft Quality | Originality (accuracy first) |
| PPT/Keynote | Visual Hierarchy, Functionality | Craft Quality | Originality (clarity first) |
| PDF/White Paper | Craft Quality, Functionality | Visual Hierarchy | Originality (professional first) |
| Landing Page/Official Site | Functionality, Visual Hierarchy | Originality | — (comprehensive requirements) |
| App UI | Functionality, Craft Quality | Visual Hierarchy | Philosophy Alignment (usability first) |
| Xiaohongshu Image | Originality, Visual Hierarchy | Philosophy Alignment | Craft Quality (atmosphere first) |

---

## Top 10 Common Design Issues

### 1. AI Tech Cliché
**Problem**: Gradient spheres, digital rain, blue circuit boards, robot faces
**Why It's a Problem**: Users are already tired of these visuals, can't distinguish you from others
**Fix**: Replace literal symbols with abstract metaphors (e.g., use the metaphor of "dialogue" rather than chat bubble icons)

### 2. Insufficient Font Size Hierarchy
**Problem**: Gap between headings and body text is too small (<2.5x)
**Why It's a Problem**: Users can't quickly locate key information
**Fix**: Headings should be at least 3x body text (e.g., body 16px → heading 48-64px)

### 3. Too Many Colors
**Problem**: Using more than 5 colors, no primary/secondary distinction
**Why It's a Problem**: Visual chaos, weak brand sense
**Fix**: Limit to 1 primary color + 1 secondary color + 1 accent color + grayscale

### 4. Inconsistent Spacing
**Problem**: Element spacing is arbitrary, no system
**Why It's a Problem**: Looks unprofessional, chaotic visual rhythm
**Fix**: Establish an 8pt grid system (spacing only uses 8/16/24/32/48/64px)

### 5. Insufficient Whitespace
**Problem**: All space is filled with content
**Why It's a Problem**: Crowded information causes reading fatigue, actually reduces information transmission efficiency
**Fix**: Whitespace should be at least 40% of total area (minimalist style 60%+)

### 6. Too Many Fonts
**Problem**: Using more than 3 fonts
**Why It's a Problem**: Visual noise, weakens unity
**Fix**: Maximum 2 fonts (1 for headings + 1 for body), use font weight and size to create variation

### 7. Inconsistent Alignment
**Problem**: Some left-aligned, some centered, some right-aligned
**Why It's a Problem**: Destroys visual order
**Fix**: Choose one alignment method (recommend left alignment), unify globally

### 8. Decoration Over Content
**Problem**: Background patterns/gradients/shadows steal the show from main content
**Why It's a Problem**: Putting the cart before the horse, users come for information not decoration
**Fix**: "If you remove this decoration, would the design get worse?" If not, remove it

### 9. Cyber Neon Abuse
**Problem**: Dark blue background (#0D1117) + neon color glow effects
**Why It's a Problem**: Default aesthetic taboo (this skill's taste baseline), and has become one of the biggest clichés—users can override according to their own brand
**Fix**: Choose a more distinctive color scheme (refer to the color systems of 20 styles)

### 10. Information Density Mismatch with Medium
**Problem**: A full page of text in PPT / cover image stuffed with 10 elements
**Why It's a Problem**: Different media have different optimal information densities
**Fix**:
- PPT: One core point per page
- Cover image: One visual focal point
- Infographic: Layered display
- PDF: Can be denser, but needs clear navigation

---

## Critique Output Template

```
## Design Critique Report

**Overall Score**: X.X/10 [Excellent(8+)/Good(6-7.9)/Needs Improvement(4-5.9)/Unqualified(<4)]

**Breakdown**:
- Philosophy Alignment: X/10 [one-sentence explanation]
- Visual Hierarchy: X/10 [one-sentence explanation]
- Craft Quality: X/10 [one-sentence explanation]
- Functionality: X/10 [one-sentence explanation]
- Originality: X/10 [one-sentence explanation]

### Strengths (Keep)
- [Specifically point out what's done well, describe in design language]

### Issues (Fix)
[Sorted by severity]

**1. [Issue Name]** — ⚠️Critical / ⚡Important / 💡Optimization
- Current: [Describe current state]
- Problem: [Why this is a problem]
- Fix: [Specific action, including values]

### Quick Fixes Checklist (Quick Wins)
If you only have 5 minutes, prioritize these 3 things:
- [ ] [Most impactful fix]
- [ ] [Second most important fix]
- [ ] [Third most important fix]
```

---

**Version**: v1.0
**Date Updated**: 2026-02-13

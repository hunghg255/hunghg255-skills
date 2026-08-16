---
name: japanese-pop-tech-logo
description: Create original Japanese pop-tech wordmark logos with chunky playful lettering, kana accents, coding symbols, sticker outlines, flat brand colors, and offset shadows. Use when users ask to design, generate, remake, explore, or prompt a Japanese-style logo, kawaii tech logo, anime-adjacent developer logo, programming-language logo, software/tool wordmark, Japanese typography badge, pop sticker logo, or a logo matching the visual language in the bundled reference board. Supports prompt-only concepts, image generation, variants, transparent PNG delivery, and critique of an existing logo.
---

# Japanese Pop-Tech Logo

IRON LAW: CREATE AN ORIGINAL, READABLE WORDMARK; NEVER TRACE, RECONSTRUCT, OR CONFUSABLY IMITATE A REFERENCE LOGO OR TRADEMARK.

Use the bundled board only for visual grammar: lettering energy, hierarchy, outline, shadow, palette discipline, and icon integration. Do not reuse its exact word shapes, icons, kana, taglines, or compositions.

## Options

Interpret natural-language requests first; flags are optional.

| Option | Values | Default |
|---|---|---|
| `<name>` | Exact primary wordmark | Required for generation |
| `--kana` | `auto`, `none`, or exact text | `auto` |
| `--tagline` | Exact short supporting line | none |
| `--palette` | `auto`, `mono`, or supplied colors | `auto` |
| `--layout` | `compact`, `wide`, `stacked` | `wide` |
| `--variants` | `1`–`4` | `1` |
| `--transparent` | Request final alpha PNG | off |
| `--prompt-only` | Return production prompt; do not generate | off |
| `--critique` | Analyze an existing logo only | off |

## Workflow

Copy and complete this checklist.

- [ ] Step 1: Lock the brief ⚠️ REQUIRED
  - [ ] Record the primary name verbatim, including capitalization and punctuation.
  - [ ] Identify meaning, audience, personality, palette constraints, icon idea, and intended use.
  - [ ] Treat supplied brand assets as constraints, not permission to copy third-party marks.
- [ ] Step 2: Select a visual route
  - [ ] Read `references/style-system.md`.
  - [ ] Choose one composition archetype and one personality axis.
  - [ ] Inspect `assets/style-reference-board.jpg` when visual grounding is useful.
- [ ] Step 3: Build the text hierarchy ⚠️ REQUIRED
  - [ ] Keep the exact Latin wordmark dominant and readable at thumbnail size.
  - [ ] Use kana only as a small phonetic/rhythmic accent; never invent a misleading translation.
  - [ ] Limit supporting copy to one short tagline and at most three micro-labels.
- [ ] Step 4: Check originality ⛔ BLOCKING
  - [ ] Ask: Would a viewer mistake this for an existing company, product, or repository logo?
  - [ ] Ask: Did the concept inherit a distinctive mascot, proprietary symbol, or exact letter arrangement?
  - [ ] If yes, change the silhouette, icon metaphor, letter construction, and layout before continuing.
- [ ] Step 5: Compose the production prompt
  - [ ] Read `references/prompt-recipes.md`.
  - [ ] Quote every required text string and explicitly forbid extra text.
  - [ ] Describe the style through attributes, not artist names or brand names.
- [ ] Step 6: Generate or return prompt
  - [ ] If `--prompt-only`, return the prompt plus a one-sentence concept rationale.
  - [ ] Otherwise use the built-in image generation tool in `logo-brand` mode.
  - [ ] For each distinct variant, make a separate generation call with a distinct composition idea.
  - [ ] Use `assets/style-reference-board.jpg` as a style reference when supported; state that it is style-only.
  - [ ] If the user already requested an image, proceed without asking for redundant confirmation.
- [ ] Step 7: Inspect and iterate ⚠️ REQUIRED
  - [ ] Verify exact primary spelling before judging decoration.
  - [ ] Check legibility at small size, silhouette, hierarchy, palette count, edge quality, and accidental extra text.
  - [ ] Make only one targeted correction per iteration.
- [ ] Step 8: Deliver
  - [ ] For project-bound output, save the selected image in the workspace using a descriptive versioned filename.
  - [ ] For `--transparent`, follow the installed image-generation skill's built-in-first chroma-key workflow and validate alpha.
  - [ ] Report the saved path and final prompt.

## Decision Rules

- Missing exact primary name is blocking for image generation; ask one concise question.
- For `--kana auto`, use a phonetic rendering only when pronunciation is clear. Otherwise omit kana or ask for pronunciation.
- Prefer one strong visual pun: turn a letter counter, terminal bracket, slash, dot, tail, or crossbar into the icon metaphor.
- Preserve a compact sticker silhouette. Decorative fragments must support the reading path, not orbit randomly.
- Default to 2–4 flat colors plus white keyline and one dark shadow tone.
- Keep the primary name at roughly 65–80% of visual attention; kana/tagline together stay below 25%.
- Use a white or removable flat chroma-key background for clean logo extraction. Do not present the first concept only as a merchandise mockup.

## Critique Mode

When `--critique` is requested, do not modify or generate. Score the supplied logo from 1–5 on:

1. Exact wordmark readability
2. Japanese pop-tech character
3. Original silhouette
4. Icon-letter integration
5. Palette discipline
6. Small-size usability

Return the three highest-impact corrections, in priority order.

## Anti-Patterns

- Thin geometric corporate sans serif with a small icon beside it
- Generic cyberpunk neon, vaporwave gradients, chrome, glow, or photorealistic 3D
- Random Japanese characters used as decoration
- More than two outline layers or a muddy multi-directional shadow
- A loose collage of unrelated icons around ordinary text
- Long taglines, paragraph text, or tiny unreadable code
- Recreating a known tech logo with kana added
- Copying a reference's distinctive mascot, symbol, wording, or exact composition
- Claiming text is correct without visually checking the generated pixels

## Pre-Delivery Checklist

- [ ] Primary name appears exactly once and matches the brief character-for-character.
- [ ] No unintended words, pseudo-letters, watermarks, or duplicated glyphs appear.
- [ ] The design remains recognizable at 128 px wide.
- [ ] The silhouette is compact with clear outer padding and no cropped shadow.
- [ ] Palette uses no more than four main hues, excluding white and the dark shadow.
- [ ] Kana is correct or intentionally omitted.
- [ ] No protected logo, mascot, or proprietary symbol is reproduced.
- [ ] Transparent requests have an alpha channel and transparent corners.

## Technical Inspection

Run the bundled inspector after saving a PNG:

```bash
python3 scripts/inspect_logo.py path/to/logo.png
```

Use its JSON for dimensions, aspect ratio, alpha/transparency, occupied bounds, and dominant colors. Treat this as a technical check; visual review remains mandatory.

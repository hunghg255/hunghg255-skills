# Prompt Recipes

## Production Prompt Schema

Use only relevant lines. Quote all required text.

```text
Use case: logo-brand
Asset type: original Japanese pop-tech wordmark logo
Primary request: Design an original logo for "<EXACT NAME>" that communicates <meaning/personality>.
Style/medium: crisp vector-like raster artwork; chunky hand-shaped Latin display lettering; playful Japanese pop typography; flat colors; compact sticker silhouette.
Letter construction: <rounded/angular> irregular letters with controlled baseline shifts; one integrated visual pun using <icon metaphor>.
Japanese layer: render "<EXACT KANA>" as small secondary furigana-style text <placement>; omit if not supplied or linguistically certain.
Tech layer: integrate <one or two symbols> into the letterforms, not as a loose icon collage.
Composition/framing: <compact/wide/stacked> centered mark; complete silhouette visible; generous outer padding; no mockup.
Color palette: <2–4 exact or descriptive flat colors>; dominant <color>; accent <color>.
Depth: clean white keyline and one consistent dark gray offset extrusion down-right.
Text (verbatim): primary "<EXACT NAME>"; secondary "<EXACT KANA OR TAGLINE>".
Constraints: primary text appears exactly once; spelling must be character-perfect; strong thumbnail readability; original design; simple scalable silhouette; flat solid background suitable for extraction.
Avoid: extra words; pseudo-Japanese glyphs; copied brand symbols; thin corporate typography; random floating icons; photorealism; 3D mockup; chrome; neon glow; busy gradients; watermark; cropped outline or shadow.
Reference image role: style grammar only—borrow the energy, hierarchy, outline, shadow, and icon-letter integration; do not copy any exact logo, mascot, text, or composition.
```

## Route A: Friendly framework

```text
Primary request: Design an original wordmark for "MORI" representing a friendly developer toolkit.
Letter construction: rounded chunky letters with compact kerning; transform the O counter into a small original terminal cursor motif.
Japanese layer: render "モリ" once, small, above the middle letters.
Tech layer: one `</>` accent tucked into the underline.
Composition/framing: wide developer badge, centered, strong sticker silhouette.
Color palette: forest green dominant, mint secondary, warm yellow accent, near-black shadow.
```

## Route B: Monochrome error badge

```text
Primary request: Design an original stacked exclamation wordmark for "CACHE MISS".
Letter construction: heavy irregular black letters with one oversized question mark and a compact broken-file symbol drawn from original geometry.
Japanese layer: omit kana unless exact text is provided.
Composition/framing: two staggered rows with one angled underline; high-impact monochrome sticker badge.
Color palette: black, white, medium gray, one restrained red accent.
```

## Route C: Cute product logo

```text
Primary request: Design an original compact logo for "PICO" representing a tiny coding companion.
Letter construction: soft bubbly letters, varied height, readable P-I-C-O sequence; make the dot/accent a small original pixel spark.
Japanese layer: render "ピコ" once below the primary name.
Tech layer: integrate one tiny brace pair into the lower contour.
Color palette: sky blue dominant, lilac secondary, coral accent, charcoal shadow.
```

## Iteration Prompts

Correct only spelling:

```text
Change only the primary wordmark text to exactly "<EXACT NAME>". Preserve the composition, palette, letter personality, icons, outline, shadow, and canvas. Remove any extra or malformed glyphs.
```

Improve readability:

```text
Change only the letter spacing and overlapping so "<EXACT NAME>" reads clearly at thumbnail size. Preserve the original silhouette, palette, kana, icon metaphor, outline, and shadow.
```

Reduce clutter:

```text
Remove only nonessential micro-symbols and extra decorative fragments. Keep one integrated icon pun, the exact wordmark, approved kana, palette, outline, and shadow unchanged.
```

## Transparent Output Addendum

Append this when transparent delivery is requested and follow the installed image-generation skill's chroma-key removal workflow:

```text
Place the complete logo on a perfectly flat solid chroma-key background that does not appear anywhere in the logo. No background texture, lighting variation, floor, reflection, cast shadow, or contact shadow. Keep the logo fully separated from the background with crisp antialiased edges and generous padding.
```

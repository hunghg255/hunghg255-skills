# Visual Measurement Guide

## 1. Establish the Coordinate System

Record the image's intrinsic dimensions. Determine the intended CSS viewport from, in order:

1. Figma frame dimensions.
2. Browser or capture metadata supplied by the user.
3. A known viewport or container in the existing application.
4. Stable anchors such as a standard input height, sidebar width, or known font size.
5. Human confirmation.

Use:

```text
scale = image pixels / CSS pixels
css value = measured image pixels / scale
```

Never assume `scale = 1`.

### Downscale warning

Flag the image when all are true:

- intrinsic width is below 900 px;
- it shows a desktop shell or four-column content;
- labels appear below 10 image px or controls below 28 image px.

This usually indicates a downscaled or retina-derived reference.

## 2. Inspect Regions, Not Only the Full Page

Inspect at least:

- page/header shell;
- one representative repeated card;
- the complete repeated row or grid;
- one dense list/table;
- each chart or custom visualization.

Use a crop or zoom where text strokes and icon geometry are visible.

## 3. Build the Ledger

Use this table:

| Region/Element | Property | Image px | Scale | CSS px | Mapping | Confidence |
|---|---:|---:|---:|---:|---|---|
| KPI card | height | 88 | 0.5 | 176 | `min-h-44` | high |
| KPI value | font size | 14 | 0.5 | 28 | `text-[28px]` | medium |

For values obtained from Figma, put `Figma` in the Image px column and use the exact CSS value.

Before delivery, convert every measured range into one implementation target. A range may remain in
the evidence ledger, but the Implementation Contract must contain one value.

## 4. Measure High-Salience Anchors

Prioritize:

1. page and section widths;
2. header alignment and filter placement;
3. card height, padding, radius, and gap;
4. icon box size, fill style, and icon order;
5. heading, label, value, and helper text typography;
6. dividers and repeated-item alignment;
7. chart diameter and center label.

Semantic correctness cannot compensate for wrong anchors.

## 5. Map to the Project

- Use an exact project token when its computed value matches.
- Use a custom utility/value when no exact token exists.
- Record the nearest token for context, but do not silently substitute it.
- Verify third-party component defaults. If an antd control needs a specific height, radius, or
  padding, state the required override explicitly.
- Inspect component source or computed styles for padding, line height, border, shadow, icon size,
  popup placement, and state styles. A named size such as `small` is not a visual specification.

## 6. Capture the Render Environment

Record:

- viewport width and height;
- device pixel ratio;
- browser/engine and browser zoom;
- OS when font rendering matters;
- theme and color scheme;
- locale and number/date formatting;
- exact font files and weights available;
- whether animation and transitions are disabled.

## 7. Define Acceptance Criteria

Specify:

- exact viewport for comparison;
- reference crop or region;
- target dimensions and tolerances;
- allowed text wrapping;
- required order/alignment;
- whether visual diff, overlay, or side-by-side inspection is required.

Recommended tolerance:

- major geometry: +/- 2 CSS px;
- typography and icon sizes: +/- 1 CSS px;
- colors: exact token/custom value where measurable;
- repeated alignment: no cumulative drift across the row.

Treat a global image-diff score as secondary. Large blank regions can hide a badly aligned component;
high-salience anchor checks remain mandatory.

# Fidelity Contract Guide

The Implementation Contract is the short, authoritative handoff consumed by the implementation
model. Supporting sections provide evidence but must not change it.

All bundled resource paths are relative to the directory containing `SKILL.md`. Refer to that
absolute directory as `SKILL_DIR`; never assume the skill is installed under `.agents`, `.claude`,
or `.codex`.

## Required Blocks

### Fidelity Target

Declare tier, numeric target, viewport, browser, DPR, zoom, theme, locale, font status, and animation
state.

### File Operations

List exact `CREATE`, `MODIFY`, and `DO NOT MODIFY` paths.

### DOM Contract

Show exact semantic tags, order, nesting, repeated counts, and conditional branches.

### Style Contract

Use one row per visual element:

| Element | Width | Height | Padding | Gap | Typography | Colors | Border | Radius | Shadow | Overflow |
|---|---:|---:|---|---|---|---|---|---:|---|---|

Use one value per property. Include full CSS shadows and complete border definitions.

### Content Fixture

Include exact strings, numbers, assets, image crop behavior, locale, and formatting. Placeholder
copy cannot validate text wrapping.

### State Contract

Define exact default, hover, focus, active, selected, loading, empty, error, disabled, and responsive
states that apply.

### Prohibited Deviations

List defaults and substitutions that would cause drift, such as changing icons, using library
padding, shrinking fonts to fit, truncating two-line text, or enabling animation before comparison.

### Verification

Specify run and capture instructions. If screenshot automation is unavailable, require a manual
capture at the exact viewport and state that limitation.

Require at least this loop:

1. Render at the contract environment.
2. Capture the target region.
3. Compare with the matching persistent reference crop.
4. Fix geometry first, then typography, then colors/effects.
5. Repeat until every anchor is within tolerance.

## Precision Rules

- Convert every approximation or range into one implementation target.
- Resolve flex versus grid, library versus custom, and token versus custom values.
- Record font family, size, weight, line height, letter spacing, and text transform.
- Record icon name, size, stroke width, fill, and color.
- Record image width, height, radius, `object-fit`, and `object-position`.
- Record overflow, line clamp, white-space, and min/max widths.
- Record z-index and overlap when relevant.

## Handoff Bundle

Store files under `specs/assets/<spec-name>/`:

```text
reference.png
header.png
primary-component.png
repeated-row.png
custom-visualization.png
```

Add a manifest with each crop's source rectangle. Never hand off `/tmp` files.

## Fidelity Tiers

`Screenshot-calibrated / >=95%` accounts for unknown anti-aliasing, compression, and font rendering.

`Figma-exact / 98-100%` requires Figma node values, original assets, exact fonts/effects and
constraints, render-environment parity, and screenshot comparison with iteration.

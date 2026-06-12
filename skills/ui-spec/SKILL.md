---
name: ui-spec
description: Generate implementation-ready UI specifications from screenshots or Figma, calibrated to the intended CSS viewport and mapped to the project's real components, tokens, icons, and styles. Use for "gen spec", "UI spec", "spec from screenshot/Figma", design handoff, design-to-code mapping, or when diagnosing why an implementation does not visually match a reference.
---

IRON LAW 1: CALIBRATE IMAGE SCALE BEFORE READING CSS VALUES. Screenshot pixels are not
automatically CSS pixels. A downscaled desktop screenshot must not produce tiny typography and
spacing.

IRON LAW 2: EVERY SPEC VALUE NEEDS EVIDENCE. Record whether each geometry, typography, color, and
icon value is measured, derived from the calibrated scale, read from Figma, mapped to an exact
project token, or explicitly custom.

IRON LAW 3: EVERY COMPONENT MUST MAP TO REAL CODE OR BE MARKED `MISSING`. Never invent component
names or props.

IRON LAW 4: WHEN A DECISION CAN CHANGE VISUAL FIDELITY OR BEHAVIOR, ASK THE HUMAN. Never silently
choose between plausible scales, components, colors, icons, interactions, or data sources.

IRON LAW 5: THE REFERENCE DESIGN DEFINES THE VISUAL TARGET. Project tokens are preferred only when
they match. If the closest token visibly changes the design, record an exact `CUSTOM` value instead.

IRON LAW 6: OPTIMIZE FOR A WEAKER IMPLEMENTATION MODEL. Put a compact, deterministic
`Implementation Contract` before explanatory material. Critical requirements must not be scattered
through hundreds of lines.

IRON LAW 7: ONE VISUAL DECISION HAS ONE ANSWER. Do not leave alternatives, ranges, recommendations,
or fallbacks in the Implementation Contract. Resolve them before delivery.

IRON LAW 8: DECLARE AN HONEST FIDELITY TIER. Screenshot-calibrated specs target >=95%. Only use a
98-100% target when Figma inspect values, original assets, exact fonts/effects, and the render
environment are available.

Red Flags (return to Step 1 if any appear):
- Desktop multi-column UI appears in an image narrower than 900 px and no scale factor is recorded
- Typography or spacing was chosen by visual impression without a measurement ledger
- A full-page screenshot was analyzed without zooming/cropping important regions
- The spec says "compact", "large", "close", or "similar" without numeric geometry
- The Implementation Contract contains `about`, `approximately`, `may`, `should`, `if possible`,
  `fallback`, multiple options, or numeric ranges
- Exact content fixtures are missing where text wrapping or chart geometry affects layout
- Third-party defaults are used without verified computed values or explicit overrides
- A screenshot-only input claims 100% fidelity
- The handoff references temporary crop paths instead of persistent files under `specs/assets/`
- Spec references components not found during scan
- A custom color/spacing value lacks its measured value and closest token
- "Generic" component names like `Button` without matching the actual import path
- You wrote "probably" or "likely" in a mapping — this means you should ASK instead

## Workflow

### Portable Skill Paths

At skill load time, record the absolute directory containing this `SKILL.md` as `SKILL_DIR`. Resolve
every bundled `scripts/` and `references/` path from `SKILL_DIR`, never from the project CWD and
never from a hardcoded host folder such as `.agents`, `.claude`, or `.codex`.

Conceptual shell setup:

```bash
SKILL_DIR="$(cd "$(dirname "<absolute-path-of-the-loaded-SKILL.md>")" && pwd)"
```

`<absolute-path-of-the-loaded-SKILL.md>` is the actual path already supplied by the runtime when the
skill is selected. Substitute it before running the command; do not execute the placeholder
literally.

Copy this checklist and check off items as you complete them:

```
UI-Spec Progress:

- [ ] Step 1: Parse Input ⛔ BLOCKING
  - [ ] 1.1 Extract image path or Figma URL from `$ARGUMENTS`
  - [ ] 1.2 Validate image exists or Figma connection is active
  - [ ] 1.3 Parse flags: `--quick`, `--scope`, `--output`
- [ ] Step 2: Scan Design System ⚠️ REQUIRED
  - [ ] 2.1 Run `scripts/scan-design-system.sh` to extract components, tokens, styles, icons
  - [ ] 2.2 If scan fails or returns minimal → manual fallback (search src/ for component patterns)
  - [ ] 2.3 Build design system inventory (components map, tokens, icon set)
- [ ] Step 3: Analyze Design Image ⚠️ REQUIRED
  - [ ] 3.1 Read the image and record intrinsic pixel dimensions
  - [ ] 3.2 For Figma URLs → use `mcp__figma-ui-mcp__figma_read` with `get_design_context`
  - [ ] 3.3 Calibrate image pixels to intended CSS pixels; ask if ambiguous
  - [ ] 3.4 Crop or zoom every major region before measuring it
  - [ ] 3.5 Create a measurement ledger for geometry, typography, color, and icons
  - [ ] 3.6 Identify sections, component nesting, hierarchy, states, and interactions
  - [ ] 3.7 Save the source copy and high-salience crops under `specs/assets/<spec-name>/`
- [ ] Step 4: Map Design → Codebase ⚠️ REQUIRED
  - [ ] 4.1 Load `references/component-mapping-guide.md` for mapping methodology
  - [ ] 4.2 Map each visual element to a real component from inventory
  - [ ] 4.3 Map colors to design tokens (or mark as MISSING)
  - [ ] 4.4 Map typography to text styles (or mark as MISSING)
  - [ ] 4.5 Map icons to icon library entries (or mark as MISSING)
  - [ ] 4.6 Map spacing to spacing scale (or mark as CUSTOM)
  - [ ] 4.7 ❓ For any UNSURE items → ask the human immediately (do NOT proceed with a guess)
- [ ] Step 5: Clarify UNSURE Items ⚠️ REQUIRED
  - [ ] 5.1 Collect all ❓ UNSURE items from Step 4
  - [ ] 5.2 Ask the human specific questions using AskUserQuestion (see question templates below)
  - [ ] 5.3 Update mappings based on human answers
  - [ ] 5.4 Repeat until no ❓ UNSURE items remain
- [ ] Step 6: Confirm Mapping ⚠️ REQUIRED (skip if `--quick`)
  - [ ] 6.1 Present mapping summary: matched vs MISSING vs CUSTOM
  - [ ] 6.2 Ask user: proceed, adjust mappings, or add missing components?
  - [ ] 6.3 ⚠️ Do NOT generate spec without explicit confirmation
- [ ] Step 7: Generate Spec
  - [ ] 7.1 Load `references/spec-template.md` for output structure
  - [ ] 7.2 Write the deterministic Implementation Contract first
  - [ ] 7.3 Generate supporting evidence and rationale after the contract
  - [ ] 7.4 Add the persistent reference/crop manifest
  - [ ] 7.5 Write spec to file (default: `ui-spec-{timestamp}.md` or `--output` path)
- [ ] Step 8: Validate Spec ⚠️ REQUIRED
  - [ ] 8.1 Run `scripts/validate-spec.sh <spec-path>` when available
  - [ ] 8.2 Run the pre-delivery checklist and fix failures
  - [ ] 8.3 Verify high-salience regions have numeric acceptance criteria
  - [ ] 8.4 Verify the contract has no alternatives or unresolved approximations
  - [ ] 8.5 Present final summary to user
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `<image>` | Screenshot path or Figma URL | Required |
| `--quick` | Skip confirmation gate (Step 5) | false |
| `--scope` | `full` (entire page), `component` (single component), `page` (page-level) | full |
| `--output <path>` | Output file path | `ui-spec-{timestamp}.md` |

## Step 1: Parse Input

$ARGUMENTS

Extract the image path or Figma URL. Supported inputs:
- Local file path: `/path/to/screenshot.png`
- Relative path: `./design/homepage.png`
- Figma URL: `https://www.figma.com/design/...`
- Bare filename: `dashboard.png` (resolved relative to CWD)

Flags:
- `--quick` → skip Step 5 confirmation
- `--scope component` → only spec the primary component in the image
- `--scope page` → spec at page level with section breakdowns
- `--output spec.md` → custom output path

If no image provided → ASK the user for one. Do not proceed without input.

## Step 2: Scan Design System

Run the scanner script:

```bash
bash "$SKILL_DIR/scripts/scan-design-system.sh" .
```

This outputs a structured inventory of:
- Component names + import paths + props
- Design tokens (colors, spacing, typography, shadows, borders)
- Icon library entries
- Style patterns (CSS modules, styled-components, Tailwind, etc.)

If script returns empty or fails:
1. Search `src/` for `*.tsx`, `*.jsx` files
2. Look for `components/`, `ui/`, `design-system/` directories
3. Search for theme/token files: `theme.ts`, `tokens.ts`, `colors.ts`, `tailwind.config.*`
4. Search for icon imports: `lucide-react`, `@heroicons`, `react-icons`, `phosphor-react`

Ask yourself: What components are available? What tokens define the visual system? What icon set is in use?

## Step 3: Analyze Design Image

### For local images (PNG, JPG, WebP):
View the image and inspect intrinsic dimensions with an image metadata tool. For a full-page
screenshot, create or inspect zoomed crops for the header, one representative card, repeated rows,
and any dense chart/table region. Never derive small text or icon dimensions from the full-page
overview alone.

### For Figma URLs:
Use `mcp__figma-ui-mcp__figma_read` with `operation: "get_design_context"` to get structured design data including layout, tokens, typography, and component instances.

### Scale calibration

Load `references/visual-measurement-guide.md` and follow it before assigning CSS values.

Record:

```text
Intrinsic image: [width] x [height] image px
Intended viewport: [width] x [height] CSS px
Scale factor: [image px / CSS px] or UNKNOWN
Evidence: Figma frame / browser viewport / DPR / known component anchor / human confirmation
```

If a screenshot narrower than 900 px contains four desktop cards in one row, treat it as likely
downscaled. Do not map its apparent 8 px text to `text-xs` without calibration.

### Measurement ledger

For each high-salience region, record at least:

- bounding width and height
- outer and inner gaps
- padding
- border radius and border/shadow
- icon container and icon size
- font size, weight, line height, and color
- alignment and ordering

Use ranges only when image quality prevents a precise value. Mark confidence as high, medium, or
low. Low-confidence values become clarification questions.

### Fidelity tier

Declare exactly one:

- `Screenshot-calibrated / target >=95%`: calibrated screenshot, known viewport, exact fixtures,
  measured geometry, known fonts, and explicit custom values.
- `Figma-exact / target 98-100%`: Figma inspect data, exact constraints, assets, fonts, fills,
  strokes, effects, and target render environment.

Never write `95-100%` as one undifferentiated target.

### Handoff bundle

Create `specs/assets/<spec-name>/` containing:

- `reference.png` or the original source format;
- one crop per high-salience region;
- stable filenames such as `header.png`, `primary-card.png`, `row-highlighted.png`, `chart.png`;
- no temporary `/tmp` paths in the final spec.

Record each crop's source rectangle `(x, y, width, height)` in the spec. The implementation model
must receive both the spec and this folder.

Use:

```bash
bash "$SKILL_DIR/scripts/create-reference-bundle.sh" \
  <source-image> specs/assets/<spec-name> \
  header:x:y:width:height \
  primary-component:x:y:width:height
```

The generated `manifest.tsv` records crop coordinates and SHA-256 hashes.

### Analysis questions to answer:
1. What is the overall layout structure? (sidebar + main? header + content? grid?)
2. What sections/regions exist? Name each one.
3. What components are visible in each section? (buttons, inputs, cards, tables, modals...)
4. What is the visual hierarchy? (heading levels, emphasis, primary vs secondary)
5. What colors are used? (backgrounds, text, accents, borders, states)
6. What typography? (sizes, weights, line heights, font families)
7. What spacing patterns? (padding, gaps, margins)
8. What icons? (navigation, status, action icons)
9. What states are visible? (hover, active, disabled, selected, error)
10. What responsive behavior is implied? (stacking, reflow, breakpoints)
11. What interactions are implied? (click → navigate/modal/submit/toggle, form validation, drag-drop, infinite scroll)
12. What data is dynamic? (table rows, list items, user name/avatar, counts/badges — anything not hardcoded text)
13. What conditional states exist? (loading skeleton, empty state, error state, auth-gated sections)
14. What is the component nesting? (which components wrap which — not just a flat list)
15. Is the image downscaled, retina-scaled, browser-zoomed, or cropped?
16. Which 3-5 visual anchors most strongly determine whether the implementation matches?

## Step 4: Map Design → Codebase

Load `references/component-mapping-guide.md` for detailed mapping methodology.

Core mapping rules:
1. **Exact match**: Design shows a Button → codebase has `<Button>` → map directly with import path
2. **Variant match**: Design shows a primary blue button → codebase has `<Button variant="primary">` → map with variant
3. **Composition**: Design shows a card with avatar + text → codebase has `<Card>` + `<Avatar>` → map as composition
4. **MISSING**: Design shows a date picker → codebase has no date picker → mark as `MISSING: DatePicker`
5. **CUSTOM**: Design uses 13px spacing → record `CUSTOM: 13px (measured; closest token:
   spacing-3 = 12px)`. Do not replace it with 12px unless the user accepts the difference.
6. **UNSURE**: You have 2+ candidate components, or can't tell which variant/color/icon it is → mark as `❓ UNSURE` and formulate a specific question for the human

Never invent mappings. If unsure, mark as UNSURE — do NOT guess.

### When to mark as ❓ UNSURE (ASK THE HUMAN):

**Component uncertainty:**
- Design shows a button-like element → codebase has both `<Button>` and `<ActionButton>` → ask which one
- Design shows a card with unusual layout → codebase has `<Card>` and `<Panel>` → ask which one
- Design shows a table → codebase has `<Table>` and `<DataTable>` → ask which one
- Component exists but you're unsure which variant/props to use

**Color uncertainty:**
- Design color could match 2+ tokens (e.g., `gray-600` vs `gray-700`) → ask which one
- Design color doesn't match any token exactly → ask: add new token or use closest?
- Image quality too low to determine exact color → ask the human to identify

**Icon uncertainty:**
- Design shows a small icon you can't clearly identify → ask: "What icon is this? (looks like [X] or [Y])"
- Icon library has similar icons (e.g., `ChevronDown` vs `ArrowDown`) → ask which one

**Typography uncertainty:**
- Text size could be `body-md` or `body-lg` → ask which one
- Font weight unclear from screenshot → ask the human

**Spacing uncertainty:**
- Gap could be `spacing-4` (16px) or `spacing-5` (20px) → ask which one
- Padding unclear from screenshot → ask the human

**Layout uncertainty:**
- Can't tell if section uses flex or grid → ask the human
- Responsive behavior not shown in design → ask if responsive spec is needed
- Intended viewport or screenshot scale is unknown → ask for viewport width, browser zoom, DPR, or
  confirmation of a proposed scale

**Interaction uncertainty:**
- Button click behavior unclear (navigate? open modal? submit? toggle?) → ask what happens
- Table row click → navigate? expand? select? → ask the human
- Form submit → API endpoint? redirect? toast? → ask the human
- Dropdown selection → filters? persists? → ask the human

**Data uncertainty:**
- Can't tell if text is static or dynamic → ask: "Is [text] hardcoded or from data?"
- Table columns unclear → ask: "What columns does this table have? Any sorting/filtering?"
- List items structure unclear → ask: "What data shape does each item have?"

**Conditional rendering uncertainty:**
- Design only shows happy path → ask: "Loading state? Empty state? Error state?"
- Section might be auth-gated → ask: "Does this require login? Role-based?"
- UI varies by state (tabs, toggles, step wizards) → ask: "What are the different views/states?"

## Step 5: Clarify UNSURE Items

Collect all ❓ UNSURE items and ask the human using AskUserQuestion. Group related questions to minimize back-and-forth.

Ask one specific question per unresolved decision. Name the design location, show 2-4 verified
candidates with import paths or values, and explain what changes visually or behaviorally.

### Rules for asking:
1. **Be specific** — show the exact candidates with import paths or token values
2. **Provide options** — give 2-4 concrete choices, not open-ended questions
3. **Include context** — tell the human WHERE in the design the element appears
4. **Batch questions** — use AskUserQuestion with up to 4 questions at once to minimize rounds
5. **Mark resolved** — update UNSURE → MATCH/MISSING/CUSTOM based on the answer
6. **Do NOT skip** — every UNSURE item must be resolved before proceeding to Step 6

If there are no ❓ UNSURE items after Step 4, skip this step.

## Step 6: Confirm Mapping

Present a summary table including all statuses:

```
## Mapping Summary

| Design Element | Codebase Component | Status |
|---------------|-------------------|--------|
| Primary Button | Button (variant="primary") | ✅ MATCH |
| Search Input | Input (type="search") | ✅ MATCH |
| Date Picker | — | ❌ MISSING |
| 13px gap | spacing-3 (12px) | ⚠️ CUSTOM |
| Card vs Panel | Card | ✅ RESOLVED (was UNSURE) |

Matched: 12 | MISSING: 1 | CUSTOM: 1 | Resolved: 1
```

Ask: Proceed with this mapping? Adjust any? Add MISSING components first?

⚠️ Do NOT generate spec without user confirmation (unless `--quick`).

## Step 7: Generate Spec

Load `references/spec-template.md` for the complete output structure.
Load `references/fidelity-contract-guide.md` before writing the Implementation Contract.

The spec MUST be self-contained — anyone reading it (human or AI) can recreate the UI without access to:
- The original design image
- This skill
- The codebase being scanned

Key sections in the spec:
1. **Implementation Contract**: compact source of truth for files, DOM, CSS, fixtures, states, and
   prohibited deviations
2. **Reference Calibration**: viewport, scale, render environment, and fidelity tier
3. **Page Context**: route, auth, exact files to modify/create
4. **Design System Context**: verified components, tokens, icons
5. **Component Tree**: exact nesting
6. **Geometry and Style Contract**: exact box model, typography, colors, effects, and z-order
7. **Content Fixture**: exact strings, data, assets, locale, and formatting
8. **Interaction and State Matrix**: deterministic behavior for every relevant state
9. **Visual Measurement Ledger**: measurement evidence
10. **Reference Asset Manifest**: persistent source/crops and crop coordinates
11. **Visual Acceptance Criteria**: render environment, anchors, tolerances, and comparison method
12. **Supporting Notes**: APIs, accessibility, rationale, and missing capabilities

## Step 8: Validate Spec

### Pre-Delivery Checklist

#### Completeness
- [ ] Implementation Contract is the first substantive section after Meta
- [ ] Contract lists exact files, DOM order, CSS/props, content fixture, states, and prohibited
      substitutions
- [ ] Fidelity tier and target are declared
- [ ] Render environment specifies viewport, DPR, browser/engine, zoom, fonts, locale, and animations
- [ ] Persistent reference and crop assets exist and are listed with source coordinates
- [ ] Intrinsic image dimensions, intended CSS viewport, scale factor, and evidence are recorded
- [ ] Every major region was inspected at useful zoom/crop
- [ ] High-salience components have numeric geometry and typography
- [ ] Every visual element in the design has a mapping (MATCH, MISSING, CUSTOM, or RESOLVED)
- [ ] No ❓ UNSURE items remain in the spec (all must be resolved or listed in Open Questions)
- [ ] All component references include import paths
- [ ] All color references use token names (not raw hex unless CUSTOM)
- [ ] All spacing references use spacing scale (not raw px unless CUSTOM)
- [ ] Typography references use style names from the project
- [ ] Page Context section includes: route, auth, existing file vs new file, layout wrapper
- [ ] Component Tree shows actual nesting structure (NOT flat list)
- [ ] Interaction Flow covers every clickable/interactive element with specific action
- [ ] Data Schema includes TypeScript interfaces for dynamic data
- [ ] Conditional Rendering covers: loading, empty, error states + auth gates
- [ ] Validation Rules present for every form with rules, messages, and display position

#### Correctness
- [ ] Contract contains one implementation choice per element
- [ ] Third-party defaults are verified or overridden explicitly
- [ ] Text wrapping uses exact fixture strings and exact available widths
- [ ] Borders and shadows use complete CSS values
- [ ] Image pixels were not treated as CSS pixels without scale evidence
- [ ] Exact custom values are preserved when nearest tokens would visibly diverge
- [ ] No component names that don't exist in the codebase (unless marked MISSING)
- [ ] No token references that aren't in the design system inventory
- [ ] Layout structure matches what's visible in the design
- [ ] Component props match what the actual component accepts

#### Self-Containedness
- [ ] Spec can be understood without the original image
- [ ] Spec includes enough detail for an AI to implement the UI
- [ ] All custom/missing values are clearly flagged
- [ ] Design system context section provides enough component documentation

#### Quality
- [ ] Contract can be implemented without reading supporting rationale
- [ ] No ambiguous terms, alternatives, or numeric ranges appear in the contract
- [ ] Visual acceptance criteria name the target viewport and allowable tolerances
- [ ] The spec requires a rendered screenshot comparison before implementation is considered done
- [ ] No placeholder text (TODO, FIXME, xxx)
- [ ] Consistent formatting throughout
- [ ] File follows the spec-template.md structure

## Anti-Patterns

Do NOT:
- Put critical implementation requirements only near the end of a long spec
- Give multiple implementation approaches for a high-salience visual
- Use value ranges in the final contract
- Depend on unspecified browser, DPR, zoom, font, locale, or animation defaults
- Use placeholder/generated content when wrapping affects layout
- Treat a downscaled screenshot's pixels as CSS pixels
- Infer typography from a full-page thumbnail without zooming the region
- Prefer a nearby token when it materially changes the reference design
- Describe layout only semantically; include measurable geometry
- Invent component names that don't exist in the codebase
- Guess a component/color/icon when you're unsure — ASK the human instead
- Use hardcoded hex colors when tokens are available
- Use generic spacing (8px, 16px) when the project has a spacing scale
- Skip the scan step and assume what components exist
- Write vague descriptions like "a card with some content" — be specific about every prop and variant
- Omit import paths — another developer needs to know WHERE the component lives
- Mark everything as MATCHED when you haven't verified — wrong mappings are worse than MISSING
- Add components, hooks, or utilities "that would be nice" — only spec what's in the design
- Include implementation code in the spec — the spec describes WHAT, not HOW
- Leave ❓ UNSURE items unresolved — every one must be asked about or clearly listed in Open Questions
- Write "probably" or "likely" in a mapping — if you're not sure, it's a question, not a mapping
- Omit Interaction Flow — AI will generate static UI with no onClick handlers
- Omit Data Schema — AI will hardcode text instead of binding to data
- Omit Conditional Rendering — AI will only implement the happy path (no loading/empty/error)
- Omit Page Context — AI will create a new file instead of editing the existing one
- List components flat without nesting — AI will generate wrong DOM structure
- Skip form validation rules — AI will generate forms that accept any input

## Quick Reference

```
/ui-spec dashboard.png                    # Full spec from screenshot
/ui-spec ./design/login.png --quick       # Skip confirmation
/ui-spec figma-url --scope component      # Single component spec
/ui-spec card.png --output specs/card.md  # Custom output path
```

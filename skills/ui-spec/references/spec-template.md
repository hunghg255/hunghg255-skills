# Spec Template

## Table of Contents
1. [File Structure](#file-structure)
2. [Complete Template](#complete-template)
3. [Section Guidelines](#section-guidelines)

## File Structure

Every UI spec follows this structure. Sections marked **(optional)** can be omitted if not applicable.

```markdown
# UI Spec: [Page/Component Name]

## Meta
## Implementation Contract
## Reference Calibration
## Page Context
## Design System Context
## Component Tree
## Layout Structure
## Sections
## Component Details
## Interaction Flow
## Data Schema
## Conditional Rendering
## Validation Rules
## Token Usage
## Missing Components
## Open Questions
## Implementation Notes
## Visual Measurement Ledger
## Reference Asset Manifest
## Visual Acceptance Criteria
```

## Complete Template

```markdown
# UI Spec: [PAGE_NAME]

> Generated: [DATE]
> Source: [IMAGE_PATH or FIGMA_URL]
> Project: [PROJECT_NAME]
> Scope: [full | page | component]

---

## Meta

| Field | Value |
|-------|-------|
| Page Name | [e.g., Dashboard, User Profile, Settings] |
| Description | [1-2 sentences: what this page does, who uses it] |
| Source | [path to screenshot or Figma URL] |
| Generated | [date] |
| Scope | [full / page / component] |

---

## Implementation Contract

> Authoritative section. If supporting notes conflict with this contract, this contract wins.

### Fidelity Target

| Field | Value |
|-------|-------|
| Tier | Screenshot-calibrated / Figma-exact |
| Target | >=95% / 98-100% |
| Viewport | [width x height CSS px] |
| Render environment | [browser, DPR, zoom, OS, theme, locale, fonts, animations] |

### File Operations

```text
MODIFY [exact path]
CREATE [exact path]
DO NOT MODIFY [exact path/category]
```

### DOM Contract

```text
[Exact semantic tag/component order and nesting]
```

### Style Contract

| Element | Width | Height | Padding | Gap | Typography | Colors | Border | Radius | Shadow | Overflow |
|---------|-------|--------|---------|-----|------------|--------|--------|--------|--------|----------|
| [element] | [exact] | [exact] | [exact] | [exact] | [family/size/weight/line-height/tracking] | [exact] | [width style color] | [exact] | [full CSS] | [exact] |

### Content Fixture

| Element | Exact Content/Data | Asset | Formatting |
|---------|--------------------|-------|------------|
| [element] | [literal text/data] | [exact path/URL] | [locale/formatter] |

### State Contract

| Component | State | Exact Visual/Behavior |
|-----------|-------|-----------------------|
| [component] | [state] | [deterministic requirement] |

### Prohibited Deviations

- [Specific substitution/default that must not be used]

### Verification

```text
1. Run [exact command].
2. Open [exact route/state].
3. Capture at [exact viewport/DPR/zoom].
4. Compare with [exact persistent crop path].
5. Fix geometry, typography, then colors/effects.
6. Repeat until every acceptance anchor passes.
```

---

## Reference Calibration

| Field | Value |
|-------|-------|
| Intrinsic image size | [width x height image px] |
| Intended CSS viewport | [width x height CSS px] |
| Scale factor | [image px / CSS px] |
| Scale evidence | [Figma frame / capture metadata / known anchor / human confirmation] |
| Regions inspected | [list of zoomed/cropped regions] |
| Fidelity tier | [Screenshot-calibrated >=95% / Figma-exact 98-100%] |
| Render environment | [browser, DPR, zoom, OS, theme, locale, fonts, animations] |

If scale is unresolved, stop and list it in Open Questions.

---

## Page Context

**This section tells the AI WHERE to put code — the #1 cause of wrong implementation.**

| Field | Value |
|-------|-------|
| Route | [e.g., `/dashboard`, `/users/:id`] |
| Auth Required | [yes / no / role-based] |
| If yes, required role | [e.g., `admin`, `authenticated`] |
| Layout Wrapper | [e.g., `AppLayout`, `DashboardLayout`, `AuthLayout`] |
| Existing File | [e.g., `src/pages/dashboard.tsx` — edit this file, NOT create new] |
| New File | [path if this is a NEW page/component, or "N/A — edit existing"] |
| Parent Route Component | [e.g., `src/App.tsx` or `src/router.tsx` — where to add route] |

---

## Design System Context

### Available Components

| Component | Import Path | Key Props |
|-----------|-----------|-----------|
| Button | `@/components/ui/Button` | variant, size, disabled, loading, icon |
| Input | `@/components/ui/Input` | type, placeholder, error, startAdornment |
| Card | `@/components/ui/Card` | variant, padding, shadow |
| ... | ... | ... |

### Design Tokens

**Colors:**
| Token | Value | Usage |
|-------|-------|-------|
| color-primary-500 | #3B82F6 | Primary actions, links |
| color-gray-900 | #111827 | Primary text |
| ... | ... | ... |

**Spacing:**
| Token | Value |
|-------|-------|
| spacing-1 | 4px |
| spacing-2 | 8px |
| spacing-4 | 16px |
| ... | ... |

**Typography:**
| Style | Font | Size | Weight | Line Height |
|-------|------|------|--------|-------------|
| heading-1 | Inter | 36px | 700 | 1.2 |
| body-md | Inter | 16px | 400 | 1.5 |
| ... | ... | ... | ... |

**Shadows:**
| Token | Value | Usage |
|-------|-------|-------|
| shadow-sm | 0 1px 2px rgba(0,0,0,0.05) | Subtle elevation |
| shadow-md | 0 4px 6px rgba(0,0,0,0.1) | Cards, dropdowns |
| ... | ... | ... |

**Borders:**
| Token | Value | Usage |
|-------|-------|-------|
| radius-md | 8px | Cards, inputs |
| radius-lg | 12px | Modals |
| ... | ... | ... |

### Icon Library

| Icon | Library | Import |
|------|---------|--------|
| Search | lucide-react | `import { Search } from 'lucide-react'` |
| Plus | lucide-react | `import { Plus } from 'lucide-react'` |
| ... | ... | ... |

---

## Component Tree

**This is NOT a flat list — it shows the actual nesting structure that AI must follow. Incorrect nesting = broken layout.**

```
<PageLayout>
  <Header>
    <Logo />
    <NavTabs />
    <UserMenu>
      <Avatar />
      <Dropdown />
    </UserMenu>
  </Header>
  <MainContent>
    <PageTitle />
    <FilterBar>
      <SearchInput />
      <Select label="Status" />
      <Button variant="primary">Add New</Button>
    </FilterBar>
    <DataGrid>
      <GridColumn header="Name" />
      <GridColumn header="Email" />
      <GridColumn header="Status">
        <Badge />
      </GridColumn>
      <GridColumn header="Actions">
        <IconButton icon="edit" />
        <IconButton icon="delete" />
      </GridColumn>
    </DataGrid>
  </MainContent>
</PageLayout>
```

---

## Layout Structure

### Page Layout

```
┌─────────────────────────────────────────────┐
│ Header (height: 64px)                       │
├──────────┬──────────────────────────────────┤
│ Sidebar  │ Main Content                     │
│ (240px)  │ (flex: 1)                        │
│          │                                  │
│          │ ┌──────────────────────────────┐ │
│          │ │ Section: PageTitle           │ │
│          │ └──────────────────────────────┘ │
│          │ ┌──────────────────────────────┐ │
│          │ │ Section: ContentGrid         │ │
│          │ └──────────────────────────────┘ │
│          │                                  │
└──────────┴──────────────────────────────────┘
```

### Layout Properties

| Region | Display | Direction | Gap | Padding | Align |
|--------|---------|-----------|-----|---------|-------|
| Page | flex | row | 0 | 0 | stretch |
| Sidebar | flex | column | spacing-2 | spacing-4 | start |
| Main Content | flex | column | spacing-6 | spacing-8 | start |

### Geometry Contract

| Element | Width | Height | Padding | Gap | Radius | Evidence |
|---------|-------|--------|---------|-----|--------|----------|
| [KPI card] | [value] | [value] | [value] | [value] | [value] | measured/derived/Figma |

### Responsive Behavior

| Breakpoint | Layout Change |
|------------|--------------|
| < 768px (mobile) | Sidebar collapses to hamburger menu, single column |
| 768-1024px (tablet) | Sidebar narrows to 64px icon-only |
| > 1024px (desktop) | Full sidebar (240px) with labels |

---

## Sections

### Section: [SECTION_NAME]

**Description:** [What this section contains and its purpose]

**Layout:**
- Display: flex | grid
- Direction: row | column
- Gap: [token or CUSTOM value]
- Padding: [token or CUSTOM value]
- Background: [token or CUSTOM value]

**Components:**

| # | Component | Import | Props | Content/Notes |
|---|-----------|--------|-------|---------------|
| 1 | Button | `@/components/ui/Button` | variant="primary" size="md" | "Submit Form" |
| 2 | Input | `@/components/ui/Input` | type="email" placeholder="Enter email" | Email field |
| ... | ... | ... | ... | ... |

---

## Component Details

### Button (variant="primary", size="md")

**Import:** `import Button from '@/components/ui/Button'`

**Props:**
| Prop | Value | Notes |
|------|-------|-------|
| variant | "primary" | Blue background, white text |
| size | "md" | 36px height, 16px horizontal padding |
| disabled | false | |
| loading | false | |

**States:**
| State | Visual Change |
|-------|--------------|
| Default | bg-primary-500, text-white |
| Hover | bg-primary-600 |
| Active | bg-primary-700 |
| Disabled | bg-gray-300, cursor-not-allowed |
| Loading | Spinner replaces text |

---

## Interaction Flow

**This is the #1 missing piece in most specs. Without it, AI generates static UI with no behavior.**

### Button/Form Actions

| Trigger | Component | Action | Details |
|---------|-----------|--------|---------|
| Click | Button "Add New" | Open modal | `<CreateItemModal />` opens |
| Submit | Form in modal | POST `/api/items` | On success: close modal, refresh list, show toast "Item created" |
| Click | IconButton "delete" | Confirm dialog | `<ConfirmDialog />` → DELETE `/api/items/:id` → refresh list |
| Click | NavTab | Client-side navigate | `router.push('/[tab]')` — no page reload |

### Filter/Search Interactions

| Trigger | Component | Action | Details |
|---------|-----------|--------|---------|
| Type | SearchInput | Debounced filter | 300ms debounce → filter table by query |
| Change | Select "Status" | Filter table | Filter data rows where status matches selected value |

### Navigation

| From | To | Trigger | Method |
|------|----|---------|--------|
| Dashboard | User Detail | Click table row | `router.push(\`/users/\${id}\`)` |
| Any page | Login | Auth check fails | `router.replace('/login')` |

---

## Data Schema

**Without this, AI hardcodes placeholder text or guesses wrong data shapes.**

### API Endpoints (if applicable)

| Method | Endpoint | Description | Response Shape |
|--------|----------|-------------|----------------|
| GET | `/api/items` | List items | `{ data: Item[], total: number }` |
| POST | `/api/items` | Create item | `{ data: Item }` |
| DELETE | `/api/items/:id` | Delete item | `{ success: boolean }` |

### TypeScript Interfaces

```typescript
interface Item {
  id: string;
  name: string;
  email: string;
  status: 'active' | 'inactive' | 'pending';
  createdAt: string; // ISO date
}

interface PageData {
  items: Item[];
  total: number;
  page: number;
  pageSize: number;
}
```

### Static vs Dynamic Content

| Content | Source | Example |
|---------|--------|---------|
| Page title "Dashboard" | Static | Hardcoded |
| User name in header | Dynamic | `user.name` from auth context |
| Table rows | Dynamic | `items` from API response |
| Badge count "3 new" | Dynamic | Computed from data |
| Empty state text | Static | Hardcoded message |

---

## Conditional Rendering

**Without this, AI only implements the happy path. Real UIs need all states.**

### Data States

| State | When | What Renders |
|-------|------|-------------|
| Loading | API request in flight | `<TableSkeleton rows={5} />` or `<Spinner />` |
| Empty | API returns `[]` | `<EmptyState title="No items yet" description="Create your first item" action={<Button>Add Item</Button>} />` |
| Error | API returns error | `<ErrorState message="Failed to load items" onRetry={refetch} />` |
| Success (partial) | API returns data | Main content with data |

### Auth States

| State | When | What Renders |
|-------|------|-------------|
| Authenticated | User logged in | Full page content |
| Unauthenticated | No session | Redirect to `/login` |
| Unauthorized | Wrong role | `<Forbidden />` or hide restricted sections |

### UI States

| Component | Condition | Visible | Hidden |
|-----------|-----------|---------|--------|
| Delete button | `item.deletable === true` | Show | Hide (or show disabled) |
| Status badge | `item.status` | Badge with variant based on status | — |
| Modal | `isModalOpen` | `<CreateItemModal />` | Nothing |

---

## Validation Rules

**Without this, AI generates forms without validation — always gets rejected in review.**

| Field | Component | Rules | Error Message | Display |
|-------|-----------|-------|--------------|---------|
| Email | Input type="email" | Required, valid email format | "Enter a valid email address" | Below input, red text |
| Name | Input | Required, min 2 chars | "Name must be at least 2 characters" | Below input, red text |
| Status | Select | Required | "Please select a status" | Below select, red text |

### Validation Behavior

- **When**: Validate on blur (first time) + on submit
- **Display**: Error message appears below the input field
- **Color**: Input border changes to `color-error-500`, label to `color-error-700`
- **Clear**: Error clears when user starts typing
- **Submit**: Button disabled until all errors resolved, or show all errors on submit

---

## Token Usage

### Colors Used

| Element | Token | Value | Status |
|---------|-------|-------|--------|
| Page background | color-gray-50 | #F9FAFB | ✅ |
| Card background | color-white | #FFFFFF | ✅ |
| Primary button bg | color-primary-500 | #3B82F6 | ✅ |
| Custom accent | — | #4A90D9 | ⚠️ CUSTOM |

### Typography Used

| Element | Style | Size | Weight | Status |
|---------|-------|------|--------|--------|
| Page title | heading-1 | 36px | 700 | ✅ |
| Section title | heading-3 | 20px | 600 | ✅ |
| Body text | body-md | 16px | 400 | ✅ |
| Custom label | — | 11px | 500 | ⚠️ CUSTOM |

### Spacing Used

| Location | Token | Value | Status |
|----------|-------|-------|--------|
| Page padding | spacing-8 | 32px | ✅ |
| Card padding | spacing-6 | 24px | ✅ |
| Custom gap | — | 13px | ⚠️ CUSTOM (closest: spacing-3 = 12px) |

---

## Missing Components

| Component | Purpose | Suggested Approach |
|-----------|---------|-------------------|
| DatePicker | Date selection in filters | Use react-datepicker or build from Input + Calendar |
| RichTextEditor | Content editing area | Use TipTap or Slate.js |

---

## Open Questions

**These MUST be answered before implementation. Do NOT guess.**

1. [Question from UNSURE items that was not resolved]
2. [...]

---

## Implementation Notes

1. **Custom colors**: The design uses #4A90D9 which doesn't match any token. Either add a new token or use `color-primary-400` (#60A5FA) as the closest match.

2. **Custom spacing**: 13px gap doesn't align with the 4px-based spacing scale. Recommend using spacing-3 (12px) for consistency.

3. **Accessibility**:
   - The modal needs focus trapping (Tab/Shift+Tab cycle within modal)
   - Escape key closes modal
   - After modal closes, focus returns to trigger button
   - Table rows need `role="row"`, sortable headers need `aria-sort`
   - All form inputs have associated `<label>` elements

4. **Responsive**: The sidebar should collapse at the tablet breakpoint. The design only shows desktop — mobile layout may need separate specification.

5. **Animations**:
   - Modal: fade-in 200ms ease-out, fade-out 150ms ease-in
   - Dropdown: slide-down 150ms ease-out
   - Page transitions: none (instant)
   - Button hover: background-color transition 150ms

6. **Keyboard**:
   - Tab order: follows visual order (top→bottom, left→right)
   - Enter on Button: triggers click
   - Escape on Modal: closes modal
```

## Visual Measurement Ledger

| Region/Element | Property | Image px | Scale | CSS px | Token/Custom | Confidence |
|----------------|----------|----------|-------|--------|--------------|------------|
| [element] | [height/font/etc.] | [value] | [value] | [value] | [mapping] | high/medium/low |

Every high-salience component needs enough rows to reconstruct its box model and typography.

## Reference Asset Manifest

| Asset | Persistent Path | Source Rectangle `(x, y, width, height)` | Purpose |
|-------|-----------------|--------------------------------------------|---------|
| Full reference | `specs/assets/[spec-name]/reference.png` | Full image | Overall comparison |
| [region] | `specs/assets/[spec-name]/[region].png` | `[x, y, w, h]` | High-salience comparison |

All listed files must exist before delivery. Do not reference temporary paths.

## Visual Acceptance Criteria

| Region | Viewport | Check | Target | Tolerance |
|--------|----------|-------|--------|-----------|
| [region] | [width x height] | [card height/filter position/etc.] | [numeric target] | [e.g. +/-2px] |

- Render the implementation at the stated viewport.
- Compare against the reference using overlay, image diff, or side-by-side inspection.
- Do not mark implementation complete while a high-salience anchor exceeds tolerance.

## Section Guidelines

### Meta
- Always include: page name, generation date, source reference
- Scope tells the reader how detailed the spec is

### Page Context
- **Most critical section for AI implementation** — wrong file = wrong output
- "Existing File" tells AI to EDIT, not CREATE — prevents duplicate files
- "Layout Wrapper" tells AI the page lives inside an existing shell
- Auth requirements prevent AI from forgetting auth guards

### Design System Context
- This section makes the spec self-contained
- Include ONLY the components, tokens, and icons that are relevant to this spec
- Not the entire design system — just what's needed to understand this page

### Component Tree
- Shows actual nesting — NOT a flat list
- AI that reads this will generate correct DOM structure
- Use indentation to show parent-child relationships
- Include all components, even "obvious" ones like Layout wrappers

### Layout Structure
- ASCII diagram gives visual overview
- Table provides exact values
- Responsive section is critical — even if the design only shows desktop

### Sections
- Break the page into logical sections (header, sidebar, main content areas)
- Each section lists its components with exact props

### Component Details
- Only detail components that need explanation beyond their default usage
- Focus on: which variant, which props, what content, what states

### Interaction Flow
- **The #1 reason AI generates static UI** — specs describe visuals but not behavior
- Every clickable/interactive element MUST have a corresponding action
- Be explicit: "navigate to /X", "open <ModalY>", "POST /api/Z"
- Include success AND failure outcomes

### Data Schema
- TypeScript interfaces tell AI exactly what data to expect
- Distinguish static vs dynamic content — prevents hardcoding dynamic text
- API endpoints tell AI where data comes from

### Conditional Rendering
- AI will ONLY implement what's visible in the design (happy path)
- You MUST explicitly list loading, empty, error states
- Auth gates prevent AI from building unguarded pages

### Validation Rules
- Without this, AI generates forms with no validation
- Be specific: what rules, what messages, where to display errors
- Include validation trigger (on blur, on submit, on change)

### Token Usage
- The single source of truth for all visual values
- Status column makes it immediately clear what's standard vs custom

### Missing Components
- Honest inventory of what doesn't exist yet
- Suggested approaches save the implementer time

### Open Questions
- Anything unresolved from the UNSURE flow
- Marked prominently so implementer knows they must decide

### Implementation Notes
- Gotchas and decisions that aren't obvious from the spec alone
- Accessibility, responsive, animation, keyboard considerations

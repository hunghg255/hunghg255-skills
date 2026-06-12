# Component Mapping Guide

## Table of Contents
1. [Mapping Methodology](#mapping-methodology)
2. [Component Discovery Patterns](#component-discovery-patterns)
3. [Mapping Status Codes](#mapping-status-codes)
4. [Common React Component Patterns](#common-react-component-patterns)
5. [Token Resolution](#token-resolution)
6. [Icon Mapping](#icon-mapping)
7. [Layout Mapping](#layout-mapping)
8. [Visual Fidelity Priority](#visual-fidelity-priority)

## Mapping Methodology

The mapping process converts visual elements from a design into references to real components in the codebase. This is NOT about writing code — it's about creating a precise correspondence table.

### Step-by-step mapping process:

1. **Identify** — Name every visual element in the design
2. **Search** — Find the closest matching component in the codebase
3. **Verify** — Read the component source to confirm it supports the needed props/variants
4. **Map** — Record the mapping with status (MATCH / MISSING / CUSTOM)
5. **Document** — Note any prop overrides, variant selections, or custom values needed

### Verification is mandatory

Before marking something as MATCH:
- Read the component file (at minimum the props/interface definition)
- Confirm the variant exists
- Confirm the prop accepts the expected value
- Check if there are required props you must provide

## Component Discovery Patterns

### Where to look for components in a React project:

```
src/
├── components/          # Shared components
│   ├── ui/             # Primitives (Button, Input, Select...)
│   ├── layout/         # Layout components (Header, Sidebar...)
│   ├── forms/          # Form-related (FormField, Select, Checkbox...)
│   └── feedback/       # Feedback (Alert, Toast, Modal...)
├── features/           # Feature-specific components
│   └── dashboard/
│       └── components/
├── design-system/      # Design system package (if isolated)
├── styles/             # Theme, tokens, global styles
│   ├── theme.ts
│   ├── tokens.ts
│   └── globals.css
└── icons/              # Icon components or SVGs
```

### Common naming patterns to search:

| Visual Element | Common Component Names |
|---------------|----------------------|
| Button | Button, Btn, IconButton, ActionButton |
| Text Input | Input, TextField, TextInput, FormField |
| Dropdown | Select, Dropdown, ComboBox, Autocomplete |
| Card | Card, Surface, Panel |
| Modal | Modal, Dialog, Drawer, Sheet |
| Table | Table, DataTable, DataGrid |
| Navigation | Nav, Navbar, Sidebar, TabBar, Breadcrumb |
| Toggle | Switch, Toggle, Checkbox |
| Badge | Badge, Chip, Tag, Pill |
| Avatar | Avatar, UserAvatar, ProfileImage |
| Tooltip | Tooltip, Popover, Overlay |
| Progress | Progress, ProgressBar, Spinner, Loader |
| Alert | Alert, Banner, Callout, Notification, Toast |

## Mapping Status Codes

| Status | Meaning | When to Use | Format in Spec |
|--------|---------|-------------|---------------|
| ✅ MATCH | Exact or variant match exists | Component exists with needed props | `Component (prop="value")` |
| ⚠️ CUSTOM | Partial match, needs adjustment | Token/value doesn't exist exactly | `CUSTOM: value (closest: token-name = actual-value)` |
| ❌ MISSING | No match in codebase | Component or token doesn't exist | `MISSING: ComponentName` |

### MATCH examples:

```
Design: Blue primary button
Codebase: <Button variant="primary">
Mapping: ✅ Button variant="primary" from @/components/ui/Button

Design: Search input with icon
Codebase: <Input startAdornment={<SearchIcon />}>
Mapping: ✅ Input startAdornment={SearchIcon} from @/components/ui/Input

Design: User avatar with online indicator
Codebase: <Avatar status="online">
Mapping: ✅ Avatar status="online" from @/components/ui/Avatar
```

### CUSTOM examples:

```
Design: 13px gap between elements
Codebase: spacing scale has 12px (spacing-3) and 16px (spacing-4)
Mapping: ⚠️ CUSTOM: gap 13px (closest: spacing-3 = 12px)

Design: #4A90D9 accent color
Codebase: Primary token is blue-500 = #3B82F6
Mapping: ⚠️ CUSTOM: #4A90D9 (closest: blue-500 = #3B82F6)
```

### MISSING examples:

```
Design: Date picker calendar
Codebase: No date picker component
Mapping: ❌ MISSING: DatePicker

Design: Rich text editor
Codebase: No editor component
Mapping: ❌ MISSING: RichTextEditor
```

## Common React Component Patterns

### Variant-based components (most common):

```tsx
// Component supports variants
<Button variant="primary" size="md" disabled>
// Map as: Button variant="primary" size="md" disabled={false}
```

### Compound components:

```tsx
// Component has sub-components
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
  <Card.Footer>Actions</Card.Footer>
</Card>
// Map as: Card with Card.Header, Card.Body, Card.Footer
```

### Slot-based components:

```tsx
// Component accepts render props or slots
<Dialog
  trigger={<Button>Open</Button>}
  content={<DialogContent />}
/>
// Map as: Dialog trigger={Button} content={DialogContent}
```

### Styled-system / Tailwind components:

```tsx
// Component uses utility classes
<div className="flex items-center gap-4 p-6 bg-white rounded-lg shadow-md">
// Map layout: flex, items-center, gap-4, p-6
// Map tokens: bg-white, rounded-lg, shadow-md
```

## Token Resolution

### Color tokens

Ask: Does the project use CSS variables, Tailwind config, or JS theme tokens?

```css
/* CSS variables */
--color-primary-500: #3B82F6;

/* Tailwind config */
colors: { primary: { 500: '#3B82F6' } }

/* JS tokens */
export const colors = { primary: { 500: '#3B82F6' } }
```

Always resolve to the token NAME, not the hex value:
- ✅ `color-primary-500`
- ✅ `CUSTOM #3B82F6` when the project has no exact token and fidelity requires it
- ❌ silently replacing the measured color with a visibly different token

### Spacing tokens

Common spacing scales:

| Token | Value |
|-------|-------|
| spacing-0 | 0px |
| spacing-0.5 | 2px |
| spacing-1 | 4px |
| spacing-1.5 | 6px |
| spacing-2 | 8px |
| spacing-3 | 12px |
| spacing-4 | 16px |
| spacing-5 | 20px |
| spacing-6 | 24px |
| spacing-8 | 32px |
| spacing-10 | 40px |
| spacing-12 | 48px |

When design value doesn't match exactly → mark as CUSTOM with closest token.

The closest token is documentation, not permission to change the target value.

### Typography tokens

Common patterns:

```css
/* CSS */
.text-heading-1 { font-size: 2rem; font-weight: 700; line-height: 1.2; }

/* Tailwind */
text-3xl font-bold leading-tight

/* JS tokens */
typography: { h1: { fontSize: '2rem', fontWeight: 700, lineHeight: 1.2 } }
```

Map as: `typography-h1` or `text-heading-1` — use the project's naming.

## Icon Mapping

### Common icon libraries in React:

| Library | Import Pattern | Example |
|---------|---------------|---------|
| lucide-react | `import { Search } from 'lucide-react'` | `<Search size={16} />` |
| @heroicons/react | `import { MagnifyingGlassIcon } from '@heroicons/react/24/outline'` | `<MagnifyingGlassIcon className="w-4 h-4" />` |
| react-icons | `import { FiSearch } from 'react-icons/fi'` | `<FiSearch />` |
| phosphor-react | `import { Search } from 'phosphor-react'` | `<Search size={16} />` |
| Custom SVG | `import { SearchIcon } from '@/icons'` | `<SearchIcon />` |

### Icon mapping format:

```
Design: Search icon (magnifying glass, 16px)
Codebase: lucide-react
Mapping: ✅ Search from lucide-react, size={16}
```

## Layout Mapping

### Flex layouts:

```
Design: Row of 3 items, vertically centered, 16px gap
Mapping:
  display: flex
  alignItems: center
  gap: spacing-4 (16px)
  Children: [Item1, Item2, Item3]
```

### Grid layouts:

```
Design: 3-column grid, 24px gap, responsive → 1 column on mobile
Mapping:
  display: grid
  gridTemplateColumns: repeat(3, 1fr)
  gap: spacing-6 (24px)
  Responsive: grid-cols-1 @mobile, grid-cols-3 @desktop
```

## Visual Fidelity Priority

Use this order when constraints conflict:

1. Confirmed Figma values or calibrated screenshot measurements.
2. Exact project tokens/components.
3. Explicit custom overrides on existing components.
4. New missing component or token.
5. Nearest-token approximation only after human confirmation.

For every third-party component mapping, document visual overrides separately from functional props.
Example:

```text
antd Select
Functional props: value, options, onChange
Visual contract: 42px height, 12px radius, 160px width, 16px label
Required overrides: selector height, alignment, border color, horizontal padding
```

### Page layouts:

```
Design: Sidebar (240px) + Main content area
Mapping:
  Layout: SidebarLayout
  sidebarWidth: 240px
  sidebar: <Sidebar />
  main: <PageContent />
```

---
name: create-page
description: Create new pages in Vite projects with react-generate-pages plugin. Auto-detect existing layouts, asks user which layout to use, creates correct page.tsx, layout.tsx, scss module files following project patterns. Trigger phrases create page add page new route generate page make new page
allowed-tools: Glob, Read, Write, Edit, AskUserQuestion, Bash
---

# 📄 Skill: Create Page

## 🔒 IRON LAW - NEVER SKIP
✅ **MANDATORY ORDER:**
1. Check plugin setup
2. Check existing patterns
3. **ASK USER FIRST** (layout, style, pattern)
4. **CREATE LAYOUT FIRST** → only after create page
5. Verify all TypeScript errors before reporting done

❌ **CRITICAL:** Never create page files before layout is ready.
❌ **CRITICAL:** Never auto-select layout without asking user.

---

## 📋 Workflow Checklist

```
✅ Progress:

- [ ] Step 0: Verify plugin setup ⛔ BLOCKING
  - [ ] 0.1 Check if react-generate-pages is installed
  - [ ] 0.2 Check if plugin is configured in vite.config.ts
  - [ ] 0.3 Check if vite-env.d.ts has type reference
  - [ ] 0.4 Check if main.tsx is setup correctly
  - [ ] 0.5 If not setup: RUN FULL AUTOMATIC SETUP FIRST
- [ ] Step 1: Analyze existing project ⛔ BLOCKING
  - [ ] 1.1 Check if src/pages/ directory exists
  - [ ] 1.2 Check if src/layouts/ directory exists
  - [ ] 1.3 Scan all existing pages to understand the pattern
  - [ ] 1.4 List all available layouts
  - [ ] 1.5 CONFIRM PATTERN: using `export function Component()` or default export
- [ ] Step 2: Confirm with user ⚠️ **MANDATORY, NEVER SKIP. BLOCKS ALL NEXT STEPS.**
  - [ ] 2.1 ✅ **ALWAYS ASK:** "Where would you like layout to be placed?"
        > 1. Shared layout at src/layouts/ (Recommended)
        > 2. Per-page layout inside page directory
        > 3. No layout
  - [ ] 2.2 Confirm layout name user wants to use
  - [ ] 2.3 Confirm styling method: css / scss module / tailwind
  - [ ] 2.4 Confirm export pattern: `export function Component()` or default
- [ ] Step 3: Generate files in correct order
  - [ ] 3.1 ✅ **CREATE LAYOUT FIRST** at src/layouts/ if does not exist
  - [ ] 3.2 Create directory src/pages/[page-slug]/
  - [ ] 3.3 Generate page.tsx matching existing pattern
  - [ ] 3.4 Generate layout.tsx reference inside page
  - [ ] 3.5 Generate styles module file
- [ ] Step 4: Verify and report
  - [ ] 4.1 Verify filenames match convention
  - [ ] 4.2 Run TypeScript check, ensure no import errors
  - [ ] 4.3 Confirm automatic routing is working
  - [ ] 4.4 Print full paths and generated route
```

---

## 🚀 Step 0: Verify `react-generate-pages` setup

### IF PLUGIN NOT FULLY SETUP:
✅ **AUTOMATIC FULL SETUP SEQUENCE:**
👉 **DELEGATE TO DEDICATED SKILL:** Always invoke skill `react-generate-pages` to handle full setup. Do NOT implement setup manually here.

> `Skill: react-generate-pages` will handle:
> - Install package
> - Configure vite.config.ts correctly
> - Setup vite-env.d.ts types
> - Update main.tsx with RouterProvider
> - Install react-router-dom
> - Verify everything works

**Never duplicate setup logic here. Always reference the single source of truth skill.**

---

## 🚀 Step 1: Analyze existing project

Run these commands FIRST:

```bash
# Check pages structure
glob "src/pages/**/*.tsx"

# Check layouts structure
glob "src/layouts/**/*.tsx"

# Read an example page to understand the pattern
read src/pages/*/page.tsx | head -30
```

Answer these questions:
1. Is `react-generate-pages` being used?
2. What is the current pattern? (`export function Component()`? default export?)
3. What layouts are already available?
4. Are they using scss modules, plain css, or tailwind?
5. Do they use `@/` alias or relative paths for imports?

---

## 🎯 Step 2: Confirm with user

### ✅ Always ask all choices before creating any files:
Use `AskUserQuestion`:
> ✅ Please confirm these choices before creating page:
>
> 🔹 Layout location:
> - Shared layout at src/layouts/ (Recommended)
> - Per-page layout inside page directory
> - No layout
>
> 🔹 Styling method:
> - CSS Modules
> - Plain CSS
> - Tailwind CSS

❌ **STRICTLY FORBIDDEN:** Create any file before user confirms all choices.

---

## 📝 Step 3: Generate files following standard

### 🔍 Standard Pattern for react-generate-pages:

```
src/
├── layouts/
│   ├── AuthLayout.tsx
│   ├── AuthLayout.module.css
│   ├── MainLayout.tsx
│   └── MainLayout.module.css
└── pages/
    ├── login/
    │   ├── page.tsx          ✅ export function Component()
    │   ├── page.module.css
    │   └── layout.tsx        ✅ return <Layout /> JSX
    └── dashboard/
        ├── page.tsx
        ├── page.module.css
        └── layout.tsx
```

#### ✅ Standard page.tsx:
```tsx
// ✅ Use named export function Component() NOT default export
import styles from './page.module.css';

export function Component() {
  return (
    <div>
      <h1>Page Title</h1>
    </div>
  );
}
```

#### ✅ Standard layout component (at src/layouts/):
```tsx
// ✅ ALWAYS use <Outlet /> from react-router-dom. NEVER accept children prop!
import { Outlet } from 'react-router-dom';
import styles from './AuthLayout.module.css';

export function AuthLayout() {
  return (
    <div className={styles.container}>
      <Outlet /> {/* 👈 THIS IS MANDATORY */}
    </div>
  );
}
```

#### ✅ Standard page layout.tsx (inside page directory):
```tsx
// ✅ Do NOT export default, do NOT pass children. Just return layout element.
import { AuthLayout } from '@/layouts/AuthLayout';

export function Component() {
  return <AuthLayout />;
}
```

---

## ❌ Anti-Patterns - STRICTLY FORBIDDEN ❌

❌ **🔴 MOST COMMON MISTAKE:** NEVER add `children` prop to layouts. Always use `<Outlet />` only!
❌ **DO NOT** use `export default` for page and layout - this was old plugin pattern
❌ **DO NOT** return function reference in layout `return AuthLayout` → must return `<AuthLayout />`
❌ **DO NOT** pass children to layouts `<Layout>{children}</Layout>` → this is always wrong!
❌ **DO NOT** create page before layout is completed
❌ **DO NOT** auto select layout without asking user
❌ **DO NOT** create `index.tsx` - must be `page.tsx`
❌ **DO NOT** forget to check TypeScript errors after generation
❌ **🔴 CRITICAL:** Never create any files before getting user confirmation.

---

## ✅ Pre-Delivery Checklist

Before reporting completion, verify all items:

- [ ] Directory name is lowercase kebab-case slug
- [ ] Exact filenames `page.tsx` and `layout.tsx` are used
- [ ] All pages and layouts use correct export pattern
- [ ] Page layout returns actual JSX `<Layout />` element
- [ ] No TypeScript import errors
- [ ] `vite-env.d.ts` has correct type reference
- [ ] `main.tsx` is setup with `~pages` import
- [ ] No dead code, leftover console.log
- [ ] 100% matches pattern of existing pages in project

---

## 📌 Official Route Style Standard 🔥

✅ FOLLOW THIS 100% ALWAYS:

| File / Directory | Route Behaviour |
|---|---|
| `layout.tsx` | Layout page |
| `page.tsx` | Index page |
| `404.tsx` | Not found page |
| `_folder/` | Private folder (underscore prefix, not exposed as route) |
| `(layout)/` | Layout Routes - no path segment |
| `[id]/` | `:id` - Dynamic Segments |
| `[[id]]/` | `:id?` - Optional Segments |
| `[...slug]/` | `*` - Splats / Catch all |
| `{task}/` | `task?` - Optional Static Segments |

✅ Generated routes examples:
- `src/pages/dashboard/page.tsx` → `/dashboard` route
- `src/pages/settings/profile/page.tsx` → `/settings/profile` route
- `src/pages/posts/[id]/page.tsx` → `/posts/:id` route
- `src/pages/(auth)/login/page.tsx` → `/login` route

✅ Virtual module `~pages` is auto generated, do not look for physical file

✅ You don't need to edit any routing files - plugin handles everything automatically.

✅ After generation, report back with full paths:
> ✅ Page created successfully!
> 📁 Generated files:
> - src/layouts/LayoutName.tsx
> - src/layouts/LayoutName.module.css
> - src/pages/[slug]/page.tsx
> - src/pages/[slug]/layout.tsx
> - src/pages/[slug]/page.module.css
>
> 🔗 Automatic route: `http://localhost:5173/[slug]`

---

## 🧠 Lessons Learned From Real Errors
- ❌ Old wrong docs said use `children` prop on layouts → ✅ Correct: ALWAYS use `<Outlet />` from react-router-dom
- ❌ Old wrong docs said use `export default` → ✅ Correct: `export function Component()`
- ❌ Layout returned function reference → ✅ Correct: return JSX `<Component />`
- ❌ Created page before layout → ✅ Correct: layout first, page second
- ❌ Skipped user confirmation → ✅ Correct: ask all choices first
- ❌ Skipped TypeScript check → ✅ Correct: always verify no errors before done

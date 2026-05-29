---
name: react-generate-pages
description: Automatically generate React Router routes from a file system structure. Use this skill to create a dynamic routing system based on your project's folder and file organization. This skill simplifies route management by allowing you to define routes through your file structure, supporting features like nested routes, dynamic segments, and layout components.
---

## 📦 Installation


```bash
npm install react-generate-pages -D
```

```
npm install react-router-dom
```

## 🦄 Usage

### Configuration Vite

```ts
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import pages from 'react-generate-pages'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), pages()],
})
```

## Overview

By default a page is a
[React Router lazy component](https://reactrouter.com/en/main/route/lazy)
exported from a `.tsx`, `.jsx`, `.ts`, `.js` file in the `src/pages` directory.

You can access the generated routes by importing the `~pages` module in your
application.

```tsx
import ReactDOM from 'react-dom/client'
import { RouterProvider, createBrowserRouter } from 'react-router-dom'

import routes from '~pages'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <RouterProvider router={createBrowserRouter(routes)} />
)
```

**Type**

```ts
// vite-env.d.ts
/// <reference types="react-generate-pages/client" />
```

## Route Style

- `layout.{tsx,jsx,ts,js}` => layout page
- `page.{tsx,jsx,ts,js}` => index page
- `404.{tsx,jsx,ts,js}` => not found page
- `_lib` => private folder (underscore prefix)
- `(layout)` =>
  [Layout Routes](https://reactrouter.com/en/main/route/route#layout-routes)
- `[id]` => `:id`
  [Dynamic Segments](https://reactrouter.com/en/main/route/route#dynamic-segments)
- `[[id]]` => `:id?`
  [Optional Segments](https://reactrouter.com/en/main/route/route#optional-segments)
- `[...slug]` => `*`
  [Splats](https://reactrouter.com/en/main/route/route#splats)
- `{task}` => `task?`
  [Optional Static Segments](https://reactrouter.com/en/main/route/route#dynamic-segments)

**Example:**

```bash
# folder structure
src/pages/
├── (dashboard)
│   ├── [...slug]
│   │   └── page.tsx
│   ├── posts
│   │   ├── [id]
│   │   │   └── page.tsx
│   │   └── page.tsx
│   ├── layout.tsx
│   └── page.tsx
├── about
│   └── [[lang]]
│       └── page.tsx
├── 404.tsx
├── layout.tsx
└── page.tsx
```


## `page.tsx` template

```tsx
export function Component() {
  return (
    <div>
      {/* TODO: implement $ARGUMENTS page */}
    </div>
  );
}
```

## `layout.tsx` template (only when needed)

```tsx
import { Outlet } from 'react-router-dom';

export function Component() {
  return (
    <div>
      <Outlet />
    </div>
  );
}
```

## Conventions

- Named `Component` export — never default exports
- Use `@/*` alias for all imports from `src/`
- Use `cn()` from `@/lib/utils` for conditional class merging
- Tailwind for layout; antd for complex UI elements
- Single quotes, 100-char width (Oxfmt)
- Import order: builtin → external → internal (`@/*`) → relative → styles

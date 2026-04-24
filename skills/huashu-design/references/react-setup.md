# React + Babel Project Standards

Technical specifications that must be followed when building prototypes with HTML+React+Babel. Things will break if you don't comply.

## Pinned Script Tags（Must use these versions）

Place these three script tags in the `<head>` of your HTML, using **fixed versions + integrity hashes**:

```html
<script src="https://unpkg.com/react@18.3.1/umd/react.development.js" integrity="sha384-hD6/rw4ppMLGNu3tX5cjIb+uRZ7UkRJ6BPkLpg4hAu/6onKUg4lLsHAs9EBPT82L" crossorigin="anonymous"></script>
<script src="https://unpkg.com/react-dom@18.3.1/umd/react-dom.development.js" integrity="sha384-u6aeetuaXnQ38mYT8rp6sbXaQe3NL9t+IBXmnYxwkUI2Hw4bsp2Wvmx4yRQF1uAm" crossorigin="anonymous"></script>
<script src="https://unpkg.com/@babel/standalone@7.29.0/babel.min.js" integrity="sha384-m08KidiNqLdpJqLq95G/LEi8Qvjl/xUYll3QILypMoQ65QorJ9Lvtp2RXYGBFj1y" crossorigin="anonymous"></script>
```

**Do not** use unpinned versions like `react@18` or `react@latest` — this will cause version drift/cache issues.

**Do not** omit `integrity` — if the CDN is hijacked or tampered with, this is your line of defense.

## File Structure

```
project-name/
├── index.html               # Main HTML
├── components.jsx           # Component files (loaded with type="text/babel")
├── data.js                  # Data file
└── styles.css               # Additional CSS (optional)
```

Loading method in HTML:

```html
<!-- First React+Babel -->
<script src="https://unpkg.com/react@18.3.1/..."></script>
<script src="https://unpkg.com/react-dom@18.3.1/..."></script>
<script src="https://unpkg.com/@babel/standalone@7.29.0/..."></script>

<!-- Then your component files -->
<script type="text/babel" src="components.jsx"></script>
<script type="text/babel" src="pages.jsx"></script>

<!-- Finally main entry -->
<script type="text/babel">
  const root = ReactDOM.createRoot(document.getElementById('root'));
  root.render(<App />);
</script>
```

**Do not** use `type="module"` — it conflicts with Babel.

## Three Non-Negotiable Rules

### Rule 1: styles Objects Must Use Unique Naming

**Incorrect** (will break with multiple components):
```jsx
// components.jsx
const styles = { button: {...}, card: {...} };

// pages.jsx  ← Same name override!
const styles = { container: {...}, header: {...} };
```

**Correct**: Each component file's styles should use a unique prefix.

```jsx
// terminal.jsx
const terminalStyles = { 
  screen: {...}, 
  line: {...} 
};

// sidebar.jsx
const sidebarStyles = { 
  container: {...}, 
  item: {...} 
};
```

**Or use inline styles** (recommended for small components):
```jsx
<div style={{ padding: 16, background: '#111' }}>...</div>
```

This rule is **non-negotiable**. Every time you write `const styles = {...}`, you must replace it with a specific naming, otherwise you'll get full-stack errors when loading multiple components.

### Rule 2: Scope Is Not Shared, Manual Export Required

**Key understanding**: Each `<script type="text/babel">` is compiled independently by Babel, and **scope does not communicate between them**. The `Terminal` component defined in `components.jsx` is **undefined by default** in `pages.jsx`.

**Solution**: At the end of each component file, export the components/utilities you want to share to `window`:

```jsx
// components.jsx end
function Terminal(props) { ... }
function Line(props) { ... }
const colors = { green: '#...', red: '#...' };

Object.assign(window, {
  Terminal, Line, colors,
  // List everything you want to use elsewhere here
});
```

Then `pages.jsx` can directly use `<Terminal />` because JSX will look for `window.Terminal`.

### Rule 3: Do Not Use scrollIntoView

`scrollIntoView` will push the entire HTML container upward, breaking the web harness layout. **Never use it**.

Alternative approach:
```js
// Scroll to a position within the container
container.scrollTop = targetElement.offsetTop;

// Or use element.scrollTo
container.scrollTo({
  top: targetElement.offsetTop - 100,
  behavior: 'smooth'
});
```

## Calling Claude API (within HTML)

Some native design-agent environments (like Claude.ai Artifacts) have a configuration-free `window.claude.complete`, but most agent environments (Claude Code / Codex / Cursor / Trae / etc.) locally **do not have it**.

If your HTML prototype needs to call an LLM for a demo (like building a chat interface), you have two options:

### Option A: Don't Actually Call, Use Mock

Recommended for demo scenarios. Write a fake helper that returns a preset response:
```jsx
window.claude = {
  async complete(prompt) {
    await new Promise(r => setTimeout(r, 800)); // Simulate delay
    return "This is a mock response. Please replace with real API when deploying.";
  }
};
```

### Option B: Actually Call Anthropic API

Requires an API key, users must fill in their own key in the HTML for it to work. **Never hardcode the key in HTML**.

```html
<input id="api-key" placeholder="Paste your Anthropic API key" />
<script>
window.claude = {
  async complete(prompt) {
    const key = document.getElementById('api-key').value;
    const res = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': key,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-haiku-4-5',
        max_tokens: 1024,
        messages: [{ role: 'user', content: prompt }]
      })
    });
    const data = await res.json();
    return data.content[0].text;
  }
};
</script>
```

**Note**: Direct browser calls to Anthropic API will encounter CORS issues. If the preview environment provided by the user doesn't support CORS bypass, this path won't work. In that case, use Option A mock, or tell the user they need a proxy backend.

### Option C: Use Agent-Side LLM Capabilities to Generate Mock Data

If it's just for local demo purposes, you can temporarily call that agent's LLM capability in the current agent session (or a multi-model skill installed by the user) to first generate mock response data, then hardcode it into the HTML. This way, the HTML doesn't depend on any API at runtime.

## Typical HTML Starter Template

Copy this template as the skeleton for your React prototype:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Prototype Name</title>

  <!-- React + Babel pinned -->
  <script src="https://unpkg.com/react@18.3.1/umd/react.development.js" integrity="sha384-hD6/rw4ppMLGNu3tX5cjIb+uRZ7UkRJ6BPkLpg4hAu/6onKUg4lLsHAs9EBPT82L" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/react-dom@18.3.1/umd/react-dom.development.js" integrity="sha384-u6aeetuaXnQ38mYT8rp6sbXaQe3NL9t+IBXmnYxwkUI2Hw4bsp2Wvmx4yRQF1uAm" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/@babel/standalone@7.29.0/babel.min.js" integrity="sha384-m08KidiNqLdpJqLq95G/LEi8Qvjl/xUYll3QILypMoQ65QorJ9Lvtp2RXYGBFj1y" crossorigin="anonymous"></script>

  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { height: 100%; width: 100%; }
    body { 
      font-family: -apple-system, 'SF Pro Text', sans-serif;
      background: #FAFAFA;
      color: #1A1A1A;
    }
    #root { min-height: 100vh; }
  </style>
</head>
<body>
  <div id="root"></div>

  <!-- Your component files -->
  <script type="text/babel" src="components.jsx"></script>

  <!-- Main entry -->
  <script type="text/babel">
    const { useState, useEffect } = React;

    function App() {
      return (
        <div style={{padding: 40}}>
          <h1>Hello</h1>
        </div>
      );
    }

    const root = ReactDOM.createRoot(document.getElementById('root'));
    root.render(<App />);
  </script>
</body>
</html>
```

## Common Errors and Solutions

**`styles is not defined` or `Cannot read property 'button' of undefined`**
→ You defined `const styles` in one file, and another file overwrote it. Change each one to a specific naming.

**`Terminal is not defined`**
→ Scope doesn't communicate when referencing across files. Add `Object.assign(window, {Terminal})` at the end of the file where Terminal is defined.

**Entire page is white screen, no errors in console**
→ Most likely a JSX syntax error but Babel didn't report it in the console. Temporarily replace `babel.min.js` with `babel.js` non-compressed version for clearer error messages.

**ReactDOM.createRoot is not a function**
→ Wrong version. Confirm you're using react-dom@18.3.1 (not 17 or others).

**`Objects are not valid as a React child`**
→ You rendered an object instead of JSX/string. Usually meant `{someObj.name}` but wrote `{someObj}`.

## How to Split Files for Large Projects

**Single file with >1000 lines** is hard to maintain. Splitting approach:

```
project/
├── index.html
├── src/
│   ├── primitives.jsx      # Basic elements: Button, Card, Badge...
│   ├── components.jsx      # Business components: UserCard, PostList...
│   ├── pages/
│   │   ├── home.jsx        # Home page
│   │   ├── detail.jsx      # Detail page
│   │   └── settings.jsx    # Settings page
│   ├── router.jsx          # Simple routing (React state switching)
│   └── app.jsx             # Entry component
└── data.js                 # mock data
```

Load in order in HTML:
```html
<script type="text/babel" src="src/primitives.jsx"></script>
<script type="text/babel" src="src/components.jsx"></script>
<script type="text/babel" src="src/pages/home.jsx"></script>
<script type="text/babel" src="src/pages/detail.jsx"></script>
<script type="text/babel" src="src/pages/settings.jsx"></script>
<script type="text/babel" src="src/router.jsx"></script>
<script type="text/babel" src="src/app.jsx"></script>
```

**At the end of each file**, you must `Object.assign(window, {...})` to export things you want to share.

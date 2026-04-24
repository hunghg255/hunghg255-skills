# Tweaks: Real-time Design Variation Parameter Adjustment

Tweaks are a core capability of this skill — enabling users to switch between variations or adjust parameters in real-time without modifying code.

**Cross-agent environment adaptation**: Some design-agent native environments (such as Claude.ai Artifacts) rely on the host's postMessage to write tweak values back to source code for persistence. This skill adopts a **pure frontend localStorage solution** — the effect is consistent (state persists across refreshes), but persistence occurs in the browser's localStorage rather than source code files. This solution works in any agent environment (Claude Code / Codex / Cursor / Trae / etc.).

## When to Add Tweaks

- User explicitly requests "parameter adjustment capability" / "switching between multiple versions"
- When a design has multiple variations that need comparison
- User doesn't explicitly state it, but you subjectively determine that **adding a few insightful tweaks can help users see possibilities**

Default recommendation: **Add 2-3 tweaks to every design** (color themes / font size / layout variations) even if the user doesn't request it — showing users the space of possibilities is part of design service.

## Implementation (Pure Frontend Version)

### Basic Structure

```jsx
const TWEAK_DEFAULTS = {
  "primaryColor": "#D97757",
  "fontSize": 16,
  "density": "comfortable",
  "dark": false
};

function useTweaks() {
  const [tweaks, setTweaks] = React.useState(() => {
    try {
      const stored = localStorage.getItem('design-tweaks');
      return stored ? { ...TWEAK_DEFAULTS, ...JSON.parse(stored) } : TWEAK_DEFAULTS;
    } catch {
      return TWEAK_DEFAULTS;
    }
  });

  const update = (patch) => {
    const next = { ...tweaks, ...patch };
    setTweaks(next);
    try {
      localStorage.setItem('design-tweaks', JSON.stringify(next));
    } catch {}
  };

  const reset = () => {
    setTweaks(TWEAK_DEFAULTS);
    try {
      localStorage.removeItem('design-tweaks');
    } catch {}
  };

  return { tweaks, update, reset };
}
```

### Tweaks Panel UI

Floating panel in the bottom-right corner. Collapsible:

```jsx
function TweaksPanel() {
  const { tweaks, update, reset } = useTweaks();
  const [open, setOpen] = React.useState(false);

  return (
    <div style={{
      position: 'fixed',
      bottom: 20,
      right: 20,
      zIndex: 9999,
    }}>
      {open ? (
        <div style={{
          background: 'white',
          border: '1px solid #e5e5e5',
          borderRadius: 12,
          padding: 20,
          boxShadow: '0 10px 40px rgba(0,0,0,0.12)',
          width: 280,
          fontFamily: 'system-ui',
          fontSize: 13,
        }}>
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: 16,
          }}>
            <strong>Tweaks</strong>
            <button onClick={() => setOpen(false)} style={{
              border: 'none', background: 'none', cursor: 'pointer', fontSize: 16,
            }}>×</button>
          </div>

          {/* Color */}
          <label style={{ display: 'block', marginBottom: 12 }}>
            <div style={{ marginBottom: 4, color: '#666' }}>Primary Color</div>
            <input
              type="color"
              value={tweaks.primaryColor}
              onChange={e => update({ primaryColor: e.target.value })}
              style={{ width: '100%', height: 32 }}
            />
          </label>

          {/* Font size slider */}
          <label style={{ display: 'block', marginBottom: 12 }}>
            <div style={{ marginBottom: 4, color: '#666' }}>Font Size ({tweaks.fontSize}px)</div>
            <input
              type="range"
              min={12} max={24} step={1}
              value={tweaks.fontSize}
              onChange={e => update({ fontSize: +e.target.value })}
              style={{ width: '100%' }}
            />
          </label>

          {/* Density option */}
          <label style={{ display: 'block', marginBottom: 12 }}>
            <div style={{ marginBottom: 4, color: '#666' }}>Density</div>
            <select
              value={tweaks.density}
              onChange={e => update({ density: e.target.value })}
              style={{ width: '100%', padding: 6 }}
            >
              <option value="compact">Compact</option>
              <option value="comfortable">Comfortable</option>
              <option value="spacious">Spacious</option>
            </select>
          </label>

          {/* Dark mode toggle */}
          <label style={{
            display: 'flex',
            alignItems: 'center',
            gap: 8,
            marginBottom: 16,
          }}>
            <input
              type="checkbox"
              checked={tweaks.dark}
              onChange={e => update({ dark: e.target.checked })}
            />
            <span>Dark Mode</span>
          </label>

          <button onClick={reset} style={{
            width: '100%',
            padding: '8px 12px',
            background: '#f5f5f5',
            border: 'none',
            borderRadius: 6,
            cursor: 'pointer',
            fontSize: 12,
          }}>Reset</button>
        </div>
      ) : (
        <button
          onClick={() => setOpen(true)}
          style={{
            background: '#1A1A1A',
            color: 'white',
            border: 'none',
            borderRadius: 999,
            padding: '10px 16px',
            fontSize: 12,
            cursor: 'pointer',
            boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
          }}
        >⚙ Tweaks</button>
      )}
    </div>
  );
}
```

### Applying Tweaks

Use Tweaks in the main component:

```jsx
function App() {
  const { tweaks } = useTweaks();

  return (
    <div style={{
      '--primary': tweaks.primaryColor,
      '--font-size': `${tweaks.fontSize}px`,
      background: tweaks.dark ? '#0A0A0A' : '#FAFAFA',
      color: tweaks.dark ? '#FAFAFA' : '#1A1A1A',
    }}>
      {/* Your content */}
      <TweaksPanel />
    </div>
  );
}
```

Use variables in CSS:

```css
button.cta {
  background: var(--primary);
  color: white;
  font-size: var(--font-size);
}
```

## Typical Tweak Options

What tweaks to add for different design types:

### Universal
- Primary color (color picker)
- Font size (slider 12-24px)
- Font family (select: display font vs body font)
- Dark mode (toggle)

### Slide Deck
- Theme (light/dark/brand)
- Background style (solid/gradient/image)
- Font contrast (more decorative vs more restrained)
- Information density (minimal/standard/dense)

### Product Prototype
- Layout variant (layout A / B / C)
- Interaction speed (animation speed 0.5x-2x)
- Data volume (mock data item count 5/20/100)
- State (empty/loading/success/error)

### Animation
- Speed (0.5x-2x)
- Loop (once/loop/ping-pong)
- Easing (linear/easeOut/spring)

### Landing Page
- Hero style (image/gradient/pattern/solid)
- CTA copy (several variants)
- Structure (single column / two column / sidebar)

## Tweaks Design Principles

### 1. Meaningful Options, Not Frustrating Ones

Each tweak must present **real design options**. Don't add tweaks that no one would actually switch (like a border-radius 0-50px slider — users find that all intermediate values look ugly).

Good tweaks expose **discrete, thoughtful variations**:
- "Corner style": No corners / Slightly rounded / Large rounded (three options)
- Not: "Corner radius": 0-50px slider

### 2. Less is More

A design's Tweaks panel should have **at most 5-6** options. More than that becomes a "configuration page", losing the meaning of quickly exploring variations.

### 3. Default Value is a Completed Design

Tweaks are **icing on the cake**. The default value must itself be a complete, publishable design. What users see when they close the Tweaks panel is the output.

### 4. Logical Grouping

When there are many options, display them in groups:

```
---- Visual ----
Primary Color | Font Size | Dark Mode

---- Layout ----
Density | Sidebar Position

---- Content ----
Display Data Count | State
```

## Forward Compatibility with Source-Level Persistence Hosts

If you later want to upload designs to environments that support source-level tweaks (such as Claude.ai Artifacts), preserve the **EDITMODE marker block**:

```jsx
const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "primaryColor": "#D97757",
  "fontSize": 16,
  "density": "comfortable",
  "dark": false
}/*EDITMODE-END*/;
```

The marker block **has no effect** in the localStorage solution (it's just a regular comment), but in hosts that support source code write-back, it will be read to implement source-level persistence. Adding this is harmless to the current environment while maintaining forward compatibility.

## Common Questions

**Tweaks panel blocks design content**
→ Make it closable. Default to closed, showing a small button that users click to expand.

**Users still need to repeat settings after switching tweaks**
→ Already using localStorage. If it doesn't persist after refresh, check if localStorage is available (it fails in incognito mode, need to catch).

**Multiple HTML pages want to share tweaks**
→ Add project name to localStorage key: `design-tweaks-[projectName]`.

**I want tweaks to have interdependency relationships**
→ Add logic in `update`:

```jsx
const update = (patch) => {
  let next = { ...tweaks, ...patch };
  // Interdependency: automatically switch font color when selecting dark mode
  if (patch.dark === true && !patch.textColor) {
    next.textColor = '#F0EEE6';
  }
  setTweaks(next);
  localStorage.setItem(...);
};
```

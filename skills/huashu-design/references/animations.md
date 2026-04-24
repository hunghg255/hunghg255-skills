# Animations: Timeline Animation Engine

Read this when working on animation/motion design HTML. Principles, usage, typical patterns.

## Core Pattern: Stage + Sprite

Our animation system (`assets/animations.jsx`) provides a timeline-driven engine:

- **`<Stage>`**: Container for the entire animation, automatically provides auto-scale (fit viewport) + scrubber + play/pause/loop controls
- **`<Sprite start end>`**: Time segment. A Sprite only displays during the `start` to `end` time period. Internally can read its own local progress `t` (0→1) via the `useSprite()` hook
- **`useTime()`**: Read current global time (seconds)
- **`Easing.easeInOut` / `Easing.easeOut` / ...**: Easing functions
- **`interpolate(t, from, to, easing?)`**: Interpolate based on t

This pattern borrows from Remotion/After Effects concepts, but is lightweight and zero-dependency.

## Getting Started

```html
<script type="text/babel" src="animations.jsx"></script>
<script type="text/babel">
  const { Stage, Sprite, useTime, useSprite, Easing, interpolate } = window.Animations;

  function Title() {
    const { t } = useSprite();  // Local progress 0→1
    const opacity = interpolate(t, [0, 1], [0, 1], Easing.easeOut);
    const y = interpolate(t, [0, 1], [40, 0], Easing.easeOut);
    return (
      <h1 style={{
        opacity,
        transform: `translateY(${y}px)`,
        fontSize: 120,
        fontWeight: 900,
      }}>
        Hello.
      </h1>
    );
  }

  function Scene() {
    return (
      <Stage duration={10}>  {/* 10 second animation */}
        <Sprite start={0} end={3}>
          <Title />
        </Sprite>
        <Sprite start={2} end={5}>
          <SubTitle />
        </Sprite>
        {/* ... */}
      </Stage>
    );
  }

  const root = ReactDOM.createRoot(document.getElementById('root'));
  root.render(<Scene />);
</script>
```

## Common Animation Patterns

### 1. Fade In / Fade Out

```jsx
function FadeIn({ children }) {
  const { t } = useSprite();
  const opacity = interpolate(t, [0, 0.3], [0, 1], Easing.easeOut);
  return <div style={{ opacity }}>{children}</div>;
}
```

**Note the range**: `[0, 0.3]` means complete fade-in during the first 30% of the sprite time, then keep opacity=1 for the remainder.

### 2. Slide In

```jsx
function SlideIn({ children, from = 'left' }) {
  const { t } = useSprite();
  const progress = interpolate(t, [0, 0.4], [0, 1], Easing.easeOut);
  const offset = (1 - progress) * 100;
  const directions = {
    left: `translateX(-${offset}px)`,
    right: `translateX(${offset}px)`,
    top: `translateY(-${offset}px)`,
    bottom: `translateY(${offset}px)`,
  };
  return (
    <div style={{
      transform: directions[from],
      opacity: progress,
    }}>
      {children}
    </div>
  );
}
```

### 3. Character-by-Character Typewriter

```jsx
function Typewriter({ text }) {
  const { t } = useSprite();
  const charCount = Math.floor(text.length * Math.min(t * 2, 1));
  return <span>{text.slice(0, charCount)}</span>;
}
```

### 4. Number Counting

```jsx
function CountUp({ from = 0, to = 100, duration = 0.6 }) {
  const { t } = useSprite();
  const progress = interpolate(t, [0, duration], [0, 1], Easing.easeOut);
  const value = Math.floor(from + (to - from) * progress);
  return <span>{value.toLocaleString()}</span>;
}
```

### 5. Segmented Explanation (Typical Teaching Animation)

```jsx
function Scene() {
  return (
    <Stage duration={20}>
      {/* Phase 1: Show problem */}
      <Sprite start={0} end={4}>
        <Problem />
      </Sprite>

      {/* Phase 2: Show approach */}
      <Sprite start={4} end={10}>
        <Approach />
      </Sprite>

      {/* Phase 3: Show result */}
      <Sprite start={10} end={16}>
        <Result />
      </Sprite>

      {/* Caption visible throughout */}
      <Sprite start={0} end={20}>
        <Caption />
      </Sprite>
    </Stage>
  );
}
```

## Easing Functions

Preset easing curves:

| Easing | Characteristics | Use For |
|--------|----------------|---------|
| `linear` | Constant speed | Scrolling captions, continuous animations |
| `easeIn` | Slow→Fast | Exit disappearances |
| `easeOut` | Fast→Slow | Entrance appearances |
| `easeInOut` | Slow→Fast→Slow | Position changes |
| **`expoOut`** ⭐ | **Exponential ease-out** | **Anthropic-level primary easing** (physical weight feel) |
| **`overshoot`** ⭐ | **Elastic bounce-back** | **Toggle / button pop / emphasized interaction** |
| `spring` | Spring | Interaction feedback, geometric object return |
| `anticipation` | Reverse then forward | Emphasized action |

**Default primary easing should be `expoOut`** (not `easeOut`) — see `animation-best-practices.md` §2.
Use `expoOut` for entrances, `easeIn` for exits, `overshoot` for toggles — fundamental pattern for Anthropic-level animations.

## Timing and Duration Guidelines

### Micro-interactions (0.1-0.3 seconds)
- Button hover
- Card expand
- Tooltip appearance

### UI Transitions (0.3-0.8 seconds)
- Page transitions
- Modal appearance
- List item addition

### Narrative Animations (2-10 seconds per segment)
- One phase of concept explanation
- Data chart reveal
- Scene transitions

### Single narrative animation segments should not exceed 10 seconds
Human attention is limited. Cover one thing in 10 seconds, then move to the next.

## Design Thinking Sequence for Animations

### 1. Content/Story First, Then Animation

**Wrong**: Start with fancy animation ideas, then force content into them
**Right**: Think clearly about what message to convey, then use animation to serve that message

Animation is a **signal**, not **decoration**. A fade-in says "this is important, please look" — if everything fades in, the signal becomes ineffective.

### 2. Write Timeline by Scene

```
0:00 - 0:03   Problem appears (fade in)
0:03 - 0:06   Problem expands/zooms (zoom+pan)
0:06 - 0:09   Solution appears (slide in from right)
0:09 - 0:12   Solution elaborates (typewriter)
0:12 - 0:15   Result demonstration (counter up + chart reveal)
0:15 - 0:18   Summary sentence (static, read for 3 seconds)
0:18 - 0:20   CTA or fade out
```

Write the timeline before writing components.

### 3. Resources First

Prepare images/icons/fonts that will be used in the animation **first**. Don't go looking for materials halfway through — breaks the flow.

## Common Issues

**Animation stuttering**
→ Mainly layout thrashing. Use `transform` and `opacity`, avoid changing `top`/`left`/`width`/`height`/`margin`. Browser GPU accelerates `transform`.

**Animation too fast, unclear**
→ Humans need 100-150ms to read one Chinese character, 300-500ms for a word. If you're telling stories with text, leave at least 3 seconds per sentence.

**Animation too slow, audience bored**
→ Interesting visual changes should be dense. Static images beyond 5 seconds become dull.

**Multiple animations interfering**
→ Use CSS `will-change: transform` to tell the browser in advance that this element will move, reducing reflow.

**Recording to video**
→ Use the skill's built-in toolchain (one command outputs three formats): see `video-export.md`
- `scripts/render-video.js` — HTML → 25fps MP4 (Playwright + ffmpeg)
- `scripts/convert-formats.sh` — 25fps MP4 → 60fps MP4 + optimized GIF
- Want more precise frame rendering? Make render(t) a pure function, see `animation-pitfalls.md` point 5

## Integration with Video Tools

This skill produces **HTML animations** (running in browsers). If the final output needs to be video material:

- **Short animations/concept demos**: Use these methods to make HTML animations → screen recording
- **Long videos/narrative**: This skill focuses on HTML animation, use AI video generation skills or professional video software for long videos
- **Motion graphics**: Professional After Effects/Motion Canvas are more appropriate

## About Popmotion and Similar Libraries

If you really need physics animations (spring, decay, keyframes with precise timing), our engine can't handle it, you can fallback to Popmotion:

```html
<script src="https://unpkg.com/popmotion@11.0.5/dist/popmotion.min.js"></script>
```

But **try our engine first**. 90% of cases it's sufficient.

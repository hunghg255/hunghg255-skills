# Animation Pitfalls：HTML Animation Bugs and Rules

The most common bugs encountered when making animations and how to avoid them. Every rule comes from real failure cases.

Reading this before writing animations will save you one iteration.

## 1. Stacked Layout — `position: relative` is Default Obligation

**Bug encountered**: A sentence-wrap element wrapped 3 bracket-layers (`position: absolute`). Didn't set `position: relative` on sentence-wrap, so the absolute brackets used `.canvas` as their coordinate system and floated 200px off the bottom of the screen.

**Rules**:
- Any container containing `position: absolute` child elements **must** explicitly have `position: relative`
- Even if no visual "offset" is needed, write `position: relative` as the coordinate system anchor
- If you're writing `.parent { ... }` and its children have `.child { position: absolute }`, habitually add relative to parent

**Quick check**: Every time you see a `position: absolute`, count up the ancestors to ensure the nearest positioned ancestor is the coordinate system you *want*.

## 2. Character Traps — Don't Depend on Rare Unicode

**Bug encountered**: Wanted to use `␣` (U+2423 OPEN BOX) to visualize "space token". Noto Serif SC / Cormorant Garamond don't have this glyph, rendering as whitespace/tofu, completely invisible to the audience.

**Rules**:
- **Every character appearing in animations must exist in your chosen font**
- Common rare character blacklist: `␣ ␀ ␐ ␋ ␨ ↩ ⏎ ⌘ ⌥ ⌃ ⇧ ␦ ␖ ␛`
- To express meta-characters like "space / return / tab", use **CSS-constructed semantic boxes**:
  ```html
  <span class="space-key">Space</span>
  ```
  ```css
  .space-key {
    display: inline-flex;
    padding: 4px 14px;
    border: 1.5px solid var(--accent);
    border-radius: 4px;
    font-family: monospace;
    font-size: 0.3em;
    letter-spacing: 0.2em;
    text-transform: uppercase;
  }
  ```
- Emoji must also be validated: some emoji fallback to gray squares in fonts other than Noto Emoji, better to use `emoji` font-family or SVG

## 3. Data-Driven Grid/Flex Templates

**Bug encountered**: Code had `const N = 6` tokens, but CSS hardcoded `grid-template-columns: 80px repeat(5, 1fr)`. The 6th token had no column, entire matrix misaligned.

**Rules**:
- When count comes from a JS array (`TOKENS.length`), CSS templates should also be data-driven
- Solution A: Use CSS variables injected from JS
  ```js
  el.style.setProperty('--cols', N);
  ```
  ```css
  .grid { grid-template-columns: 80px repeat(var(--cols), 1fr); }
  ```
- Solution B: Use `grid-auto-flow: column` to let browser auto-expand
- **Disable "fixed number + JS constant" combinations**, when N changes CSS won't sync

## 4. Transition Gaps — Scene Switches Must Be Continuous

**Bug encountered**: Between zoom1 (13-19s) → zoom2 (19.2-23s), main sentence already hidden, zoom1 fade out (0.6s) + zoom2 fade in (0.6s) + stagger delay (0.2s+) = ~1 second of pure blank screen. Audience thought animation froze.

**Rules**:
- When switching scenes continuously, fade out and fade in must **crossfade**, not wait for previous to fully disappear before starting next
  ```js
  // Bad:
  if (t >= 19) hideZoom('zoom1');      // 19.0s out
  if (t >= 19.4) showZoom('zoom2');    // 19.4s in → 0.4s gap

  // Good:
  if (t >= 18.6) hideZoom('zoom1');    // Start fade out 0.4s early
  if (t >= 18.6) showZoom('zoom2');    // Simultaneously fade in (cross-fade)
  ```
- Or use an "anchor element" (like main sentence) as visual connection between scenes, briefly echo during zoom switch
- Calculate CSS transition duration carefully, avoid triggering next before transition ends

## 5. Pure Render Principle — Animation State Should Be Seekable

**Bug encountered**: Used `setTimeout` + `fireOnce(key, fn)` to chain animation state triggers. Normal playback fine, but when doing frame-by-frame recording/seeking to arbitrary time points, previous setTimeout already executed and couldn't "go back".

**Rules**:
- `render(t)` function should ideally be a **pure function**: given t output unique DOM state
- If side effects are necessary (like class switching), use `fired` set with explicit reset:
  ```js
  const fired = new Set();
  function fireOnce(key, fn) { if (!fired.has(key)) { fired.add(key); fn(); } }
  function reset() { fired.clear(); /* clear all .show classes */ }
  ```
- Expose `window.__seek(t)` for Playwright / debugging:
  ```js
  window.__seek = (t) => { reset(); render(t); };
  ```
- Animation-related setTimeout shouldn't span >1 second, otherwise seek jumps will mess up

## 6. Measuring Before Font Load = Measuring Wrong

**Bug encountered**: Page calls `charRect(idx)` to measure bracket positions immediately on DOMContentLoaded, fonts not loaded yet, each character width is fallback font width, positions all wrong. Once fonts load (~500ms later), bracket's `left: Xpx` still old value, permanently offset.

**Rules**:
- Any layout code depending on DOM measurement (`getBoundingClientRect`, `offsetWidth`) **must** be wrapped in `document.fonts.ready.then()`
  ```js
  document.fonts.ready.then(() => {
    requestAnimationFrame(() => {
      buildBrackets(...);  // Fonts ready now, measurements accurate
      tick();              // Animation starts
    });
  });
  ```
- Extra `requestAnimationFrame` gives browser one frame to commit layout
- If using Google Fonts CDN, `<link rel="preconnect">` to speed initial load

## 7. Recording Prep — Reserve Handles for Video Export

**Bug encountered**: Playwright `recordVideo` defaults to 25fps, starts recording from context creation. Page load, font load first 2 seconds all recorded. Delivery video has 2 seconds blank/flash at front.

**Rules**:
- Provide `render-video.js` tool handling: warmup navigate → reload restart animation → wait duration → ffmpeg trim head + convert to H.264 MP4
- Animation's **frame 0** should be complete initial state with final layout in place (not blank or loading)
- Want 60fps? Use ffmpeg `minterpolate` post-processing, don't rely on browser source frame rate
- Want GIF? Two-stage palette (`palettegen` + `paletteuse`), can compress 30s 1080p animation to 3MB

See `video-export.md` for complete script usage.

## 8. Batch Export — tmp Directory Must Include PID to Prevent Concurrent Conflicts

**Bug encountered**: Used `render-video.js` with 3 processes recording 3 HTMLs in parallel. Because TMP_DIR only named with `Date.now()`, 3 processes starting same millisecond shared same tmp directory. First completed process cleaned tmp, other two read directory got `ENOENT`, all crashed.

**Rules**:
- Any temporary directory potentially shared by multiple processes must be named with **PID or random suffix**:
  ```js
  const TMP_DIR = path.join(DIR, '.video-tmp-' + Date.now() + '-' + process.pid);
  ```
- If you truly want multi-file parallel, use shell `&` + `wait` instead of forking in one node script
- When batch recording multiple HTMLs, conservative approach: run **serially** (2 or fewer can parallel, 3 or more wait in line)

## 9. Progress Bar/Replay Button in Recording — Chrome Elements Pollute Video

**Bug encountered**: Animation HTML added `.progress` progress bar, `.replay` replay button, `.counter` timestamp for human debugging. When recorded to MP4 for delivery, these elements appeared at bottom of video, like developer tools were captured.

**Rules**:
- In HTML, separate "chrome elements" for humans (progress bar / replay button / footer / masthead / counter / phase labels) from video content itself
- **Agreed class name** `.no-record`: any element with this class, recording script automatically hides
- Script side (`render-video.js`) defaults to injecting CSS hiding common chrome class names:
  ```
  .progress .counter .phases .replay .masthead .footer .no-record [data-role="chrome"]
  ```
- Use Playwright's `addInitScript` to inject (takes effect before each navigate, reload also stable)
- Add `--keep-chrome` flag when wanting to see original HTML (with chrome)

## 10. Animation Repeats at Start of Recording — Warmup Frame Leakage

**Bug encountered**: Old `render-video.js` workflow `goto → wait fonts 1.5s → reload → wait duration`. Recording starts from context creation, warmup phase animation already played segment, after reload restarts from 0. Result video first few seconds are "animation mid-segment + switch + animation start from 0", strong repetition feel.

**Rules**:
- **Warmup and Record must use independent contexts**:
  - Warmup context (no `recordVideo` option): only responsible for load url, wait fonts, then close
  - Record context (with `recordVideo`): starts from fresh state, animation records from t=0
- ffmpeg `-ss trim` can only trim Playwright's slight startup latency (~0.3s), **cannot** be used to mask warmup frames; source must be clean
- Recording context close = webm file written to disk, this is Playwright's constraint
- Related code pattern:
  ```js
  // Phase 1: warmup (throwaway)
  const warmupCtx = await browser.newContext({ viewport });
  const warmupPage = await warmupCtx.newPage();
  await warmupPage.goto(url, { waitUntil: 'networkidle' });
  await warmupPage.waitForTimeout(1200);
  await warmupCtx.close();

  // Phase 2: record (fresh)
  const recordCtx = await browser.newContext({ viewport, recordVideo });
  const page = await recordCtx.newPage();
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.waitForTimeout(DURATION * 1000);
  await page.close();
  await recordCtx.close();
  ```

## 11. Don't Draw "Pseudo Chrome" in Frame — Decorative Player UI Collides with Real Chrome

**Bug encountered**: Animation used `Stage` component, already came with scrubber + timecode + pause button (belongs to `.no-record` chrome, automatically hidden on export). I drew a "`00:60 ──── CLAUDE-DESIGN / ANATOMY`" "magazine page number feel decorative progress bar" at bottom of frame, felt good about it. **Result**: User saw two progress bars — one Stage controller, one I drew decoration. Visually completely collided, judged as bug. "What's with the progress bar still in the video?"

**Rules**:

- Stage already provides: scrubber + timecode + pause/replay button. **Don't draw again in frame** progress indicators, current timecode, copyright signature bar, chapter counters — they either collide with chrome or are filler slop (violates "earn its place" principle).
- "Page number feel", "magazine feel", "bottom signature bar" these **decorative desires** are high-frequency filler AI automatically adds. Be alert every time one appears — does it really convey irreplaceable information? Or just fill blank space?
- If you firmly believe a bottom bar must exist (e.g., animation theme is about player UI), it must be **narratively necessary** and **visually significantly distinct from Stage scrubber** (different position, different form, different tone).

**Element Attribution Test** (every element drawn into canvas must answer):

| What does it belong to | Handling |
|------------|------|
| Some scene's narrative content | OK, keep |
| Global chrome (control/debug use) | Add `.no-record` class, hide on export |
| **Doesn't belong to any scene, nor is chrome** | **Delete**. This is ownerless thing, inevitably filler slop |

**Self-check (3 seconds before delivery)**: Take a static screenshot, ask yourself —

- Is there anything in frame that "looks like video player UI" (horizontal progress bar, timecode, control button-like)?
- If so, is narrative damaged by deleting it? No damage, delete.
- Does same type of information (progress/time/signature) appear twice? Merge to chrome one place.

**Anti-example**: Bottom `00:42 ──── PROJECT NAME`, bottom-right "CH 03 / 06" chapter counter, edge version number "v0.3.1" — all pseudo chrome filler.

## 12. Recording Front Blank + Recording Start Offset — `__ready` × tick × lastTick Triple Trap

**Bug encountered (A · Front blank)**: 60 second animation export MP4, first 2-3 seconds blank page. `ffmpeg --trim=0.3` can't cut it.

**Bug encountered (B · Start offset, 2026-04-20 real accident)**: Export 24 second video, user perception "video starts playing first frame at 19 seconds". Actually animation recorded from t=5, recorded to t=24 then looped back to t=0, recorded another 5 seconds to end — so video's last 5 seconds is animation's real start.

**Root cause** (two bugs share one root cause):

Playwright `recordVideo` starts writing WebM from `newContext()` moment, at this time Babel/React/font loading total L seconds (2-6s). Recording script waits for `window.__ready = true` as "animation starts from here" anchor — it must strictly pair with animation `time = 0`. Two common wrong methods:

| Wrong method | Symptom |
|------|------|
| `__ready` set in `useEffect` or sync setup phase (before tick first frame) | Recording script thinks animation started, actually WebM still recording blank page → **Front blank** |
| tick's `lastTick = performance.now()` initialized at **script top level** | Font loading L seconds counted into first frame `dt`, `time` instantly jumps to L → Recording lags L seconds throughout → **Start offset** |

**✅ Correct complete starter tick template** (hand-written animation must use this skeleton):

```js
// ━━━━━━ state ━━━━━━
let time = 0;
let playing = false;   // ❗ Default not playing, wait for fonts ready to start
let lastTick = null;   // ❗ sentinel — first tick frame dt forced to 0 (don't use performance.now())
const fired = new Set();

// ━━━━━━ tick ━━━━━━
function tick(now) {
  if (lastTick === null) {
    lastTick = now;
    window.__ready = true;   // ✅ pair: "recording start point" with "animation t=0" same frame
    render(0);               // Render again to ensure DOM ready (fonts ready now)
    requestAnimationFrame(tick);
    return;
  }
  const dt = (now - lastTick) / 1000;   // After first frame dt starts advancing
  lastTick = now;

  if (playing) {
    let t = time + dt;
    if (t >= DURATION) {
      t = window.__recording ? DURATION - 0.001 : 0;  // Don't loop when recording, keep 0.001s to retain last frame
      if (!window.__recording) fired.clear();
    }
    time = t;
    render(time);
  }
  requestAnimationFrame(tick);
}

// ━━━━━━ boot ━━━━━━
// Don't immediately rAF at top level — wait for fonts to load before starting
document.fonts.ready.then(() => {
  render(0);                 // Draw initial frame first (fonts ready)
  playing = true;
  requestAnimationFrame(tick);  // First tick will pair __ready + t=0
});

// ━━━━━━ seek interface (for render-video defensive correction) ━━━━━
window.__seek = (t) => { fired.clear(); time = t; lastTick = null; render(t); };
```

**Why this template is correct**:

| Step | Why must be this way |
|------|-------------|
| `lastTick = null` + first frame `return` | Avoid L seconds from "script load to tick first execution" being counted into animation time |
| `playing = false` default | During font loading `tick` runs but doesn't advance time, avoid rendering misalignment |
| `__ready` set at tick first frame | Recording script starts timing now, corresponding frame is animation's real t=0 |
| Start tick only in `document.fonts.ready.then(...)` | Avoid font fallback width measurement, avoid first frame font jumping |
| `window.__seek` exists | Let `render-video.js` actively correct — second line of defense |

**Corresponding defense at recording script side**:
1. `addInitScript` inject `window.__recording = true` (before page goto)
2. `waitForFunction(() => window.__ready === true)`, record this moment offset as ffmpeg trim
3. **Extra**: After `__ready` actively `page.evaluate(() => window.__seek && window.__seek(0))`, force HTML's possible time deviation to zero — this is second line of defense, dealing with HTML not strictly following starter template

**Verification method**: After export MP4
```bash
ffmpeg -i video.mp4 -ss 0 -vframes 1 frame-0.png
ffmpeg -i video.mp4 -ss $DURATION-0.1 -vframes 1 frame-end.png
```
First frame must be animation t=0 initial state (not mid-segment, not black), last frame must be animation final state (not some moment in second round loop).

**Reference implementation**: `assets/animations.jsx`'s Stage component, `scripts/render-video.js` both implemented per this protocol. Hand-written HTML must follow starter tick template — every line guards against specific bugs.

## 13. Disable Loop When Recording — `window.__recording` Signal

**Bug encountered**: Animation Stage defaults `loop=true` (convenient for viewing effects in browser). `render-video.js` waits extra 300ms buffer after recording duration seconds before stopping, this 300ms lets Stage enter next loop. When ffmpeg `-t DURATION` cuts, last 0.5-1s falls into next loop — video ending suddenly returns to first frame (Scene 1), audience thinks video has bug.

**Root cause**: No handshake protocol between recording script and HTML saying "I'm recording". HTML doesn't know it's being recorded, still loops per browser interaction scenario.

**Rules**:

1. **Recording script**: In `addInitScript` inject `window.__recording = true` (before page goto):
   ```js
   await recordCtx.addInitScript(() => { window.__recording = true; });
   ```

2. **Stage component**: Recognize this signal, force loop=false:
   ```js
   const effectiveLoop = (typeof window !== 'undefined' && window.__recording) ? false : loop;
   // ...
   if (next >= duration) return effectiveLoop ? 0 : duration - 0.001;
   //                                                       ↑ Keep 0.001 prevent Sprite end=duration being closed
   ```

3. **Ending Sprite's fadeOut**: Should set `fadeOut={0}` in recording scenario, otherwise video end fades to transparent/dark — users expect to stop at clear last frame, not fade out. Hand-written HTML suggests ending Sprites all use `fadeOut={0}`.

**Reference implementation**: `assets/animations.jsx`'s Stage / `scripts/render-video.js` both built-in handshake. Hand-written Stage must implement `__recording` detection — otherwise recording will hit this pitfall.

**Verification**: After export MP4 `ffmpeg -ss 19.8 -i video.mp4 -frames:v 1 end.png`, check if last 0.2 seconds is still expected last frame, no sudden switch to another scene.

## 14. 60fps Video Defaults to Frame Duplication — minterpolate Poor Compatibility

**Bug encountered**: `convert-formats.sh` used `minterpolate=fps=60:mi_mode=mci...` to generate 60fps MP4, couldn't open in macOS QuickTime / Safari some versions (black screen or direct refusal). VLC / Chrome could open.

**Root cause**: minterpolate output H.264 elementary stream contains SEI / SPS fields some players have trouble parsing.

**Rules**:

- Default 60fps use simple `fps=60` filter (frame duplication), broad compatibility (QuickTime/Safari/Chrome/VLC all open)
- High quality interpolation use `--minterpolate` flag explicitly enable — but **must test locally** target player before delivery
- 60fps tag value is **upload platform algorithm recognition** (Bilibili / YouTube 60fps tag will prioritize streaming), actual perceived smoothness improvement minimal for CSS animations
- Add `-profile:v high -level 4.0` improve H.264 universal compatibility

**`convert-formats.sh` already defaults to compatibility mode**. If you need interpolation high quality, add `--minterpolate` flag:
```bash
bash convert-formats.sh input.mp4 --minterpolate
```

## 15. `file://` + External `.jsx` CORS Trap — Single File Delivery Must Inline Engine

**Bug encountered**: Animation HTML used `<script type="text/babel" src="animations.jsx"></script>` to externally load engine. Local double-click open (`file://` protocol) → Babel Standalone goes XHR to pull `.jsx` → Chrome reports `Cross origin requests are only supported for protocol schemes: http, https, chrome, chrome-extension...` → Entire page black screen, doesn't report `pageerror` only console error, easily misdiagnosed as "animation didn't trigger".

Starting HTTP server might not save — when local has global proxy `localhost` also goes through proxy, returns 502 / connection failed.

**Rules**:

- **Single file delivery (double-click open usable HTML)** → `animations.jsx` must be **inlined** into `<script type="text/babel">...</script>` tag, don't use `src="animations.jsx"`
- **Multi-file project (start HTTP server demo)** → Can load externally, but delivery clearly write `python3 -m http.server 8000` command
- Judgment standard: delivery to user is "HTML file" or "project directory with server"? Former use inline
- Stage component / animations.jsx often 200+ lines — paste into HTML `<script>` block completely acceptable, don't fear size

**Minimum verification**: Double-click your generated HTML, **don't** open through any server. If Stage normally displays animation first frame, passes.

## 16. Cross Scene Invert Context — Don't Hardcode Colors for Elements in Frame

**Bug encountered**: When making multi-scene animations, `ChapterLabel` / `SceneNumber` / `Watermark` etc **elements appearing across all scenes**, hardcoded `color: '#1A1A1A'` (dark text) in component. First 4 scenes light background OK, at 5th dark background scene "05" and watermark directly disappeared — no error, doesn't trigger any check, key information invisible.

**Rules**:

- **Frame elements reused across multiple scenes** (chapter labels / scene numbers / timecodes / watermarks / copyright bars) **forbid hardcoded color values**
- Change to one of three methods:
  1. **`currentColor` inheritance**: Element only writes `color: currentColor`, parent scene container sets `color: computed value`
  2. **invert prop**: Component accepts `<ChapterLabel invert />` manually switch dark/light
  3. **Auto calculate based on background color**: `color: contrast-color(var(--scene-bg))` (CSS 4 new API, or JS judgment)
- Before delivery use Playwright to extract **each scene's representative frame**, human eye check "cross scene elements" all visible

This pitfall's insidiousness — **no bug alert**. Only human eye or OCR can discover.

## Quick Self-Check Checklist (5 Seconds Before Starting)

- [ ] Every `position: absolute` parent element has `position: relative`?
- [ ] Special characters in animation (`␣` `⌘` `emoji`) all exist in font?
- [ ] Grid/Flex template count matches JS data length?
- [ ] Cross-fade between scene switches, no >0.3s pure blank?
- [ ] DOM measurement code wrapped in `document.fonts.ready.then()`?
- [ ] `render(t)` is pure, or has clear reset mechanism?
- [ ] Frame 0 is complete initial state, not blank?
- [ ] No "pseudo chrome" decorations in frame (progress bar/timecode/bottom signature bar collides with Stage scrubber)?
- [ ] Animation tick first frame synchronously sets `window.__ready = true`? (Use animations.jsx built-in; hand-written HTML add yourself)
- [ ] Stage detects `window.__recording` forces loop=false? (Hand-written HTML must add)
- [ ] Ending Sprite's `fadeOut` set to 0 (video end stops at clear frame)?
- [ ] 60fps MP4 defaults to frame duplication mode (compatibility), high quality interpolation add `--minterpolate`?
- [ ] After export extract frame 0 + last frame verify is animation initial/final state?
- [ ] Involves specific brands (Stripe/Anthropic/Lovart/...): Completed "brand asset protocol" (SKILL.md §1.a five steps)? Wrote `brand-spec.md`?
- [ ] Single file delivery HTML: `animations.jsx` is inlined, not `src="..."`? (external .jsx under file:// will CORS black screen)
- [ ] Elements appearing across scenes (chapter labels/watermarks/scene numbers) don't have hardcoded colors? Visible under each scene's background color?
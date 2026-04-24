# Verification: Output Validation Process

Some design-agent native environments (like Claude.ai Artifacts) have built-in `fork_verifier_agent` that launches a subagent to use iframe screenshots for inspection. Most agent environments (Claude Code / Codex / Cursor / Trae / etc.) don't have this built-in capability—using Playwright manually can cover the same validation scenarios.

## Verification Checklist

After producing HTML, go through this checklist:

### 1. Browser Rendering Check (Required)

The most basic: **Can the HTML open?** On macOS:

```bash
open -a "Google Chrome" "/path/to/your/design.html"
```

Or use Playwright for screenshots (next section).

### 2. Console Error Check

The most common issue with HTML files is JS errors causing white screens. Run with Playwright:

```bash
python ~/.claude/skills/claude-design/scripts/verify.py path/to/design.html
```

This script will:
1. Open the HTML with headless chromium
2. Save a screenshot to the project directory
3. Capture console errors
4. Report status

See `scripts/verify.py` for details.

### 3. Multi-Viewport Check

For responsive design, capture multiple viewports:

```bash
python verify.py design.html --viewports 1920x1080,1440x900,768x1024,375x667
```

### 4. Interaction Check

Tweaks, animations, button toggles—default static screenshots won't show these. **It's recommended to let users open a browser and click through themselves**, or use Playwright to record a video:

```python
page.video.record('interaction.mp4')
```

### 5. Slide-by-Slide Deck Check

For deck-type HTML, capture one slide at a time:

```bash
python verify.py deck.html --slides 10  # Capture first 10 slides
```

Generates `deck-slide-01.png`, `deck-slide-02.png`... for quick browsing.

## Playwright Setup

First-time use requires:

```bash
# If not yet installed
npm install -g playwright
npx playwright install chromium

# Or Python version
pip install playwright
playwright install chromium
```

If the user already has Playwright installed globally, use it directly.

## Screenshot Best Practices

### Capture Full Page

```python
page.screenshot(path='full.png', full_page=True)
```

### Capture Viewport

```python
page.screenshot(path='viewport.png')  # Default: only visible area
```

### Capture Specific Element

```python
element = page.query_selector('.hero-section')
element.screenshot(path='hero.png')
```

### High-Resolution Screenshot

```python
page = browser.new_page(device_scale_factor=2)  # retina
```

### Wait for Animations to Complete Before Capturing

```python
page.wait_for_timeout(2000)  # Wait 2 seconds for animations to settle
page.screenshot(...)
```

## Sending Screenshots to Users

### Open Local Screenshots Directly

```bash
open screenshot.png
```

Users will view them in their Preview/Figma/VSCode/browser.

### Upload to Image Hosting for Sharing Links

If you need to show remote collaborators (e.g., on Slack/Feishu/WeChat), have users use their own image hosting tool or MCP to upload:

```bash
python ~/Documents/writing/tools/upload_image.py screenshot.png
```

Returns a permanent ImgBB link that can be pasted anywhere.

## When Verification Fails

### White Screen

There must be console errors. First check:

1. Are the integrity hashes for React+Babel script tags correct (see `react-setup.md`)
2. Is there a naming conflict with `const styles = {...}`
3. Were cross-file components exported to `window`
4. JSX syntax errors (babel.min.js doesn't report errors, switch to babel.js non-compressed version)

### Stuttering Animations

- Use Chrome DevTools Performance tab to record a segment
- Look for layout thrashing (frequent reflow)
- Use `transform` and `opacity` for animations (GPU acceleration)

### Incorrect Fonts

- Check if the `@font-face` URL is accessible
- Check fallback fonts
- Chinese fonts load slowly: display fallback first, then switch after loading completes

### Layout Misalignment

- Check if `box-sizing: border-box` is applied globally
- Check if `* { margin: 0; padding: 0 }` reset is in place
- Open gridlines in Chrome DevTools to see actual layout

## Verification = Designer's Second Set of Eyes

**Always go through it yourself**. When AI writes code, common issues include:

- Looks correct but interaction has bugs
- Static screenshots look good but breaks when scrolling
- Looks good on wide screens but breaks on narrow screens
- Forgot to test Dark mode
- Some components don't respond after Tweaks toggles

**The last 1 minute of verification can save 1 hour of rework.**

## Common Verification Script Commands

```bash
# Basic: open + screenshot + error capture
python verify.py design.html

# Multi-viewport
python verify.py design.html --viewports 1920x1080,375x667

# Multi-slide
python verify.py deck.html --slides 10

# Output to specified directory
python verify.py design.html --output ./screenshots/

# headless=false, open real browser for viewing
python verify.py design.html --show
```

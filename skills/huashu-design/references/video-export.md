# Video Export: Export HTML Animations to MP4/GIF

After completing an animated HTML, users often ask "can this be exported as video". This guide provides the complete workflow.

## When to Export

**Export timing**:
- Animation is complete and visually verified (Playwright screenshots confirm correct states at all time points)
- User has viewed it at least once in a browser and is satisfied with the result
- **Do not** export during the bug-fixing stage — making changes after exporting to video is more expensive

**Common user trigger phrases**:
- "Can this be exported as video?"
- "Convert to MP4"
- "Make it a GIF"
- "60fps"

## Output Specifications

Provide all three formats by default, let user choose:

| Format | Specs | Best Use Cases | Typical Size (30s) |
|---|---|---|---|
| MP4 25fps | 1920×1080 · H.264 · CRF 18 | WeChat embedding, video accounts, YouTube | 1-2 MB |
| MP4 60fps | 1920×1080 · minterpolate frame interpolation · H.264 · CRF 18 | High frame rate showcase, Bilibili, portfolio | 1.5-3 MB |
| GIF | 960×540 · 15fps · palette optimized | Twitter/X, README, Slack preview | 2-4 MB |

## Toolchain

Two scripts in `scripts/`:

### 1. `render-video.js` — HTML → MP4

Record a 25fps MP4 base version. Requires global playwright.

```bash
NODE_PATH=$(npm root -g) node /path/to/claude-design/scripts/render-video.js <html_file>
```

Optional parameters:
- `--duration=30` Animation duration (seconds)
- `--width=1920 --height=1080` Resolution
- `--trim=2.2` Seconds to trim from video start (removes reload + font loading time)
- `--fontwait=1.5` Font loading wait time (seconds), increase when multiple fonts

Output: Same directory as HTML, same name `.mp4`.

### 2. `add-music.sh` — MP4 + BGM → MP4

Mix background music into silent MP4, select from built-in BGM library by scenario (mood), or provide custom audio. Auto-matches duration, adds fade in/out.

```bash
bash add-music.sh <input.mp4> [--mood=<name>] [--music=<path>] [--out=<path>]
```

**Built-in BGM library** (in `assets/bgm-<mood>.mp3`):

| `--mood=` | Style | Best Use Cases |
|-----------|------|---------|
| `tech` (default) | Apple Silicon / Apple event, minimal synth + piano | Product launch, AI tools, Skill promotion |
| `ad` | Upbeat modern electronic, with build + drop | Social media ads, product teasers, promotional videos |
| `educational` | Warm bright, light guitar/e-piano, inviting | Science popularization, tutorial intro, course preview |
| `educational-alt` | Alternative backup, try different one | Same as above |
| `tutorial` | Lo-fi ambient, almost unnoticeable | Software demo, coding tutorial, long demonstration |
| `tutorial-alt` | Alternative backup | Same as above |

**Behavior**:
- Music is trimmed to video duration
- 0.3s fade in + 1s fade out (avoid hard cuts)
- Video stream `-c:v copy` no re-encoding, audio AAC 192k
- `--music=<path>` takes priority over `--mood`, can directly specify any external audio
- Wrong mood name lists all available options, won't fail silently

**Typical pipeline** (animation export trio + BGM):
```bash
node render-video.js animation.html                        # screen recording
bash convert-formats.sh animation.mp4                      # derive 60fps + GIF
bash add-music.sh animation-60fps.mp4                      # add default tech BGM
# Or for different scenarios:
bash add-music.sh tutorial-demo.mp4 --mood=tutorial
bash add-music.sh product-promo.mp4 --mood=ad --out=promo-final.mp4
```

### 3. `convert-formats.sh` — MP4 → 60fps MP4 + GIF

Generate 60fps version and GIF from existing MP4.

```bash
bash /path/to/claude-design/scripts/convert-formats.sh <input.mp4> [gif_width] [--minterpolate]
```

Output (same directory as input):
- `<name>-60fps.mp4` — default uses `fps=60` frame duplication (wide compatibility); add `--minterpolate` for high-quality frame interpolation
- `<name>.gif` — palette-optimized GIF (default 960 wide, adjustable)

**60fps mode selection**:

| Mode | Command | Compatibility | Use Cases |
|---|---|---|---|
| Frame duplication (default) | `convert-formats.sh in.mp4` | QuickTime/Safari/Chrome/VLC all work | General delivery, platform upload, social media |
| minterpolate interpolation | `convert-formats.sh in.mp4 --minterpolate` | macOS QuickTime/Safari may not play | Bilibili etc. need real interpolation, **must test locally before delivery** target player |

Why default to frame duplication? minterpolate's H.264 elementary stream has known compat bugs — when defaulting to minterpolate before, repeatedly encountered "macOS QuickTime can't open" issues. See `animation-pitfalls.md` §14.

`gif_width` parameter:
- 960 (default) — universal for social platforms
- 1280 — clearer but larger file
- 600 — Twitter/X priority loading

## Complete Workflow (Standard Recommended)

After user says "export video":

```bash
cd <project_directory>

# Assume $SKILL points to this skill's root directory (replace according to installation location)

# 1. Record 25fps base MP4
NODE_PATH=$(npm root -g) node "$SKILL/scripts/render-video.js" my-animation.html

# 2. Derive 60fps MP4 and GIF
bash "$SKILL/scripts/convert-formats.sh" my-animation.mp4

# Output checklist:
# my-animation.mp4         (25fps · 1-2 MB)
# my-animation-60fps.mp4   (60fps · 1.5-3 MB)
# my-animation.gif         (15fps · 2-4 MB)
```

## Technical Details (For Troubleshooting)

### Playwright recordVideo Pitfalls

- Frame rate fixed at 25fps, cannot directly record 60fps (Chromium headless compositor limit)
- Recording starts from context creation, must use `trim` to remove initial loading time
- Default webm format, requires ffmpeg to convert to H.264 MP4 for universal playback

`render-video.js` handles all above issues.

### ffmpeg minterpolate Parameters

Current config: `minterpolate=fps=60:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1`

- `mi_mode=mci` — motion compensation interpolation
- `mc_mode=aobmc` — adaptive overlapped block motion compensation
- `me_mode=bidir` — bidirectional motion estimation
- `vsbmc=1` — variable size block motion compensation

Works well for CSS **transform animations** (translate/scale/rotate).
For **pure fade** may produce slight ghosting — if user objects, fallback to simple frame duplication:

```bash
ffmpeg -i input.mp4 -r 60 -c:v libx264 ... output.mp4
```

### Why GIF Palette Needs Two Stages

GIF can only have 256 colors. Single-pass GIF compresses full animation colors to 256-color universal palette, which blurs subtle color schemes like beige + orange.

Two stages:
1. `palettegen=stats_mode=diff` — first scan full animation, generate **optimal palette for this animation**
2. `paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle` — encode with this palette, rectangle diff only updates changed regions, greatly reduces file size

For fade transitions, `dither=bayer` is smoother than `none`, but file is slightly larger.

## Pre-flight Check (Before Export)

30-second self-check before export:

- [ ] HTML has run completely once in browser, no console errors
- [ ] Animation frame 0 is complete initial state (not blank loading)
- [ ] Animation last frame is stable ending state (not cut off)
- [ ] Fonts/images/emojis all render correctly (refer to `animation-pitfalls.md`)
- [ ] Duration parameter matches actual animation duration in HTML
- [ ] Stage detection in HTML forces `window.__recording` loop=false (must check hand-written Stage; using `assets/animations.jsx` includes it)
- [ ] Ending Sprite has `fadeOut={0}` (video last frame doesn't fade out)
- [ ] Contains "Created by Huashu-Design" watermark (required for animation scenes; third-party brand works add "Unofficial · " prefix. See SKILL.md § "Skill Promotion Watermark")

## Delivery Instructions

Standard explanation format after export completion:

```
**Complete Delivery**

| File | Format | Specs | Size |
|---|---|---|---|
| foo.mp4 | MP4 | 1920×1080 · 25fps · H.264 | X MB |
| foo-60fps.mp4 | MP4 | 1920×1080 · 60fps (motion interpolation) · H.264 | X MB |
| foo.gif | GIF | 960×540 · 15fps · palette optimized | X MB |

**Notes**
- 60fps uses minterpolate for motion estimation interpolation, good for transform animations
- GIF uses palette optimization, 30s animation compresses to ~3MB

Let me know if you need different size or frame rate.
```

## Common User Follow-up Requests

| User says | Response |
|---|---|
| "Too large" | MP4: raise CRF to 23-28; GIF: lower resolution to 600 or fps to 10 |
| "GIF too blurry" | Raise `gif_width` to 1280; or suggest using MP4 instead (WeChat Moments also supports) |
| "Want vertical 9:16" | Change HTML source `--width=1080 --height=1920`, re-record |
| "Add watermark" | ffmpeg add `-vf "drawtext=..."` or `overlay=` a PNG |
| "Want transparent background" | MP4 doesn't support alpha; use WebM VP9 + alpha or APNG |
| "Want lossless" | Change CRF to 0 + preset veryslow (file will be 10x larger) |

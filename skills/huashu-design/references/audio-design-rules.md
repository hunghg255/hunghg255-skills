# Audio Design Rules · huashu-design

> Audio application recipes for all animation demos. Use together with `sfx-library.md` (asset inventory).
> Battle-tested through: huashu-design hero v1-v9 iterations · In-depth Gemini analysis of three official Anthropic videos · 8000+ A/B comparisons

---

## Core Principles · Audio Dual-Track System (Iron Rule)

Animation audio **must be designed in two independent layers**, not just one:

| Layer | Role | Time Scale | Relationship with Visual | Frequency Range |
|---|---|---|---|---|
| **SFX (beat layer)** | Mark each visual beat | 0.2-2 second short | **Strong sync** (frame-level alignment) | **High freq 800Hz+** |
| **BGM (atmosphere base)** | Emotional foundation, sound field | Continuous 20-60 seconds | Weak sync (section-level) | **Mid-low freq <4kHz** |

**Animations with only BGM are crippled**—audiences subconsciously perceive " visuals moving but no sound response," which is the root cause of cheap feeling.

---

## Gold Standard · Golden Ratio

These values are **hard engineering parameters** derived from comparing three official Anthropic videos with our v9 final version—just apply them directly:

### Volume
- **BGM volume**: `0.40-0.50` (relative to full scale 1.0)
- **SFX volume**: `1.00`
- **Loudness difference**: BGM peak is **-6 to -8 dB lower than SFX** (not SFX standing out through absolute loudness, but through loudness difference)
- **amix parameter**: `normalize=0` (never use normalize=1, it compresses dynamic range)

### Frequency Isolation (P1 Hard Optimization)
Anthropic's secret is not "SFX volume loud," but **frequency layering**:

```bash
[bgm_raw]lowpass=f=4000[bgm]      # BGM limited to <4kHz mid-low frequencies
[sfx_raw]highpass=f=800[sfx]      # SFX pushed to 800Hz+ mid-high frequencies
[bgm][sfx]amix=inputs=2:duration=first:normalize=0[a]
```

Why: Human ears are most sensitive to the 2-5kHz range (the "presence frequency band"). If SFX are all in this range and BGM covers all frequencies, **SFX will be masked by BGM's high-frequency components**. Using highpass to push SFX higher + lowpass to push BGM lower, each occupies its own territory in the spectrum, directly elevating SFX clarity one level.

### Fade
- BGM in: `afade=in:st=0:d=0.3` (0.3s, avoid hard cut)
- BGM out: `afade=out:st=N-1.5:d=1.5` (1.5s long tail, sense of closure)
- SFX has its own envelope, no additional fade needed

---

## SFX Cue Design Rules

### Density (how many SFX per 10 seconds)
Testing three Anthropic videos revealed three tiers of SFX density:

| Video | SFX per 10s | Product Personality | Scenario |
|---|---|---|---|
| Artifacts (ref-1) | **~9/10s** | Feature-dense, information-rich | Complex tool demo |
| Code Desktop (ref-2) | **0** | Pure atmosphere, meditative | Dev tool focused state |
| Word (ref-3) | **~4/10s** | Balanced, office rhythm | Productivity tool |

**Heuristics**:
- Calm/focused product personality → Low SFX density (0-3/10s), BGM dominant
- Lively/information-rich product personality → High SFX density (6-9/10s), SFX drives rhythm
- **Don't fill every visual beat**—negative space is more premium than density. **Removing 30-50% of cues makes the remaining more dramatic**.

### Cue Selection Priority
Not every visual beat needs SFX. Choose by this priority:

**P0 Must-have** (omission feels off):
- Typing (terminal/input)
- Click/selection (user decision moments)
- Focus switching (visual protagonist shift)
- Logo reveal (brand closure)

**P1 Recommended**:
- element entry/exit (modal / card)
- Completion/success feedback
- AI generation start/end
- Major transitions (scene switching)

**P2 Optional** (too many gets messy):
- hover / focus-in
- Progress tick
- Decorative ambient

### Timestamp Alignment Precision
- **Same-frame alignment** (0ms error): click/focus switch/Logo settle
- **Pre-advance 1-2 frames** (-33ms): fast whoosh (gives audience psychological expectation)
- **Post-delay 1-2 frames** (+33ms): object landing/impact (matches real physics)

---

## BGM Selection Decision Tree

huashu-design skill comes with 6 BGM tracks (`assets/bgm-*.mp3`):

```
What's the animation personality?
├─ Product launch / tech demo → bgm-tech.mp3 (minimal synth + piano)
├─ Tutorial / tool usage → bgm-tutorial.mp3 (warm, instructional)
├─ Educational learning / principle explanation → bgm-educational.mp3 (curious, thoughtful)
├─ Marketing ad / brand promotion → bgm-ad.mp3 (upbeat, promotional)
└─ Same style needs variation → bgm-*-alt.mp3 (their alternative versions)
```

### No-BGM Scenarios (worth considering)
Refer to Anthropic Code Desktop (ref-2): **0 SFX + pure Lo-fi BGM** can also be premium.

**When to choose no BGM**:
- Animation duration <10s (BGM can't establish)
- Product personality is "focused/meditative"
- Scene itself has ambient sound/explanation voice
- High SFX density (avoid auditory overload)

---

## Scenario Recipes (ready-to-use)

### Recipe A · Product Launch Hero (huashu-design v9 same style)
```
Duration: 25 seconds
BGM: bgm-tech.mp3 · 45% · frequency <4kHz
SFX density: ~6/10s

cues:
  Terminal typing → type × 4 (0.6s interval)
  Enter          → enter
  Card converge  → card × 4 (staggered 0.2s)
  Selection      → click
  Ripple         → whoosh
  4 focus shifts → focus × 4
  Logo           → thud (1.5s)

Volume: BGM 0.45 / SFX 1.0 · amix normalize=0
```

### Recipe B · Tool Feature Demo (refer to Anthropic Code Desktop)
```
Duration: 30-45 seconds
BGM: bgm-tutorial.mp3 · 50%
SFX density: 0-2/10s (very minimal)

Strategy: Let BGM + explanation voiceover drive, SFX only at **decisive moments** (file save/command execution complete)
```

### Recipe C · AI Generation Demo
```
Duration: 15-20 seconds
BGM: bgm-tech.mp3 or no BGM
SFX density: ~8/10s (high density)

cues:
  User input    → type + enter
  AI starts     → magic/ai-process (1.2s loop)
  Generation done→ feedback/complete-done
  Result reveal → magic/sparkle

Highlight: ai-process can loop 2-3 times throughout the generation process
```

### Recipe D · Pure Atmosphere Long Shot (refer to Artifacts)
```
Duration: 10-15 seconds
BGM: none
SFX: 3-5 carefully designed cues used solo

Strategy: Each SFX is the protagonist, no BGM "muddying together" issue.
Suitable: single product slow-motion, close-up showcase
```

---

## ffmpeg Composition Templates

### Template 1 · Single SFX Overlay to Video
```bash
ffmpeg -y -i video.mp4 -itsoffset 2.5 -i sfx.mp3 \
  -filter_complex "[0:a][1:a]amix=inputs=2:normalize=0[a]" \
  -map 0:v -map "[a]" output.mp4
```

### Template 2 · Multiple SFX Timeline Composition (aligned by cue time)
```bash
ffmpeg -y \
  -i sfx-type.mp3 -i sfx-enter.mp3 -i sfx-click.mp3 -i sfx-thud.mp3 \
  -filter_complex "\
[0:a]adelay=1100|1100[a0];\
[1:a]adelay=3200|3200[a1];\
[2:a]adelay=7000|7000[a2];\
[3:a]adelay=21800|21800[a3];\
[a0][a1][a2][a3]amix=inputs=4:duration=longest:normalize=0[mixed]" \
  -map "[mixed]" -t 25 sfx-track.mp3
```
**Key parameters**:
- `adelay=N|N`: first is left channel delay(ms), second is right channel, write twice to ensure stereo alignment
- `normalize=0`: preserve dynamic range, critical!
- `-t 25`: truncate to specified duration

### Template 3 · Video + SFX Track + BGM (with frequency isolation)
```bash
ffmpeg -y -i video.mp4 -i sfx-track.mp3 -i bgm.mp3 \
  -filter_complex "\
[2:a]atrim=0:25,afade=in:st=0:d=0.3,afade=out:st=23.5:d=1.5,\
     lowpass=f=4000,volume=0.45[bgm];\
[1:a]highpass=f=800,volume=1.0[sfx];\
[bgm][sfx]amix=inputs=2:duration=first:normalize=0[a]" \
  -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k final.mp4
```

---

## Failure Mode Quick Reference

| Symptom | Root Cause | Fix |
|---|---|---|
| SFX inaudible | BGM high frequencies masking | Add `lowpass=f=4000` to BGM + `highpass=f=800` to SFX |
| Sound effects too loud/harsh | SFX absolute volume too high | Lower SFX volume to 0.7, simultaneously lower BGM to 0.3, maintain difference |
| BGM and SFX rhythm conflict | Wrong BGM choice (used music with strong beats) | Switch to ambient / minimal synth BGM |
| BGM cuts off abruptly at animation end | No fade out | `afade=out:st=N-1.5:d=1.5` |
| SFX overlap into mush | Cues too dense + each SFX too long | Keep SFX duration ≤ 0.5s, cue interval ≥ 0.2s |
| WeChat Official Account mp4 has no sound | WeChat Official Account sometimes mutes auto-play | Don't worry, sound plays when user opens; gif has no sound anyway |

---

## Integration with Visuals (Advanced)

### SFX Timbre Should Match Visual Style
- Warm beige/paper feel visuals → SFX use **wooden/soft** timbres (Morse, paper snap, soft click)
- Cold black tech visuals → SFX use **metallic/digital** timbres (beep, pulse, glitch)
- Hand-drawn/childlike visuals → SFX use **cartoonish/exaggerated** timbres (boing, pop, zap)

Our current `apple-gallery-showcase.md` warm beige base → paired with `keyboard/type.mp3` (mechanical) + `container/card-snap.mp3` (soft) + `impact/logo-reveal-v2.mp3` (cinematic bass)

### SFX Can Guide Visual Rhythm
Advanced technique: **design SFX timeline first, then adjust visual animation to align with SFX** (not the reverse).
Because each SFX cue is a "clock tick," visual animation adapted to SFX rhythm will be very stable—conversely, having SFX chase visuals often results in ±1 frame misalignment that feels off.

---

## Quality Checklist (pre-release self-inspection)

- [ ] Loudness difference: SFX peak - BGM peak = -6 to -8 dB?
- [ ] Frequency: BGM lowpass 4kHz + SFX highpass 800Hz?
- [ ] amix normalize=0 (preserve dynamic range)?
- [ ] BGM fade-in 0.3s + fade-out 1.5s?
- [ ] SFX quantity appropriate (choose density by scenario personality)?
- [ ] Each SFX aligned with visual beat same-frame (within ±1 frame)?
- [ ] Logo reveal SFX duration sufficient (recommended 1.5s)?
- [ ] Listen with BGM off: SFX alone has sufficient rhythm?
- [ ] Listen with SFX off: BGM alone has emotional movement?

Either layer alone should sound coherent. If it only sounds good when both layers are combined, it's not done well.

---

## References

- SFX asset inventory: `sfx-library.md`
- Visual style reference: `apple-gallery-showcase.md`
- In-depth audio analysis of three Anthropic videos: `/Users/alchain/Documents/writing/01-wechat-writing/projects/2026.04-huashu-design-release/reference-animations/AUDIO-BEST-PRACTICES.md`
- huashu-design v9 real-world case: `/Users/alchain/Documents/writing/01-wechat-writing/projects/2026.04-huashu-design-release/images/hero-animation-v9-final.mp4`

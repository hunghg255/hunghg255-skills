<sub>🌐 <b>English</b> · <a href="README.zh.md">中文</a></sub>

<div align="center">

# Huashu Design

> *「打字。回车。一份能交付的设计。」*
> *"Type. Hit enter. A finished design lands in your lap."*

[![License](https://img.shields.io/badge/License-Personal%20Use%20Only-orange.svg)](LICENSE)
[![Agent-Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![Skills](https://img.shields.io/badge/skills.sh-Compatible-green)](https://skills.sh)

<br>

**Type a sentence in your agent, get back a deliverable design.**

<br>

In 3 to 30 minutes, you can ship a **product launch animation**, a clickable app prototype, an editable PPT deck, or print-grade infographics.

Not "AI-made this okay" quality—we're talking looks-like-it-came-from-a-big-tech-design-team quality. Give the skill your brand assets (logo, color palette, UI screenshots), it'll understand your brand personality; give it nothing, and the built-in 20 design vocabularies still guarantee no AI slop.

**Every animation you see in this README was made by huashu-design itself.** Not Figma, not AE—just one sentence prompt + skill running end-to-end. Next time your product launch needs a promo video? Now you can make one too.

```
npx skills add alchaincyf/huashu-design
```

Universal across agents—Claude Code, Cursor, Codex, OpenClaw, Hermes can all install it.

[See Demos](#demo-gallery) · [Install](#install--use) · [What It Can Do](#what-it-can-do) · [Core Mechanics](#core-mechanics) · [Relationship with Claude Design](#relationship-with-claude-design)

</div>

---

<p align="center">
  <img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/hero-animation-v10-en.gif" alt="huashu-design Hero · 打字 → 选方向 → 画廊展开 → 聚焦 → 品牌显形" width="100%">
</p>

<p align="center"><sub>
  ▲ 25 seconds · Terminal → 4 directions → Gallery ripple → 4 Focus sequences → Brand reveal<br>
  👉 <a href="https://www.huasheng.ai/huashu-design-hero/">Visit interactive HTML version with sound</a> ·
  <a href="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/hero-animation-v10-en.mp4">Download MP4 (with BGM+SFX · 10MB)</a>
</sub></p>

---

## Install & Use

```bash
npx skills add alchaincyf/huashu-design
```

Then just talk to Claude Code directly:

```
「Make a presentation deck about AI Psychology, recommend 3 style directions for me to choose from」
「Create an AI Pomodoro timer iOS prototype, 4 core screens must be actually clickable」
「Turn this logic into a 60-second animation, export MP4 and GIF」
「Help me do a 5-dimensional critique of this design」
```

No buttons, no panels, no Figma plugins.

---

## What It Can Do

| Capability | Deliverables | Typical Time |
|------|--------|----------|
| Interactive Prototype (App / Web) | Single-file HTML · Real iPhone bezel · Clickable · Playwright verified | 10–15 min |
| Presentation Slides | HTML deck (browser presentation) + Editable PPTX (text boxes preserved) | 15–25 min |
| Timeline Animation | MP4 (25fps / 60fps frame interpolation) + GIF (palette optimized) + BGM | 8–12 min |
| Design Variants | 3+ side-by-side comparisons · Tweaks real-time parameter tuning · Cross-dimensional exploration | 10 min |
| Infographic / Visualization | Print-grade typography · Exportable PDF/PNG/SVG | 10 min |
| Design Direction Advisor | 5 schools × 20 design philosophies · Recommend 3 directions · Parallel Demo generation | 5 min |
| 5-Dimension Expert Review | Radar chart + Keep/Fix/Quick Wins · Actionable fix checklist | 3 min |

---

## Demo Gallery

### Design Direction Advisor

Fallback when requirements are vague: pick 3 differentiated directions from 5 schools × 20 design philosophies, generate 3 Demos in parallel for you to choose.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/w3-fallback-advisor.gif" width="100%"></p>

### iOS App Prototype

iPhone 15 Pro precise body (Dynamic Island / status bar / Home Indicator) · State-driven multi-screen switching · Real images from Wikimedia/Met/Unsplash · Playwright automated click testing.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c1-ios-prototype.gif" width="100%"></p>

### Motion Design Engine

Stage + Sprite time-segment model · `useTime` / `useSprite` / `interpolate` / `Easing` four APIs cover all animation needs · One command exports MP4 / GIF / 60fps frame interpolation / finished video with BGM.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c3-motion-design.gif" width="100%"></p>

### HTML Slides → Editable PPTX

HTML deck browser presentation · `html2pptx.js` reads DOM's computedStyle element-by-element into PowerPoint objects · Exports **real text boxes**, not images plastered on bottom.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c2-slides-pptx.gif" width="100%"></p>

### Tweaks · Real-time Variant Switching

Color / font / information density etc. parametrized · Side panel switching · Pure frontend + `localStorage` persistence · Refresh doesn't lose state.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c4-tweaks.gif" width="100%"></p>

### Infographic / Data Visualization

Magazine-grade typography · CSS Grid precise columns · `text-wrap: pretty` typographic details · Real data-driven · Exportable PDF vector / PNG 300dpi / SVG.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c5-infographic.gif" width="100%"></p>

### 5-Dimension Expert Review

Philosophical consistency · Visual hierarchy · Detail execution · Functionality · Innovation each 0–10 points · Radar chart visualization · Output Keep / Fix / Quick Wins checklist.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/c6-expert-review.gif" width="100%"></p>

### Junior Designer Workflow

Don't go heads-down on big moves: first write assumptions + placeholders + reasoning, show you early, then iterate. Fixing misunderstandings early is 100x cheaper than late.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/w2-junior-designer.gif" width="100%"></p>

### Brand Asset Protocol 5-Step Hard Process

Mandatory execution when specific brands are involved: ask → search → download (three fallbacks) → grep color values → write `brand-spec.md`.

<p align="center"><img src="https://github.com/alchaincyf/huashu-design/releases/download/v2.0/w1-brand-protocol.gif" width="100%"></p>

---

## Core Mechanics

### Brand Asset Protocol

The hardest rules in the skill. When specific brands are involved (Stripe, Linear, Anthropic, your own company, etc.), mandatory 5-step execution:

| Step | Action | Purpose |
|------|------|------|
| 1 · Ask | Does user have brand guidelines? | Respect existing resources |
| 2 · Search official brand page | `<brand>.com/brand` · `brand.<brand>.com` · `<brand>.com/press` | Grab authoritative color values |
| 3 · Download assets | SVG files → Official site HTML full text → Product screenshot color picking | Three fallbacks, if one fails immediately go to next |
| 4 · grep extract color values | Grab all `#xxxxxx` from assets, sort by frequency, filter black/white/gray | **Never guess brand colors from memory** |
| 5 · Solidify spec | Write `brand-spec.md` + CSS variables, all HTML references `var(--brand-*)` | If not solidified, will forget |

A/B testing (v1 vs v2, each ran 6 agents): **v2's stability variance is 5x lower than v1**. Stability's stability—this is the skill's true moat.

### Design Direction Advisor (Fallback)

Triggered when user requirements are too vague to start:

- Don't force it with generic intuition, enter Fallback mode
- From 5 schools × 20 design philosophies, recommend 3 differentiated directions that **must come from different schools**
- Each direction comes with masterpieces, personality keywords, representative designers
- Generate 3 visual Demos in parallel for user to choose
- After selection, enter main Junior Designer workflow

### Junior Designer Workflow

Default work mode, runs through all tasks:

- Before starting, send question list to user all at once, wait for batch answers before acting
- In HTML, first write assumptions + placeholders + reasoning comments
- Show user early (even if just gray boxes)
- Fill actual content → variations → Tweaks, show again at each of these three steps
- Before delivery, use Playwright to visually review in browser

### Anti AI Slop Rules

Avoid visually obvious AI greatest common denominators (purple gradients / emoji icons / rounded corners + left border accent / SVG drawn faces / Inter for display). Use `text-wrap: pretty` + CSS Grid + carefully chosen serif display and oklch colors.

---

## Relationship with Claude Design

I'll generously admit: the Brand Asset Protocol philosophy was learned from prompts circulated by Claude Design. That prompt repeatedly emphasizes **good high-fidelity design doesn't start from a blank slate, it grows from existing design context**. This principle is the dividing line between 65-point work and 90-point work.

Positioning differences:

| | Claude Design | huashu-design |
|---|---|---|
| Form | Web product (used in browser) | skill (used in Claude Code) |
| Quota | Subscription quota | API consumption · Parallel agent runs not quota-limited |
| Deliverables | Canvas-in + Exportable Figma | HTML / MP4 / GIF / Editable PPTX / PDF |
| Operation | GUI (click, drag, edit) | Conversation (speak, wait for agent to finish) |
| Complex animation | Limited | Stage + Sprite timeline · 60fps export |
| Cross-agent | Claude.ai exclusive | Any skill-compatible agent |

Claude Design is **a better graphical tool**, huashu-design is **making the graphical tool layer disappear**. Two paths, different audiences.

---

## Limitations

- **No layer-level editable PPTX to Figma**. Produces HTML, can screenshot, record screen, export images, but can't drag into Keynote to change text positions.
- **Framer Motion-level complex animations won't work**. 3D, physics simulation, particle systems exceed skill boundaries.
- **Completely blank brand from-scratch design quality drops to 60–65 points**. Drawing hi-fi from thin air is inherently last resort.

This is an 80-point skill, not a 100-point product. For people unwilling to open graphical interfaces, an 80-point skill is more usable than a 100-point product.

---

## Repository Structure

```
huashu-design/
├── SKILL.md                 # Main documentation (for agents to read)
├── README.md                # This file (for users to read)
├── assets/                  # Starter Components
│   ├── animations.jsx       # Stage + Sprite + Easing + interpolate
│   ├── ios_frame.jsx        # iPhone 15 Pro bezel
│   ├── android_frame.jsx
│   ├── macos_window.jsx
│   ├── browser_window.jsx
│   ├── deck_stage.js        # HTML slide engine
│   ├── deck_index.html      # Multi-file deck splicer
│   ├── design_canvas.jsx    # Side-by-side variant display
│   ├── showcases/           # 24预制样例 (8 scenarios × 3 styles)
│   └── bgm-*.mp3            # 6 scene-based background music tracks
├── references/              # Sub-documents read in-depth by task
│   ├── animation-pitfalls.md
│   ├── design-styles.md     # 20种设计哲学详细库
│   ├── slide-decks.md
│   ├── editable-pptx.md
│   ├── critique-guide.md
│   ├── video-export.md
│   └── ...
├── scripts/                 # Export toolchain
│   ├── render-video.js      # HTML → MP4
│   ├── convert-formats.sh   # MP4 → 60fps + GIF
│   ├── add-music.sh         # MP4 + BGM
│   ├── export_deck_pdf.mjs
│   ├── export_deck_pptx.mjs
│   ├── html2pptx.js
│   └── verify.py
└── demos/                   # 9 capability demos (c*/w*), Chinese/English dual-version GIF/MP4/HTML + hero v10
```

---

## Origins

The day Anthropic released Claude Design, I played with it until 4 AM. A few days later, I found I hadn't opened it again—not because it's bad—it's currently the most mature product in this category—but because I'd rather have agents work for me in the terminal than open any graphical interface.

So I had the agent deconstruct Claude Design itself (including community-circulated system prompts, Brand Asset Protocol, component mechanism), distill it into structured specs, then write it as a skill to install in my own Claude Code.

Thanks to Anthropic for writing Claude Design's prompts clearly. This derivative work based on other products' inspiration is a new form of open-source culture in the AI era.

---

## License · Usage Authorization

**Free for personal use**—Learning, research, creation, making things for yourself, writing articles, side hustles, posting on social media, go ahead, no need to say hello.

**Commercial use by enterprises prohibited**—Any company, team, or profit-seeking organization that wants to integrate this skill into products, external services, or client deliverable work **must first contact Huasheng to obtain authorization**. This includes but is not limited to:
- Integrating the skill as part of company internal toolchain
- Using skill outputs as primary creation means for external deliverables
- Secondary development based on the skill into commercial products
- Use in client commercial projects

**Commercial authorization contact** see social platforms below.

---

## Connect · Huasheng (Huashu)

Huasheng is an AI Native Coder, indie developer, AI social media blogger. Representative works: Kitten Fill Light (AppStore paid chart Top 1), "Master DeepSeek in One Book", Nuwa .skill (GitHub 12000+ stars). Social media all-platform 300,000+ followers.

| Platform | Account | Link |
|---|---|---|
| X / Twitter | @AlchainHust | https://x.com/AlchainHust |
| WeChat Official Account | 花叔 | WeChat search「花叔」 |
| B Station | 花叔 | https://space.bilibili.com/14097567 |
| YouTube | 花叔 | https://www.youtube.com/@Alchain |
| Xiaohongshu | 花叔 | https://www.xiaohongshu.com/user/profile/5abc6f17e8ac2b109179dfdf |
| Official Site | huasheng.ai | https://www.huasheng.ai/ |
| Developer Homepage | bookai.top | https://bookai.top |

Commercial authorization, collaboration consulting, social media guest posting → DM Huasheng on any of the above platforms.

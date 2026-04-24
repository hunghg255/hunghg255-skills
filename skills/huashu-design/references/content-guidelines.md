# Content Guidelines: Anti-AI Slop, Content Standards, Scale Specifications

The easiest traps to fall into in AI design. This is a "what NOT to do" list—more important than "what to do"—because AI slop is the default; if you don't actively avoid it, it will happen.

## Complete AI Slop Blacklist

### Visual Traps

**❌ Aggressive Gradient Backgrounds**
- Purple → Pink → Blue full-screen gradients (typical AI-generated webpage flavor)
- Rainbow gradients in any direction
- Mesh gradients covering the entire background
- ✅ If using gradients: subtle, monochromatic, intentional accents (like button hover)

**❌ Rounded Cards + Left Border Accent Color**
```css
/* This is the typical signature of AI-flavored cards */
.card {
  border-radius: 12px;
  border-left: 4px solid #3b82f6;
  padding: 16px;
}
```
This card style floods AI-generated dashboards. Want to create emphasis? Use more design-savvy methods: background color contrast, font weight/size contrast, plain dividers, or simply don't separate cards at all.

**❌ Emoji Decoration**
Unless the brand itself uses emoji (like Notion, Slack), don't place emoji in the UI. **Especially don't**:
- 🚀 ⚡️ ✨ 🎯 💡 before headings
- ✅ in feature lists
- → in CTA buttons (arrows appearing alone is OK, emoji arrows are not)

If you don't have icons, use real icon libraries (Lucide/Heroicons/Phosphor), or use placeholders.

**❌ SVG for Imagery**
Don't attempt to draw with SVG: people, scenes, devices, objects, abstract art. AI-drawn SVG imagery screams "AI flavor" at first glance—childish and cheap. **A gray rectangle + text label saying "illustration space 1200×800" is 100 times better than a crude SVG hero illustration**.

The only scenarios where SVG can be used:
- Real icons (16×16 to 32×32 level)
- Geometric shapes as decorative elements
- Charts for data visualization

**❌ Excessive Iconography**
Not every heading/feature/section needs an icon. Abusing icons makes the interface look like a toy. Less is more.

**❌ "Data Slop"**
Fabricated stats for decoration:
- "10,000+ happy customers" (you don't even know if they exist)
- "99.9% uptime" (don't write it without real data)
- Decorative "metric cards" composed of icons + numbers + words
- Fake data in mock tables decorated gaudily

If there's no real data, leave placeholders or ask the user for them.

**❌ "Quote Slop"**
Fabricated user testimonials, famous quotes decorating pages. Leave placeholders and ask users for real quotes.

### Typography Traps

**❌ Avoid These Overused Fonts**:
- Inter (default for AI-generated webpages)
- Roboto
- Arial / Helvetica
- Pure system font stack
- Fraunces (AI discovered this and overused it)
- Space Grotesk (AI's recent favorite)

**✅ Use Characteristic Display + Body Pairings**. Inspiration directions:
- Serif display + sans-serif body (editorial feel)
- Mono display + sans body (technical feel)
- Heavy display + light body (contrast)
- Variable fonts for hero weight animation

Font resources:
- Google Fonts' underrated good options (Instrument Serif, Cormorant, Bricolage Grotesque, JetBrains Mono)
- Open source font sites (Fraunces' sibling fonts, Adobe Fonts)
- Don't invent font names out of thin air

### Color Traps

**❌ Inventing Colors Out of Thin Air**
Don't design a complete unfamiliar color system from scratch. This usually lacks harmony.

**✅ Strategy**:
1. Have brand colors → Use brand colors, fill missing color tokens with oklch interpolation
2. No brand colors but have references → Extract colors from reference product screenshots
3. Completely from scratch → Choose a known color system (Radix Colors / Tailwind default palette / Anthropic brand), don't mix your own

**Defining colors with oklch** is the most modern approach:
```css
:root {
  --primary: oklch(0.65 0.18 25);      /* Warm terracotta */
  --primary-light: oklch(0.85 0.08 25); /* Lighter same hue */
  --primary-dark: oklch(0.45 0.20 25);  /* Darker same hue */
}
```
oklch ensures hue doesn't shift when adjusting brightness, better than hsl.

**❌ Casually Adding Dark Mode as Color Inversion**
Dark mode is not simply inverting colors. Good dark mode needs readjusted saturation, contrast, and accent colors. If you don't want to do dark mode properly, don't do it at all.

### Layout Traps

**❌ Bento Grid Overproliferation**
Every AI-generated landing page wants to do bento. Unless your information structure truly suits bento, use other layouts.

**❌ Big Hero + 3-Column Features + Testimonials + CTA**
This landing page template has been used to death. If you want to innovate, truly innovate.

**❌ Every Card in Card Grid Looks the Same**
Asymmetric, different-sized cards, some with images some text-only, some spanning columns—this looks like something a real designer made.

## Content Standards

### 1. Don't Add Filler Content

Every element must earn its place. Empty space is a design problem; solve it with **composition** (contrast, rhythm, white space), **not** by filling it with content.

**Questions to judge filler**:
- If you remove this content, will the design be worse? If the answer is "no", remove it.
- What real problem does this element solve? If it's "to make the page less empty", delete it.
- Does this stat/quote/feature have real data support? If not, don't write it from scratch.

"One thousand no's for every yes".

### 2. Ask Before Adding Material

You think adding a section/page/segment would be better? Ask the user first, don't add it unilaterally.

Reasons:
- Users know their audience better than you
- Adding content has costs; users might not want it
- Unilaterally adding content violates the "junior designer reporting to work" relationship

### 3. Create a System Up Front

After exploring the design context, **first verbally state the system you'll use**, let the user confirm:

```markdown
My design system:
- Colors: #1A1A1A main + #F0EEE6 background + #D97757 accent (from your brand)
- Typography: Instrument Serif for display + Geist Sans for body
- Rhythm: Section titles use full-bleed colored background + white text; regular sections use white background
- Images: Hero uses full-bleed photo, feature section uses placeholder for you to provide
- Maximum 2 background colors to avoid clutter

Confirm this direction and I'll start.
```

Start work after user confirmation. This check-in avoids "discovering wrong direction halfway through".

## Scale Specifications

### Slides (1920×1080)

- Body minimum **24px**, ideal 28-36px
- Headings 60-120px
- Section titles 80-160px
- Hero headlines can use 180-240px large text
- Never use <24px text in slides

### Print Documents

- Body minimum **10pt** (≈13.3px), ideal 11-12pt
- Headings 18-36pt
- Captions 8-9pt

### Web and Mobile

- Body minimum **14px** (use 16px for elderly-friendly)
- Mobile body **16px** (avoid iOS auto-zoom)
- Hit target (clickable elements) minimum **44×44px**
- Line height 1.5-1.7 (Chinese 1.7-1.8)

### Contrast

- Body vs background **at least 4.5:1** (WCAG AA)
- Large text vs background **at least 3:1**
- Check with Chrome DevTools accessibility tool

## CSS Magic Tools

**Advanced CSS features** are a designer's best friend, use them boldly:

### Typography

```css
/* Make heading line breaks more natural, avoid single word on last line */
h1, h2, h3 { text-wrap: balance; }

/* Body text line wrapping, avoid widows and orphans */
p { text-wrap: pretty; }

/* Chinese typography magic: punctuation trim, line start/end control */
p {
  text-spacing-trim: space-all;
  hanging-punctuation: first;
}
```

### Layout

```css
/* CSS Grid + named areas = exploded readability */
.layout {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar main"
    "footer footer";
  grid-template-columns: 240px 1fr;
  grid-template-rows: auto 1fr auto;
}

/* Subgrid for card content alignment */
.card { display: grid; grid-template-rows: subgrid; }
```

### Visual Effects

```css
/* Designerly scrollbars */
* { scrollbar-width: thin; scrollbar-color: #666 transparent; }

/* Glassmorphism (use sparingly) */
.glass {
  backdrop-filter: blur(20px) saturate(150%);
  background: color-mix(in oklch, white 70%, transparent);
}

/* View transitions API for silky page transitions */
@view-transition { navigation: auto; }
```

### Interaction

```css
/* :has() selector makes conditional styling easy */
.card:has(img) { padding-top: 0; } /* Cards with images have no top padding */

/* Container queries make components truly responsive */
@container (min-width: 500px) { ... }

/* New color-mix function */
.button:hover {
  background: color-mix(in oklch, var(--primary) 85%, black);
}
```

## Decision Quick Reference: When You're Hesitant

- Want to add a gradient? → Most likely don't
- Want to add an emoji? → Don't
- Want to give cards rounded corners + border-left accent? → Don't, use another method
- Want to draw a hero illustration with SVG? → Don't draw, use placeholder
- Want to add a quote decoration? → First ask user if they have real quotes
- Want to add a row of icon features? → First ask if they want icons; might not need them
- Use Inter? → Switch to something more characteristic
- Use purple gradient? → Switch to a well-founded color scheme

**When you think "adding this would look better"—that's usually a sign of AI slop**. Make the simplest version first; only add when users request.

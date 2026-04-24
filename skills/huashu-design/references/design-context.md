# Design Context：Starting from Existing Context

**This is the most important one thing for this skill.**

Good hi-fi design must grow from existing design context. **Creating hi-fi from scratch is a last resort and will inevitably produce generic work**. So at the start of every design task, first ask: Is there anything we can reference?

## What is Design Context

In order of priority from high to low:

### 1. User's Design System/UI Kit
The user's existing product component library, color tokens, typography specifications, icon system. **The ideal situation**.

### 2. User's Codebase
If the user provides a codebase, it contains living component implementations. Read those component files:
- `theme.ts` / `colors.ts` / `tokens.css` / `_variables.scss`
- Specific components (Button.tsx, Card.tsx)
- Layout scaffold (App.tsx, MainLayout.tsx)
- Global stylesheets

**Read code and copy exact values**: hex codes, spacing scale, font stack, border radius. Don't redraw from memory.

### 3. User's Published Product
If the user has a live product but didn't provide code, use Playwright or ask the user to provide screenshots.

```bash
# Screenshot a public URL with Playwright
npx playwright screenshot https://example.com screenshot.png --viewport-size=1920,1080
```

Let you see the real visual vocabulary.

### 4. Brand Guidelines/Logo/Existing Materials
The user may have: Logo files, brand color specifications, marketing materials, slide templates. These are all context.

### 5. Competitor References
The user says "like XX website" — have them provide URL or screenshots. **Do not** rely on vague impressions from your training data.

### 6. Known design systems (fallback)
If none of the above, use recognized design systems as base:
- Apple HIG
- Material Design 3
- Radix Colors (color schemes)
- shadcn/ui (components)
- Tailwind default palette

Clearly tell the user what you're using, let them know this is a starting point not final.

## Process for Getting Context

### Step 1: Ask the User

Required checklist at task start (from `workflow.md`):

```markdown
1. Do you have an existing design system/UI kit/component library? Where?
2. Are there brand guidelines, color/font specifications?
3. Can you give me screenshots or URLs of existing products?
4. Is there a codebase I can read?
```

### Step 2: When the User Says "No", Help Them Find

Don't give up directly. Try:

```markdown
Let me see if there are any clues:
- Do your previous projects have related designs?
- What colors/typography does the company's marketing website use?
- What's the style of your product's logo? Can you give me one?
- Are there any products you admire as reference?
```

### Step 3: Read All Context You Can Find

If the user gives a codebase path, you read:
1. **First list file structure**: find style/theme/component related files
2. **Read theme/token files**: lift specific hex/px values
3. **Read 2-3 representative components**: see visual vocabulary (hover state, shadow, border, padding node pattern)
4. **Read global stylesheet**: base reset, font loading
5. **If there are Figma links/screenshots**: look at images, but **trust code more**

**Important**: **Do not** take a glance and work from impression. You need to read down 30+ specific values to truly lift them.

### Step 4: Vocalize the System You'll Use

After reviewing context, tell the user the system you'll use:

```markdown
Based on your codebase and product screenshots, I distilled the design system:

**Colors**
- Primary: #C27558 (from tokens.css)
- Background: #FDF9F0
- Text: #1A1A1A
- Muted: #6B6B6B

**Typography**
- Display: Instrument Serif (from global.css @font-face)
- Body: Geist Sans
- Mono: JetBrains Mono

**Spacing** (from your scale system)
- 4, 8, 12, 16, 24, 32, 48, 64

**Shadow pattern**
- `0 1px 2px rgba(0,0,0,0.04)` (subtle card)
- `0 10px 40px rgba(0,0,0,0.1)` (elevated modal)

**Border-radius**
- Small components 4px, cards 12px, buttons 8px

**Component vocabulary**
- Button: filled primary, outlined secondary, ghost tertiary, all rounded 8px
- Card: white background, subtle shadow, no border

I'll start working with this system. OK to proceed?
```

Wait for user confirmation before starting.

## Designing from Scratch (fallback when no Context)

**Strong warning**: Output quality in this situation will significantly decline. Clearly tell the user.

```markdown
You don't have design context, so I can only work based on generic intuition.
The output will be something that "looks OK but lacks uniqueness".
Are you willing to continue, or should we get some reference materials first?
```

If the user insists, make decisions in this order:

### 1. Choose an aesthetic direction
Don't give generic results. Pick a clear direction:
- brutally minimal
- editorial/magazine
- brutalist/raw
- organic/natural
- luxury/refined
- playful/toy
- retro-futuristic
- soft/pastel

Tell the user which one you chose.

### 2. Choose a known design system as skeleton
- Use Radix Colors for color schemes (https://www.radix-ui.com/colors)
- Use shadcn/ui for component vocabulary (https://ui.shadcn.com)
- Use Tailwind spacing scale (multiples of 4)

### 3. Choose distinctive font pairings

Don't use Inter/Roboto. Suggested combinations (free from Google Fonts):
- Instrument Serif + Geist Sans
- Cormorant Garamond + Inter Tight
- Bricolage Grotesque + Söhne (paid)
- Fraunces + Work Sans (note Fraunces is overused by AI)
- JetBrains Mono + Geist Sans (technical feel)

### 4. Every key decision has reasoning

Don't choose silently. Write in HTML comments:

```html
<!--
Design decisions:
- Primary color: warm terracotta (oklch 0.65 0.18 25) — fits the "editorial" direction
- Display: Instrument Serif for humanist, literary feel
- Body: Geist Sans for cleanness contrast
- No gradients — committed to minimal, no AI slop
- Spacing: 8px base, golden ratio friendly (8/13/21/34)
-->
```

## Import Strategy (when user provides codebase)

If the user says "import this codebase for reference":

### Small (<50 files)
Read all, internalize context.

### Medium (50-500 files)
Focus on:
- `src/components/` or `components/`
- All styles/tokens/theme related files
- 2-3 representative full-page components (Home.tsx, Dashboard.tsx)

### Large (>500 files)
Have user specify focus:
- "I want to make settings page" → read existing settings related
- "I want to make a new feature" → read overall shell + closest reference
- Don't seek completeness, seek accuracy

## Working with Figma/Design Specs

If user provides Figma link:

- **Do not** expect to directly "convert Figma to HTML" — that requires additional tools
- Figma links are usually not publicly accessible
- Ask user to: export as **screenshot** send to you + tell you specific color/spacing values

If only Figma screenshot provided, tell user:
- I can see visuals but can't extract exact values
- Please tell me key numbers (hex, px), or export as code (Figma supports)

## Final Reminder

**The upper limit of design quality for a project is determined by the quality of context you receive**.

Spending 10 minutes collecting context is more valuable than spending 1 hour creating hi-fi from scratch.

**When encountering no context situations, prioritize asking the user rather than forcing ahead**.

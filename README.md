# hunghg255-skills

A collection of production-grade agent skills for Claude Code and other AI agent terminals.

<p align="center">
  <img src="https://img.shields.io/badge/Skills-9-blue" alt="9 Skills" />
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="MIT License" />
</p>

## Skills

| Skill | Description | Install |
|-------|-------------|---------|
| [**Code Review Expert**](./skills/code-review-expert/) | Senior engineer code review covering SOLID, security, performance, error handling | `npx skills add hunghg255/hunghg255-skills --path skills/code-review-expert` |
| [**Diagram Design**](./skills/diagram-design/) | Create technical and product diagrams — architecture, flowchart, sequence, state machine, ER/data model, timeline, swimlane, and more — as standalone HTML files with inline SVG | `npx skills add hunghg255/hunghg255-skills --path skills/diagram-design` |
| [**Food Infographic**](./skills/food-infographic-skills/) | Create cinematic editorial infographic prompts for dishes with hyper-realistic food photography style | `npx skills add hunghg255/hunghg255-skills --path skills/food-infographic-skills` |
| [**Food Infographic (No Text)**](./skills/food-infographic-no-text-skills/) | Variant of food infographic without text overlays | `npx skills add hunghg255/hunghg255-skills --path skills/food-infographic-no-text-skills` |
| [**Huashu Design**](./skills/huashu-design/) | High-fidelity HTML prototypes, interactive demos, slides, animations, and design direction consulting with expert review | `npx skills add hunghg255/hunghg255-skills --path skills/huashu-design` |
| [**Karpathy Guidelines**](./skills/karpathy-guidelines/) | Behavioral guidelines to reduce common LLM coding mistakes — avoid overcomplication, make surgical changes, surface assumptions | `npx skills add hunghg255/hunghg255-skills --path skills/karpathy-guidelines` |
| [**Sigma**](./skills/sigma/) | 1-on-1 AI tutor based on Bloom's 2-Sigma mastery learning with Socratic questioning and adaptive pacing | `npx skills add hunghg255/hunghg255-skills --path skills/sigma` |
| [**Skill Forge**](./skills/skill-forge/) | Meta-skill for creating high-quality, production-grade skills with battle-tested techniques | `npx skills add hunghg255/hunghg255-skills --path skills/skill-forge` |
| [**Web Animation Design**](./skills/web-animation-design/) | Design and implement natural, purposeful web animations — easing, timing, springs, transitions, and motion accessibility | `npx skills add hunghg255/hunghg255-skills --path skills/web-animation-design` |

## Quick Start

Install any skill with:

```bash
npx skills add hunghg255/hunghg255-skills --path skills/<skill-name>
```

Then invoke in your agent terminal:

```bash
/code-review-expert         # Review current git changes
/diagram-design             # Create a technical diagram
/food-infographic-skills    # Generate a food infographic prompt
/huashu-design              # Create HTML prototypes or demos
/karpathy-guidelines        # Apply coding best practices
/sigma <topic>              # Start a tutoring session
/skill-forge                # Create a new skill
/web-animation-design       # Design web animations
```

## License

MIT

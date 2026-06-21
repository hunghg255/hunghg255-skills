# Engineering Manuscript Illustration Visual Specifications

This reference file stores the fixed visual language. Read it only when generating the final imagegen prompt, reusing the visual style, handling reference-image style transfer, or enforcing consistency across an image series.

## 1. Overall Style Positioning

- Modern engineering manuscript illustration on a pure white background
- Blueprint-style linework that is delicate, precise, and clean
- Modern industrial design feel similar to Apple/Tesla product design manuscripts
- Clean, professional, strongly technological
- Content expression takes priority over decoration; the goal is to draw concepts as readable structures and steps

## 2. Background And Whitespace

- The background must be pure white `#FFFFFF`
- Preserve generous whitespace and breathing room
- Do not use off-white paper texture, transparent backgrounds, dark backgrounds, gradient backgrounds, or complex scenes
- Do not let the subject fill the entire image; leave enough space around it for engineering annotations

## 3. Linework Rules

- Main linework should be dark gray, preferably around `#333333` to `#4A4A4A`
- Lines should be delicate, precise, and restrained, like engineering blueprints, product design sketches, or structural diagrams
- A slight hand-drawn quality is acceptable, but it must not feel childish, messy, or comic-like
- Do not use heavy thick black lines
- Do not use strong shadows, 3D volume, metallic texture, or realistic rendering

## 4. Titles And Text

- Titles should use a dark-gray handwritten style that feels modern, restrained, and professional
- Annotation text should be clear Vietnamese, prioritizing short terms
- Vietnamese must be accurate, natural, sharp, and print-grade readable
- Treat text as an independent layer and avoid overlap with linework or watercolor
- Keep only 1 to 6 keywords, step names, or short annotations
- Do not create dense text blocks or copy full passages from the user's source text

## 5. Engineering Annotation Language

Prefer these elements to organize information:

- Numbered nodes
- Fine leader lines
- Arrows
- callout labels
- Magnified detail frames
- Dimension lines
- Exploded annotations
- Concise icons
- Lightweight flow lines

Annotations should serve the reading path. Do not add random lines merely for decoration.

## 6. Color And Watercolor Accents

- The main subject should be dominated by dark-gray engineering line art
- Accent colors should be limited to pale blue, pale green, and pale orange
- Accent colors should be highly transparent, like light watercolor washes
- Use watercolor only to emphasize key steps, local areas, subtle background atmosphere, or icon backgrounds
- Do not use large color blocks
- Do not use strong gradients or high-saturation clashing colors
- Do not let watercolor cover Vietnamese text or engineering linework

## 7. Composition And Information Organization

- Default aspect ratio: `16:9`
- Prefer horizontal composition, suitable for PPTs, course visuals, article headers, and explanatory diagrams
- Maintain one clear subject, such as a product, device, process, system, method, or abstract concept
- Product or system topic: central object plus surrounding engineering annotations
- Method or step topic: horizontal flow plus numbered nodes and small icons
- Structural exploded topic: main exploded diagram plus magnified details and callout labels
- Abstract concept topic: lightweight relationship diagram, module diagram, or path diagram
- The reading path should be clear: left to right, top to bottom, or expanding outward from the center

## 8. Series Consistency

When generating consecutive images, extending the same topic, or revising a previous image:

- Keep the pure white background
- Keep fine dark-gray engineering linework
- Keep pale blue, pale green, and pale orange high-transparency watercolor accents
- Keep the engineering annotation method
- Keep the modern product design manuscript feel
- Change only the subject, step structure, icons, annotation content, and local composition

## 9. Prohibited Elements

- No black or dark backgrounds
- No heavy thick black lines
- No cyberpunk, neon, or high-contrast sci-fi style
- No strong gradients
- No 3D rendering, realistic photography, metallic texture, or complex lighting
- No crowded backgrounds, excessive decoration, or chaotic layout
- No cute notebook journaling, children's doodles, comic posters, or exaggerated expressive characters
- Do not let watercolor color blocks dominate the image

## 10. Visual Translation Principles

Understand the user's content first, then translate it into an engineering explanatory diagram. Do not mechanically copy the source text.

Prefer these conversions:

- Abstract ideas into structural diagrams
- Method steps into numbered flows
- Product functions into a central product sketch plus surrounding callout labels
- Tool lists into concise icon groups
- System architectures into module relationship diagrams
- Comparisons into left-right contrasts or top-bottom layers
- Complex content into 1 to 3 visual focal points

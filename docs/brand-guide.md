# Inductor Calculator — Brand & Design Guide

## Overview

Brand identity for Inductor Calculator app — an electronics tool for engineers, hobbyists, and students working with inductors and coils.

---

## Brand Personality

**Keywords:** Technical, Precise, Professional, Innovative

**Tone:** Industrial blueprint meets modern engineering software. Clean, authoritative, and functional.

---

## Logo Concept

### Primary Mark
- Stylized inductor coil symbol integrated with circuit board traces
- Geometric, angular construction suggesting precision engineering
- Negative space creates hidden "IC" or "inductance" symbolism

### Alternative Marks
1. **Monogram:** "IC" letterform with coil loop as the C
2. **Icon-Only:** Abstract inductor band pattern in hexagonal frame
3. **Text + Symbol:** App name with mini coil diagram

### Composition Rules
- Minimum clear space: 1x logo height on all sides
- Never distort, rotate, or add effects to logo
- Use on dark backgrounds only (primary: `#0A0E14`)

---

## Color Palette

### Primary Colors

| Name | Hex | Usage |
|------|-----|-------|
| Deep Navy | `#0A0E14` | Primary background |
| Surface Dark | `#111820` | Cards, elevated surfaces |
| Card Surface | `#151D28` | Section containers |

### Accent Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Neon Lime** | `#E8FF47` | Primary accent, CTAs, values |
| Electric Cyan | `#00E5CC` | Secondary accent, diagrams |

### Neutral Colors

| Name | Hex | Usage |
|------|-----|-------|
| Text Primary | `#F0F4F8` | Headings, important text |
| Text Secondary | `#8BA3B9` | Body text, labels |
| Text Muted | `#5A6E82` | Placeholders, hints |
| Border Subtle | `#1E2A38` | Card borders, dividers |
| Border Active | `#2A3D50` | Focus states, active elements |
| Grid Line | `#0F1820` | Background patterns |

### Semantic Colors

| Name | Hex | Usage |
|------|-----|-------|
| Warning | `#FFB347` | Warnings, caution states |
| Error | `#FF6B6B` | Errors, invalid inputs |

---

## Typography

### Display / Logo
- **Primary:** Custom wordmark or Space Grotesk Bold
- **Fallback:** system-ui, sans-serif

### UI Text
- **Font Family:** Space Grotesk
- **Weights:** 500 (body), 600 (labels/emphasis), 700 (headings)
- **Letter Spacing:** 0.5–2px for labels (all caps)

### Technical Values
- **Font Family:** JetBrains Mono
- **Weight:** 600
- **Usage:** Inductance readings, numerical outputs
- **Letter Spacing:** 2px

### Color Code
- **Font Family:** Space Grotesk Mono
- **Size:** Monospace for alignment

---

## Iconography

### Style
- Outlined icons with rounded caps
- 1.5px stroke weight
- 24x24 base grid
- Color: Text Secondary or Accent Neon

### Icon Set
- Custom SVG icons for: inductor, coil, layers, spiral, calculator
- Use Material Icons for: navigation, actions, settings

---

## Logo Construction

```
┌─────────────────────────────────────────────┐
│                                             │
│     ╔═══════════════════════════════════╗  │
│     ║   INDUCTOR CALCULATOR               ║  │
│     ╠═════════════════════════════════════╣  │
│     ║                                       ║  │
│     ║      ┌──────────────────────┐        ║  │
│     ║      │    [COIL DIAGRAM]    │        ║  │
│     ║      │   ╭───────────────╮  │        ║  │
│     ║      │   │ ▓▓▓▓▓▓▓▓▓▓▓▓ │  │        ║  │
│     ║      │   ╰───────────────╯  │        ║  │
│     ║      └──────────────────────┘        ║  │
│     ║                                       ║  │
│     ║   Calculate · Design · Learn          ║  │
│     ╚═════════════════════════════════════╝  │
│                                             │
└─────────────────────────────────────────────┘
```

### App Icon Specifications
- **Format:** PNG with transparency
- **Sizes Required:**
  - Play Store: 512x512px
  - Adaptive Icon: 108x108px foreground
  - Legacy: 48, 72, 96, 144px
- **Background:** Transparent or Deep Navy `#0A0E14`
- **Foreground Color:** Neon Lime `#E8FF47`

---

## Logo Variants

### Light Background Variant
For use on light surfaces (if needed):
- Text: Deep Navy `#0A0E14`
- Accent: Electric Cyan `#00E5CC`

### Monochrome Variant
- Single color: Neon Lime `#E8FF47`
- Usage: Embossing, single-color print

---

## Visual Elements

### Grid Pattern
```
Color: #0F1820
Stroke: 0.5px
Spacing: 12px
Usage: Technical illustration backgrounds
```

### Dimension Lines
```
Color: #5A6E82 (Text Muted)
Stroke: 0.75px
Arrow heads: 45° angle
```

### Glow Effect
```dart
BoxShadow(
  color: #E8FF47.withOpacity(0.25),
  blurRadius: 8,
  spreadRadius: 1,
)
```

---

## Brand Usage

### DO
- Use logo on dark backgrounds only
- Maintain minimum clear space
- Use approved color palette only

### DON'T
- Stretch or distort logo
- Add gradients to logo
- Place on busy backgrounds
- Use unauthorized colors
- Recreate logo from scratch

---

## Export Assets

### Required Files
```
assets/
├── logo/
│   ├── icon-primary.png (512x512)
│   ├── icon-adaptive-fg.png (432x432)
│   ├── logo-horizontal.png (800x200)
│   ├── logo-icon-only.png (200x200)
│   └── logo-monochrome.png (512x512)
├── screenshots/
│   ├── phone-1.png
│   ├── phone-2.png
│   └── ...
└── feature-graphic.png (1024x500)
```

---

## Metadata for Play Store

### App Name
**Inductor Calculator** — Color Code & Coil Design Tool

### Short Description
Calculate inductance from color bands. Design single-layer, multi-layer & flat spiral coils.

### Full Description
[See ASO documentation — include keyword-rich description]

### Category
Tools / Productivity

### Tags
`inductor calculator` `color code` `electronics` `coil` `inductance` `engineering` `tools`
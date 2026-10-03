# Lumio color palette v1

Proposed color system derived from the selected violet wordmark, purple Lumi mascot, golden tail and approved turquoise app icon. Exact values below are the implementation source of truth after approval; earlier generated images contain variation and have not been recolored.

| Color | HEX | RGB | Role |
|---|---|---|---|
| Lumio Violet | `#7651D6` | 118, 81, 214 | Wordmark, main buttons, selected states |
| Glow Gold | `#FFD34E` | 255, 211, 78 | Tail, rewards, achievement accents |
| Discovery Turquoise | `#20C8C4` | 32, 200, 196 | App icon, discovery panels, world accents |
| Soft Lilac | `#B8A0F2` | 184, 160, 242 | Belly patch, gentle purple illustration accents |
| Fresh Aqua | `#65E1D6` | 101, 225, 214 | Icon sweep, calm decorative backgrounds |
| Play Coral | `#F47B7F` | 244, 123, 127 | Warm illustration accents, character expression |
| Leaf Green | `#43C59E` | 67, 197, 158 | Nature worlds, progress decoration |
| Ink Plum | `#38234F` | 56, 35, 79 | Main text, mascot outlines, meaningful icons |
| Warm Cream | `#FFF4D9` | 255, 244, 217 | Welcoming child screens and reading surfaces |
| Clear White | `#FFFFFF` | 255, 255, 255 | Content cards and clean parent surfaces |
| Lilac Mist | `#F4F0FC` | 244, 240, 252 | Subtle page backgrounds and grouped sections |
| Quiet Slate | `#6A6275` | 106, 98, 117 | Secondary text and supporting descriptions |

## Hierarchy and usage

- Purple is the main brand/action color. Use one prominent primary action per view.
- Gold marks light and achievement. Keep it an accent; use plum for labels on gold.
- Turquoise is the main secondary color, linking the icon to exploration scenes. Use plum text on it.
- Start content screens with cream, white or mist. Let illustration areas carry stronger colors. Parent views use mostly white/mist with purple actions.
- Lilac, aqua, coral and leaf are supporting accents. Do not give every bright color equal visual weight.
- Keep lesson text and essential controls off busy artwork and gradients.
- Status always includes a readable label and icon; color alone does not communicate success, attention or error. Learning feedback stays encouraging. Use error styling for actionable form/system errors, not to shame wrong answers.

## Functional shades

| Token | HEX | Use |
|---|---|---|
| violet-pressed | `#5F3DB3` | Pressed primary action |
| success-ink | `#216E53` | Success text/icon on white |
| attention-ink | `#8A5700` | Attention text/icon on white |
| error-ink | `#A53345` | Form error text/icon on white |

These are functional shades, not additional equal-weight brand accents.

## Text contrast

Ratios computed from exact sRGB tokens using relative luminance. Pass/fail uses unrounded values; display values are rounded to two decimals. WCAG AA normal text minimum is 4.5:1; large text minimum is 3:1. This checks listed color pairs only, not whole-app accessibility.

| Use | Foreground | Background | Ratio | Normal-text result |
|---|---|---|---|---|
| Primary button | `#FFFFFF` | `#7651D6` | 5.36:1 | Pass |
| Reward label | `#38234F` | `#FFD34E` | 9.65:1 | Pass |
| Discovery panel | `#38234F` | `#20C8C4` | 6.65:1 | Pass |
| Child body text | `#38234F` | `#FFF4D9` | 12.62:1 | Pass |
| Secondary text | `#6A6275` | `#FFFFFF` | 5.81:1 | Pass |
| Success message | `#216E53` | `#FFFFFF` | 6.14:1 | Pass |
| Attention message | `#8A5700` | `#FFFFFF` | 6.10:1 | Pass |
| Form error | `#A53345` | `#FFFFFF` | 6.65:1 | Pass |
| Avoid white on turquoise | `#FFFFFF` | `#20C8C4` | 2.08:1 | Do not use |
| Avoid white on gold | `#FFFFFF` | `#FFD34E` | 1.43:1 | Do not use |

Source: [W3C WCAG 2.2, Understanding Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html). Color pairs apply to solid backgrounds; recheck changes in opacity, overlays and interaction states. Meaningful boundaries and focus indicators also need checks against adjacent colors in the final UI.

## Files

- `palette-board.svg` — precise scalable swatch board.
- `palette-board.png` — rendered board preview.
- `palette.html` — standalone browser view with exact token table and usage notes.
- `lumio-colors.css` — CSS custom properties.
- `lumio-colors.json` — framework-neutral colors, roles and RGB values.
- `contrast-checks.json` — numeric calculations.

Next stage: character expression sheet. No additional fonts or game code are included.

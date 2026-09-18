---
name: CampusMesh Design System
colors:
  surface: '#111317'
  surface-dim: '#111317'
  surface-bright: '#37393d'
  surface-container-lowest: '#0c0e11'
  surface-container-low: '#1a1c1f'
  surface-container: '#1e2023'
  surface-container-high: '#282a2d'
  surface-container-highest: '#333538'
  on-surface: '#e2e2e6'
  on-surface-variant: '#cbc3d7'
  inverse-surface: '#e2e2e6'
  inverse-on-surface: '#2f3034'
  outline: '#958ea0'
  outline-variant: '#494454'
  surface-tint: '#d0bcff'
  primary: '#d0bcff'
  on-primary: '#3c0091'
  primary-container: '#a078ff'
  on-primary-container: '#340080'
  inverse-primary: '#6d3bd7'
  secondary: '#4cd7f6'
  on-secondary: '#003640'
  secondary-container: '#03b5d3'
  on-secondary-container: '#00424e'
  tertiary: '#c4c6d0'
  on-tertiary: '#2d3038'
  tertiary-container: '#8e909a'
  on-tertiary-container: '#272a31'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#d0bcff'
  on-primary-fixed: '#23005c'
  on-primary-fixed-variant: '#5516be'
  secondary-fixed: '#acedff'
  secondary-fixed-dim: '#4cd7f6'
  on-secondary-fixed: '#001f26'
  on-secondary-fixed-variant: '#004e5c'
  tertiary-fixed: '#e0e2ec'
  tertiary-fixed-dim: '#c4c6d0'
  on-tertiary-fixed: '#191c23'
  on-tertiary-fixed-variant: '#44474f'
  background: '#111317'
  on-background: '#e2e2e6'
  surface-variant: '#333538'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system is engineered for Gen-Z students and educators, balancing high-energy digital native aesthetics with functional reliability in offline-first academic environments. The visual language evokes a vibrant, futuristic, yet grounded tone using a dark-themed, high-contrast palette. 

- **Personality:** Energetic, approachable, highly responsive, and cutting-edge.
- **Target Audience:** Digital-first students and faculty seeking instant, distraction-free connectivity.
- **Emotional Response:** Empowered, connected, focused, and visually delighted.
- **Design Style:** Modern Dark / Neumorphic-adjacent minimal with high-vibrancy accents, deep OLED blacks, and frosted glass touches.

## Colors

The color system relies on absolute OLED blacks and deep charcoals to maximize contrast and reduce eye strain in low-light campus environments. Vibrant electric purple serves as the primary anchor for core interactive states, while neon teal drives attention to secondary actions and status indicators.

- **Primary (`#8B5CF6`):** Used for primary buttons, active navigation, and key brand touchpoints.
- **Secondary (`#06B6D4`):** Used for accents, badges, online status indicators, and interactive highlights.
- **Surface & Cards (`#161920`):** Elevated structural containers sitting cleanly on the base canvas.
- **Background (`#0D0F12`):** The foundational OLED black canvas.
- **Text & Icons:** High-contrast pure white (`#F9FAFB`) for primary text and muted silver (`#9CA3AF`) for secondary metadata.

## Typography

Typography pairs clean, highly readable geometric grotesks with monospaced technical accents to reflect a modern student-developer vibe. `Inter` handles all primary reading surfaces, UI copy, and bold headers with optimized optical sizing. `JetBrains Mono` is reserved for timestamps, offline status badges, code snippets, and micro-labels. Ensure text contrast ratios consistently meet WCAG AAA standards against the deep charcoal surfaces.

## Layout & Spacing

This design system uses a fluid 12-column mobile-first grid adapted from Material 3 guidelines. Touch targets are generous, optimized for one-handed thumb navigation on mobile devices.

- **Breakpoints:** Mobile (`< 600px`), Tablet (`600px - 1024px`), Desktop (`> 1024px`).
- **Margins:** Outer canvas margins scale from `1.25rem` on mobile to `2rem` on desktop.
- **Gutters:** Consistent `1rem` column gaps prevent clutter in dense academic chat feeds.
- **Rhythm:** Spacing tokens must strictly dictate layout stacking, padding, and component gaps to maintain vertical rhythm.

## Elevation & Depth

Depth is established primarily through tonal layering and ambient glow rather than harsh drop shadows. Because the UI sits on an OLED black canvas, elevation is communicated by shifting surface lightness from `#0D0F12` (base) to `#161920` (cards) and `#1F242D` (active modals). 

- **Ambient Glow:** Key interactive elements feature low-opacity, wide-radius colored glows (using `#8B5CF6` at 15% opacity) to denote focus and active states.
- **Borders:** Low-contrast ghost borders (`1px solid rgba(255, 255, 255, 0.08)`) separate structural elements cleanly without relying on heavy lines.

## Shapes

The shape language utilizes a friendly, rounded aesthetic (`roundedness: 2`) that feels tactile and modern. 

- **Base Radius:** Standard UI elements (inputs, buttons, chips) use a `0.5rem` border radius.
- **Containers:** Large structural cards and modals use `1rem` (`rounded-lg`) to `1.5rem` (`rounded-xl`) radii.
- **Pills:** Status badges, avatars, and interactive filters use full pill-shape rounding (`9999px`) for a youthful, dynamic finish.

## Components

All components must inherit the tokenized properties for color, typography, and shape.

- **Buttons:** Primary actions feature solid electric purple fills with white text and subtle ambient glows on hover. Secondary actions use ghost styles with frosted glass backdrops.
- **Chips & Tags:** Pill-shaped elements using neon teal or muted surface tones to display course codes, offline sync status, or category filters.
- **Lists:** Clean rows with generous vertical padding, avatar or icon leading elements, primary body text, and trailing `JetBrains Mono` timestamps or unread count badges.
- **Checkboxes & Radios:** High-contrast custom controls with rounded geometry, utilizing primary purple fills and crisp checkmark/dot indicators when checked.
- **Input Fields:** Dark charcoal fields (`#161920`) featuring subtle inner borders, floating labels in `Inter`, and clear focus states with purple accent rings.
- **Cards:** Elevated surface containers with `1rem` rounding, soft padding, and thin ghost borders to organize announcements, assignments, and peer messages.
- **Additional (Mesh Status Indicator):** A specialized component tracking offline peer-to-peer connection strength using animated teal pulse dots and monospace data readouts.
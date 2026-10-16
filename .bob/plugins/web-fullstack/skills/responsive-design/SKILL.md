---
name: responsive-design
description: >-
  Use when the user wants to make a layout responsive, implement mobile-first CSS, fix responsive breakpoints, use CSS Grid or Flexbox for adaptive layouts, or ensure cross-device compatibility.
---

# Responsive Design

Build mobile-first layouts that adapt cleanly across all screen sizes.

## Step 1 — Start with Mobile Base Styles
Write all base CSS for the smallest viewport (320px). Never start with desktop and work down.

## Step 2 — Add Breakpoints with min-width
```css
/* Mobile base (default) */
.container { padding: 1rem; }

/* Tablet and up */
@media (min-width: 768px) {
  .container { padding: 2rem; }
}

/* Desktop and up */
@media (min-width: 1024px) {
  .container { max-width: 1200px; margin: 0 auto; }
}
```

## Step 3 — Use CSS Grid for 2D Layouts
```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}
```

## Step 4 — Fluid Typography
```css
:root {
  --font-size-base: clamp(1rem, 0.9rem + 0.5vw, 1.125rem);
}
body { font-size: var(--font-size-base); }
```

## Step 5 — Test Across Devices
1. Test in Chrome DevTools Device Mode at 375px, 768px, 1024px, 1440px.
2. Test on a real mobile device if possible.
3. Check touch target sizes: minimum 44x44px.

## Verification Checklist
- [ ] Mobile layout works at 320px
- [ ] No horizontal scroll on any breakpoint
- [ ] Touch targets ≥ 44x44px
- [ ] Images are responsive (max-width: 100%)

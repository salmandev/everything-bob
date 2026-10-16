---
name: accessibility-auditor
description: >-
  Use when the user wants to audit a web UI for accessibility, fix WCAG violations, improve keyboard navigation, add ARIA labels, test with a screen reader, or ensure an app meets WCAG 2.1 AA compliance.
---

# Accessibility Auditor

Audit and fix accessibility issues systematically. Target WCAG 2.1 AA as the baseline.

## Step 1 — Automated Scan First
```bash
# Axe-core CLI scan
npx @axe-core/cli http://localhost:3000 --exit

# Lighthouse accessibility audit
npx lighthouse http://localhost:3000 --only-categories=accessibility --output=json
```

## Step 2 — WCAG 2.1 AA Checklist

### Perceivable
- [ ] All `<img>` have meaningful `alt` text (or `alt=""` if decorative)
- [ ] Color is not the only means of conveying information
- [ ] Text has 4.5:1 contrast ratio (3:1 for large text 18px+)
- [ ] Videos have captions; audio has transcripts

### Operable
- [ ] All functionality reachable via keyboard alone (no mouse required)
- [ ] Keyboard focus is always visible (`outline` not `outline: none`)
- [ ] No keyboard traps — user can always `Tab` away
- [ ] Skip navigation link at top of page
- [ ] No content that flashes more than 3 times per second

### Understandable
- [ ] `<html lang="en">` set on every page
- [ ] Form inputs have associated `<label>` elements
- [ ] Error messages identify the specific field and how to fix it
- [ ] Page title is descriptive and unique per page

### Robust
- [ ] HTML validates (no unclosed tags, no duplicate IDs)
- [ ] ARIA roles used only where semantic HTML is insufficient
- [ ] `aria-label` / `aria-labelledby` on all interactive elements lacking visible text

## Step 3 — Fix Common Violations

**Missing alt text**:
```html
<!-- Bad -->
<img src="chart.png">
<!-- Good -->
<img src="chart.png" alt="Bar chart showing Q4 revenue up 23% vs Q3">
<!-- Decorative -->
<img src="divider.svg" alt="">
```

**Poor focus management in modals**:
```typescript
// When modal opens: move focus into it
modalRef.current?.focus();
// When modal closes: return focus to trigger
triggerRef.current?.focus();
// Trap focus inside modal while open
// Use: @radix-ui/react-dialog or focus-trap-react
```

**Inaccessible icon buttons**:
```html
<!-- Bad -->
<button><svg>...</svg></button>
<!-- Good -->
<button aria-label="Close dialog"><svg aria-hidden="true">...</svg></button>
```

**Missing form labels**:
```html
<!-- Bad -->
<input type="email" placeholder="Email">
<!-- Good -->
<label for="email">Email address</label>
<input id="email" type="email" autocomplete="email">
```

## Step 4 — Test with Real Assistive Technology
1. **macOS VoiceOver**: `Cmd+F5` to toggle. Tab through the page. Does every element announce correctly?
2. **NVDA (Windows, free)**: Download from nvaccess.org. Test with Chrome.
3. **Keyboard only**: Unplug your mouse. Can you complete every user journey?

## Verification Checklist
- [ ] Axe-core scan passes with zero violations
- [ ] Lighthouse accessibility score ≥ 90
- [ ] Keyboard navigation tested for all critical flows
- [ ] Color contrast ratio verified for all text
- [ ] All form fields have visible, associated labels

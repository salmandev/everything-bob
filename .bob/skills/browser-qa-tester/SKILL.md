---
name: browser-qa-tester
description: >-
  Use when the user wants to test a web UI, automate browser interactions, write end-to-end tests, check for visual regressions, test accessibility, or verify user flows in a browser.
---

# Browser QA Tester

Automate browser testing systematically. Cover the critical user paths.

## Step 1 — Identify Critical User Paths
1. List the 3-5 most important user flows (registration, checkout, login, key feature).
2. For each flow, define: starting state, steps, expected end state.

## Step 2 — Set Up the Test Framework
For Playwright (recommended):
```bash
npm install --save-dev @playwright/test
npx playwright install
```

## Step 3 — Write End-to-End Tests
```typescript
import { test, expect } from '@playwright/test';

test('user can log in', async ({ page }) => {
  await page.goto('http://localhost:3000/login');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Dashboard');
});
```

## Step 4 — Capture Screenshots on Failure
```typescript
test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    await page.screenshot({ path: `screenshots/${testInfo.title}.png` });
  }
});
```

## Step 5 — Test Accessibility
```bash
npx @axe-core/cli http://localhost:3000
```

## Step 6 — Run Tests
```bash
npx playwright test
npx playwright test --headed  # visible browser
npx playwright show-report    # HTML report
```

## Verification Checklist
- [ ] All critical user paths covered
- [ ] Tests run headlessly in CI
- [ ] Screenshots captured on failure
- [ ] Accessibility check passes

---
name: feature-flag-workflow
description: >-
  Use when the user wants to implement feature flags, use LaunchDarkly or Unleash, wrap new code in a feature toggle, do a gradual rollout, implement trunk-based development with flags, or safely remove a retired feature flag.
---

# Feature Flag Workflow

Implement feature flags for safe deployment — ship code without shipping features.

## Step 1 — Choose the Right Flag Type
| Type | Use For | Example |
| --- | --- | --- |
| Release toggle | Hide unfinished features | New checkout flow |
| Experiment | A/B testing | Button color test |
| Ops toggle | Kill switch for risky ops | New payment provider |
| Permission toggle | Role-based features | Beta user access |

## Step 2 — Implement with LaunchDarkly (TypeScript)
```typescript
import * as ld from '@launchdarkly/node-server-sdk';

const ldClient = ld.init(process.env.LAUNCHDARKLY_SDK_KEY!);
await ldClient.waitForInitialization();

// Evaluate a flag
const user = { kind: 'user', key: userId, email: userEmail };
const showNewCheckout = await ldClient.variation('new-checkout-flow', user, false);

if (showNewCheckout) {
  return <NewCheckout />;
} else {
  return <OldCheckout />;
}
```

## Step 3 — Implement with Environment Variables (Simple)
For simple boolean flags without a service:
```typescript
// config/flags.ts
export const FLAGS = {
  NEW_CHECKOUT: process.env.FLAG_NEW_CHECKOUT === 'true',
  PAYMENT_V2: process.env.FLAG_PAYMENT_V2 === 'true',
} as const;

// Usage
import { FLAGS } from '@/config/flags';
if (FLAGS.NEW_CHECKOUT) { ... }
```

## Step 4 — Wrap Code, Not Entire Files
```typescript
// Bad — entire function replaced
export async function processPayment(order: Order) {
  if (FLAGS.PAYMENT_V2) {
    // 200 lines of new code
  } else {
    // 200 lines of old code
  }
}

// Good — small, targeted flag
export async function processPayment(order: Order) {
  const provider = FLAGS.PAYMENT_V2 ? new StripeV2() : new StripeV1();
  return provider.charge(order);
}
```

## Step 5 — Flag Lifecycle and Cleanup
Flags have a lifespan. Document and retire them:
```typescript
// Add a comment with expiry
// FLAG: new-checkout-flow — retire after 2025-12-01 once rollout is 100%
const showNewCheckout = await ldClient.variation('new-checkout-flow', user, true);
```

Cleanup process:
1. Set flag to 100% on for 1 week — observe for issues
2. Remove the flag evaluation and old code branch
3. Remove the flag from LaunchDarkly/config
4. Commit: `chore: remove new-checkout-flow flag (fully rolled out)`

## Verification Checklist
- [ ] Flag defaults to the **safe/old** behavior when the flag service is unavailable
- [ ] Flag name follows a consistent convention (`kebab-case`)
- [ ] Expiry date documented in a comment near the flag evaluation
- [ ] Feature works correctly with flag both ON and OFF
- [ ] Cleanup task created in backlog when flag is created

---
name: root-cause-debugger
description: >-
  Use when the user reports a bug, a regression, or an unexpected failure and needs to find the root cause — not just patch the symptom. Also use when git bisect, reproduction cases, or traceback analysis is needed.
---

# Root Cause Debugger

Find the exact cause of a failure before writing a single fix. Never patch symptoms.

## Step 1 — Reproduce the Failure
1. Write the minimal reproduction case: the fewest lines of code that trigger the bug.
2. Confirm the reproduction is stable — it fails consistently, not intermittently.
3. Run it: `execute_command` to capture the exact error message and stack trace.

## Step 2 — Parse the Stack Trace
1. Read every frame of the stack trace from bottom (root) to top (surface).
2. Identify the first frame that is your code (not a library frame).
3. Open that file and read the surrounding context.

## Step 3 — Use git bisect for Regressions
If this used to work but no longer does:
```bash
git bisect start
git bisect bad HEAD
git bisect good <last-known-good-commit>
# git will check out commits automatically
# Run your reproduction case each time:
git bisect run npm test -- --testNamePattern="broken test"
# When done:
git bisect reset
```

## Step 4 — Form a Hypothesis
1. State the hypothesis explicitly: "I believe the bug is caused by X because Y."
2. Identify one test that would confirm or deny the hypothesis.
3. Run it. If confirmed, proceed. If denied, return to Step 2.

## Step 5 — Apply a Surgical Fix
1. Change only what is needed to fix the root cause. No cleanup, no refactoring.
2. Add a regression test that would have caught this bug originally.
3. Run the full test suite to confirm no regressions.

## Verification Checklist
- [ ] Root cause identified (not just the symptom)
- [ ] Minimal reproduction case exists and is committed to tests
- [ ] Fix is minimal and targeted
- [ ] Regression test added
- [ ] Full test suite passes

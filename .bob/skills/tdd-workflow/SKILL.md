---
name: tdd-workflow
description: >-
  Use when the user wants to write tests first, follow test-driven development, implement Red-Green-Refactor, or ensure code is covered by tests before writing implementation.
---

# TDD Workflow

Follow the strict Red-Green-Refactor cycle. Never write production code before a failing test.

## Step 1 — Write a Failing Test (Red)
1. Identify the smallest unit of behavior to implement.
2. Write a test that precisely captures the expected behavior. Run it — confirm it fails.
3. Use `execute_command` to run the test suite and capture the failure output.

## Step 2 — Write Minimal Implementation (Green)
1. Write the minimum code to make the failing test pass.
2. Do not add anything beyond what the test requires.
3. Run the test suite again — confirm only the target test passes.

## Step 3 — Refactor (Refactor)
1. Clean up the implementation: remove duplication, improve naming, extract abstractions.
2. Run the full test suite after each refactor step — all tests must remain green.
3. Commit with: `test: add <behavior> spec` then `feat: implement <behavior>`.

## Step 4 — Repeat
1. Pick the next failing test case and repeat from Step 1.

## Verification Checklist
- [ ] Every new behavior has a test written before implementation
- [ ] No test is skipped or commented out
- [ ] All tests pass after the refactor step
- [ ] Coverage is not reduced from the starting baseline

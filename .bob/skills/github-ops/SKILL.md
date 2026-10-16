---
name: github-ops
description: >-
  Use when the user wants to automate GitHub workflows, generate PR descriptions, triage issues, configure branch protection, set up semantic releases, or use the GitHub CLI or GitHub MCP tools.
---

# Github Ops

## Overview
Follow this workflow when implementing Github Ops patterns.

## Step 1 — Assess the Requirements
1. Read the existing codebase to understand what is already in place.
2. Identify the specific sub-problem within Github Ops: what exactly needs to be built?
3. Look for existing patterns in the codebase to follow.

## Step 2 — Implement with Best Practices
1. Follow the established conventions for Github Ops in this project.
2. Write typed, testable code — no  types, no magic strings.
3. Handle errors explicitly — no silent failures.

## Step 3 — Add Tests
1. Write unit tests for the core logic.
2. Write integration tests for external dependencies.
3. Run the full test suite to confirm no regressions.

## Step 4 — Document
1. Add inline comments for non-obvious logic.
2. Update the README or relevant documentation if the interface changes.

## Verification Checklist
- [ ] Implementation follows existing project conventions
- [ ] All error paths are handled
- [ ] Tests written and passing
- [ ] No unused code or imports left behind

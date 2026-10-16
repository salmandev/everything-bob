---
name: trpc-react-query
description: >-
  Use when the user wants to build with tRPC, set up end-to-end type safety between client and server, configure TanStack React Query, implement optimistic updates, or use tRPC v11 routers.
---

# Trpc React Query

## Overview
Follow this workflow when implementing Trpc React Query patterns.

## Step 1 — Assess the Requirements
1. Read the existing codebase to understand what is already in place.
2. Identify the specific sub-problem within Trpc React Query: what exactly needs to be built?
3. Look for existing patterns in the codebase to follow.

## Step 2 — Implement with Best Practices
1. Follow the established conventions for Trpc React Query in this project.
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

---
name: repo-onboarding
description: >-
  Use when Bob is starting work on an unfamiliar codebase, needs to understand a new repository's structure, wants to build context before making changes, or the user asks Bob to "learn this codebase" or "understand the project".
---

# Repository Onboarding

Build accurate context about this codebase before making any changes.

## Step 1 — Understand the Project Purpose
1. Read `README.md`, `package.json` / `pyproject.toml` / `Cargo.toml`, and `CHANGELOG.md`.
2. Identify: language, framework, main entry points, test runner, build system.

## Step 2 — Map the Directory Structure
1. Use `list_files` on the root directory to understand the top-level layout.
2. Identify: `src/`, `tests/`, `docs/`, config files, CI workflows.

## Step 3 — Find Key Abstractions
1. Use `grep` to locate main exports, route definitions, and database models.
2. Read the top 3 most-changed files in recent git history: `git log --oneline --name-only -20`.

## Step 4 — Understand Testing Infrastructure
1. Locate and read test configuration (`jest.config.js`, `pytest.ini`, `vitest.config.ts`, etc.).
2. Run the test suite dry-run to confirm everything passes before changes: `npm test -- --dry-run` or equivalent.

## Step 5 — Summarize Context
1. Write a concise summary: purpose, key modules, architecture pattern, test runner, and any known debt.
2. State what you now understand and what you are about to do.

## Verification Checklist
- [ ] Language, framework, and build system identified
- [ ] Key entry points and modules located
- [ ] Test runner confirmed working
- [ ] No assumptions made without evidence from the codebase

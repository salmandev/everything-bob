---
name: git-craftsman
description: >-
  Use when the user wants to write a commit message, create a pull request, review git history, squash commits, write a clean changelog entry, or enforce conventional commit standards.
---

# Git Craftsman

Enforce clean git hygiene: atomic commits, conventional messages, clean PR descriptions.

## Step 1 — Ensure Atomic Changes
1. Each commit should represent one logical change — not a mix of features, fixes, and refactors.
2. Use `git diff --staged` to review exactly what will be committed.
3. If the staged diff contains unrelated changes, split them: `git add -p`.

## Step 2 — Write Conventional Commit Messages
Format: `<type>(<scope>): <imperative summary>`

| Type | When to use |
| --- | --- |
| `feat` | New feature or behavior |
| `fix` | Bug fix |
| `refactor` | Code change with no behavior change |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `chore` | Build, CI, dependency updates |
| `perf` | Performance improvement |

Example: `feat(auth): add JWT refresh token rotation`

## Step 3 — Write a Pull Request Description
```markdown
## Summary
One paragraph: what does this PR do and why?

## Changes
- List each significant change
- Keep it to 3-7 bullet points

## Testing
How was this tested? What coverage was added?

## Screenshots (if UI change)
Before / After
```

## Step 4 — Validate Before Pushing
1. Run `git log --oneline -10` — confirm history is clean.
2. Run full test suite — no failures before pushing.
3. Run `git push` only after tests pass.

## Verification Checklist
- [ ] Commits are atomic (one logical change each)
- [ ] Commit messages follow Conventional Commits format
- [ ] PR description is complete
- [ ] Tests pass on the branch

---
name: code-review-workflow
description: >-
  Use when the user wants Bob to review code, audit a pull request, check a diff for bugs or issues, review someone else's code changes, or produce a structured code review with findings and recommendations.
---

# Code Review Workflow

Produce rigorous, evidence-based code reviews. Every finding has a location, severity, and fix.

## Step 1 — Get the Diff
```bash
# Review the current working changes
git diff HEAD

# Review a specific PR branch vs main
git diff main..feature/my-feature

# Review a specific commit
git show <commit-hash>
```

## Step 2 — Systematic Review Checklist
Work through each category methodically:

### Correctness
- [ ] Logic is correct for happy path
- [ ] Edge cases handled: null/undefined, empty collections, boundary values
- [ ] Error paths all handled — no silent failures
- [ ] No off-by-one errors in loops or array accesses

### Security
- [ ] No hardcoded credentials or API keys
- [ ] User input validated/sanitized before use
- [ ] No SQL string concatenation
- [ ] Auth checks present on protected operations

### Performance
- [ ] No N+1 query patterns introduced
- [ ] No synchronous operations that should be async
- [ ] No unbounded loops or collections

### Maintainability
- [ ] Function/variable names are clear and accurate
- [ ] Functions do one thing (single responsibility)
- [ ] No duplicate logic (DRY)
- [ ] Complex logic has comments explaining *why*, not *what*

### Tests
- [ ] New behavior has tests
- [ ] Existing tests not silently broken
- [ ] Test names describe the behavior being tested

## Step 3 — Format Each Finding
```
**[SEVERITY]** `path/to/file.ts:42`
> Code snippet that has the issue

**Issue**: What is wrong and why it matters.
**Fix**: Concrete suggestion — ideally with corrected code.
```

Severity levels: `CRITICAL` | `HIGH` | `MEDIUM` | `LOW` | `NIT`

## Step 4 — Write the Review Summary
```markdown
## Code Review — <branch/PR name>

**Verdict**: ✅ Approve | ⚠️ Approve with suggestions | 🚫 Request changes

### Summary
One paragraph: overall quality, what this PR does well, main concerns.

### Findings
[findings from Step 3]

### Positive Observations
What the author did well (always include at least one).
```

## Verification Checklist
- [ ] Every finding cites a specific file and line number
- [ ] No speculative findings without evidence in the code
- [ ] At least one positive observation included
- [ ] Critical/High findings have concrete fix suggestions

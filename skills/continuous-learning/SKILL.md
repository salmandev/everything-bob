---
name: continuous-learning
description: >-
  Use when Bob makes a mistake, receives a correction, learns a team convention, or the user wants Bob to remember a pattern, rule, or preference for future work in this project.
---

# Continuous Learning

Codify corrections and conventions into durable Bob rules so they persist across sessions.

## Step 1 — Identify What to Remember
1. Was this a correction to Bob's behavior? (e.g., "don't use X library", "always add tests", "use Y pattern")
2. Is this a team convention? (e.g., naming conventions, file structure, commit style)
3. Is this a project-specific constraint? (e.g., "this table is read-only", "never call this API directly")

## Step 2 — Determine the Right Storage Location
- **Project-wide rule**: Create or update `.bob/rules/<category>.md`
- **Language-specific**: Create or update `.bob/rules/languages/<lang>.md`
- **Methodology**: Create or update `.bob/rules/paradigms/<name>.md`
- **Temporary context**: Write to `.bob/context/<topic>.md` with an expiry note

## Step 3 — Write the Rule
Format rules as actionable commands:
```markdown
# <Category> Rules

## <N>. <Rule Group Name>
1. **Always**: <concrete positive instruction>
2. **Never**: <concrete negative instruction>
3. **When X**: <conditional instruction>
```

## Step 4 — Confirm the Rule
1. Show the written rule to the user.
2. Ask: "Is this rule accurate and complete?"
3. Revise if needed before committing.

## Step 5 — Commit the Rule
```bash
git add .bob/rules/
git commit -m "chore: add learned rule — <brief description>"
```

## Verification Checklist
- [ ] Rule is actionable (not vague)
- [ ] Rule is in the correct category file
- [ ] Rule is confirmed accurate by the user
- [ ] Rule is committed to version control

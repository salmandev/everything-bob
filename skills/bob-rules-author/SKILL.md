---
name: bob-rules-author
description: >-
  Use when the user wants to write a BOB.md rule file, create project-specific instructions for Bob, add coding standards or conventions that Bob should follow in this workspace, or understand how Bob loads and applies rules.
---

# Bob Rules Author

Write effective, actionable BOB.md rule files that Bob consistently follows.

## Step 1 — Understand How Bob Loads Rules
Bob discovers rule files by searching for `BOB.md` (and markdown files in `.bob/rules/`) starting from the current working directory and walking up to the repo root. Rules are loaded into Bob's system context for every conversation in that workspace.

Rule file locations (all are loaded if present):
```
.bob/rules/BOB.md              # Primary workspace rules
.bob/rules/languages/ts.md     # Language-specific rules
.bob/rules/paradigms/tdd.md    # Methodology rules
BOB.md                         # Root-level rules (also loaded)
```

## Step 2 — Anatomy of an Effective Rule
Bad rule (vague, ignored):
```markdown
- Write good code
- Be careful with databases
```

Good rule (specific, actionable, verifiable):
```markdown
## 3. Database Access Rules
1. **Never use raw string concatenation in SQL**: All queries must use parameterized statements or an ORM.
2. **Always check affected row count**: After UPDATE/DELETE, verify `rowCount > 0` before proceeding.
3. **No migrations in application startup**: Migrations run as a separate step in CI, never on app boot.
```

Rules that work:
- Start with a verb: **Never**, **Always**, **Use**, **Prefer**, **When X, do Y**
- Are specific enough to be checkable
- Give the reason when non-obvious

## Step 3 — Rule File Structure Template
```markdown
# [Project/Domain] Rules for Bob

Brief one-line context about this project.

---

## 1. [Category Name]
1. **[Action word]**: Concrete instruction with no ambiguity.
2. **[Action word]**: Another instruction.
   - Sub-detail if needed.

## 2. [Another Category]
...
```

## Step 4 — Common Rule Categories
- **Code Style**: formatting, naming conventions, file structure
- **Architecture**: which patterns to use/avoid, layer boundaries
- **Testing**: coverage requirements, test naming, forbidden test patterns
- **Security**: secret handling, input validation, auth patterns
- **Workflow**: commit message format, PR process, deploy process
- **Domain**: business logic rules, entity invariants, data constraints

## Step 5 — Write the File
Use `write_file` to create `.bob/rules/BOB.md` (or a more specific file like `.bob/rules/languages/typescript.md`).

Commit it to version control so the whole team benefits:
```bash
git add .bob/rules/
git commit -m "chore: add Bob workspace rules for [project name]"
```

## Verification Checklist
- [ ] Rules are actionable (start with a verb)
- [ ] Rules are specific (checkable without ambiguity)
- [ ] Rules are committed to version control
- [ ] No contradictions between rule files
- [ ] Tested: start a new Bob session and verify Bob references the rules

---
name: bob-skill-author
description: >-
  Use when the user wants to create a new Bob skill, write a SKILL.md file, contribute a skill to the everything-bob catalog, or understand how Bob skill auto-invocation works.
---

# Bob Skill Author

Write Bob skills that auto-invoke correctly and provide actionable procedural guidance.

## Step 1 — Validate the Skill Concept
Before writing anything, answer:
- Is this a **recurring workflow** Bob will need many times? (Skills are for workflows, not one-offs)
- Is the **description** specific enough to trigger reliably? Vague descriptions cause false positives.
- Does this need to be **one skill** or could it be split into two focused skills?

## Step 2 — Choose the Skill Name
Rules for the directory name (which becomes the skill name):
- Pattern: `^[a-z0-9]+(-[a-z0-9]+)*$`
- Lowercase, digits, single dashes between words
- Maximum 64 characters
- **Invalid names fail silently** — no error, skill just doesn't load

## Step 3 — Write the SKILL.md
```markdown
---
name: my-skill-name
description: >-
  Use when the user wants to ... (concrete trigger phrases in third person).
---

# My Skill Title

Brief one-sentence overview.

## Step 1 — First Action
1. Specific sub-step
2. Another sub-step

## Step 2 — Second Action
...

## Verification Checklist
- [ ] Specific outcome verified
- [ ] No regressions introduced
```

## Step 4 — Choose the Location
- **Workspace skill**: `.bob/skills/<name>/SKILL.md` (only this project)
- **Global skill**: `~/.bob/skills/<name>/SKILL.md` (all projects)
- **everything-bob catalog**: `skills/<name>/SKILL.md` (shareable)

## Step 5 — Validate and Test
```bash
./bin/everything-bob test-skill my-skill-name
```

## Step 6 — Test Auto-Invocation
Start a new Bob conversation and use a phrase that should trigger the skill. Confirm Bob invokes it.

## Verification Checklist
- [ ] Skill name matches directory name exactly
- [ ] `description` starts with "Use when..."
- [ ] Body has numbered procedural steps
- [ ] `./bin/everything-bob test-skill <name>` passes
- [ ] Skill auto-invokes in a new conversation

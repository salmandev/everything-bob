# Skill Authoring Guide

## The Anatomy of a SKILL.md

```
---                          ← frontmatter start (required)
name: my-skill               ← matches directory name exactly
description: >-              ← auto-invocation trigger (most important field)
  Use when the user wants to ... (concrete trigger phrases)
---                          ← frontmatter end

# My Skill Title             ← human-readable title

Procedural steps that Bob follows when the skill is invoked.
```

## Writing Effective Descriptions

The `description` field is the auto-invocation trigger. Bob compares your message against all skill descriptions to decide which skill to load. Write it as:
- Third person: "Use when the user wants to..."
- Concrete: mention specific nouns (frameworks, tools, actions)
- Not vague: "Use when the user needs help" does NOT work

Good: `Use when the user wants to write Playwright end-to-end tests, automate browser interactions, or check for visual regressions.`

Bad: `Use when the user needs testing assistance.`

## Skill Name Validation

The skill directory name becomes the skill name. It MUST match this pattern:
```
^[a-z0-9]+(-[a-z0-9]+)*$
```

Invalid names fail **silently** — the skill loads but never auto-invokes.

## Testing Your Skill

```bash
./bin/everything-bob test-skill my-skill-name
```

Then start a new Bob conversation and type a sentence that should trigger it.

---
name: everything-bob-maintainer
description: >-
  Use when maintaining, auditing, expanding, or contributing to the everything-bob repository itself — adding new skills, hooks, rules, modes, agents, or running the test and validation suite.
---

# Everything Bob Maintainer Skill

Use this workflow when working on the `everything-bob` repository itself.

## Step 1 — Identify the Contribution Type

Determine what kind of component you are adding or modifying:
- **Skill**: A new `skills/<name>/SKILL.md` progressive-disclosure playbook
- **Hook**: A new `hooks/<name>/` bundle with `hooks.json` + shell script
- **Rule**: A new or updated file in `rules/common/`, `rules/languages/`, or `rules/paradigms/`
- **Mode**: A new entry in `modes/custom_modes.yaml`
- **Agent**: A new `agents/<name>.md` subagent spec
- **Plugin**: A new `plugins/<name>/` domain bundle

## Step 2 — Create or Edit the Component

Follow the standards in `.bob/rules/everything-bob-dev.md`.

For a new skill:
```bash
./bin/everything-bob new-skill <skill-name>
```

For a new agent spec:
```bash
./bin/everything-bob new-agent <agent-name>
```

## Step 3 — Validate

```bash
# Validate a specific skill
./bin/everything-bob test-skill <skill-name>

# Validate all frontmatter, JSON schemas, hooks
./bin/everything-bob validate

# Full benchmark suite
npm test
```

## Step 4 — Commit with Conventional Commits

```bash
git add .
git commit -m "feat: add <name> skill/hook/rule/mode"
```

## Verification Checklist
- [ ] `npm test` passes with no new failures
- [ ] `./bin/everything-bob validate` passes
- [ ] Skill validated with `./bin/everything-bob test-skill <name>` if applicable
- [ ] No hardcoded secrets or credentials in any committed file

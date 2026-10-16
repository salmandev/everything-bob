# Contributing to Everything Bob

Thank you for helping make IBM Bob even better! This guide covers how to contribute new skills, hooks, rules, modes, agents, and MCP blueprints.

---

## Getting Started

```bash
git clone https://github.com/salmandev/everything-bob.git
cd everything-bob
npm install
npm test
```

## Contribution Types

### 1. New Skill (`skills/<name>/SKILL.md`)

A skill is a progressive-disclosure playbook Bob auto-invokes when the user's request matches the skill's `description`.

**Requirements:**
- Directory name: `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, dashes only)
- `SKILL.md` must have valid YAML frontmatter with `name` and `description`
- `description` should start with "Use when..." and name concrete trigger phrases
- Body must be procedural, step-numbered, and actionable

**Validate before submitting:**
```bash
./bin/everything-bob test-skill your-skill-name
```

### 2. New Lifecycle Hook (`hooks/<name>/`)

A hook bundle contains:
- `hooks.json` — maps lifecycle events to shell scripts
- `scripts/<name>.sh` — the shell script (must be executable)

**Supported events:** `PreToolUse`, `PostToolUse`, `PreInvocation`, `PostInvocation`, `Stop`

**Shell script contract:**
- Reads JSON payload from `stdin`
- Writes JSON decision to `stdout` for `PreToolUse`/`Stop`:
  - `{"decision": "allow"}` — proceed
  - `{"decision": "deny", "reason": "..."}` — block
  - `{"decision": "ask", "reason": "..."}` — ask user
- Non-zero exit code = hook error (treated as allow)

### 3. New Rule (`rules/<category>/<name>.md`)

Rules are plain Markdown. Categories:
- `rules/common/` — foundational, applies everywhere
- `rules/languages/` — language-specific (typescript, python, golang, etc.)
- `rules/paradigms/` — methodology-specific (tdd, security-hardened, clean-architecture)

Keep rules **actionable** and **specific** — avoid vague platitudes.

### 4. New Custom Mode (`modes/`)

Add an entry to `modes/custom_modes.yaml`. Valid permission groups:
`read`, `edit`, `execute`, `mcp`, `skill`, `todo`, `subagent`, `mode`

Validate slug uniqueness before submitting. Slug must match `^[a-zA-Z0-9-]+$`.

### 5. New Subagent Spec (`agents/<name>.md`)

A Markdown file describing a specialized Bob subagent. Include:
- Role & Mission
- Permitted Tools & Scope
- Operating Principles
- Handoff & Synthesis format

### 6. New MCP Blueprint (`mcp/`)

A `README.md` and `mcp_config.example.json` describing how to wire an MCP server into Bob's config.

---

## Code Standards

- All shell scripts: `#!/usr/bin/env bash`, `set -eo pipefail`, executable (`chmod +x`)
- All JSON: valid, formatted, no trailing commas
- All SKILL.md: valid YAML frontmatter, procedural body with numbered steps
- CLI changes: update `tests/cli.test.js`

## Validation

```bash
npm test                          # Full test suite
./bin/everything-bob validate     # Schema validation
./bin/everything-bob test-all     # Benchmark all components
```

## Pull Request Checklist

- [ ] `npm test` passes with no new failures
- [ ] `./bin/everything-bob validate` passes
- [ ] New skills validated with `./bin/everything-bob test-skill <name>`
- [ ] PR title follows Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- [ ] Description explains what the contribution enables for Bob users

---

## Community Wishlist

High-priority contributions needed:

| Type | Description |
| :--- | :--- |
| Skill | `watsonx-integration` — IBM watsonx.ai model deployment and prompt engineering |
| Skill | `ibm-cloud-deploy` — IBM Cloud Foundry, Code Engine, and Kubernetes deployment |
| Skill | `db2-migrations` — Db2 schema migrations, lock avoidance, and query optimization |
| Skill | `ibm-i-rpg` — IBM i RPG and CL programming best practices |
| Skill | `zos-jcl` — z/OS JCL job authoring and submission patterns |
| Hook | `ibm-compliance-gate` — Enterprise compliance check before destructive operations |
| Mode | `bob-ibm-cloud-engineer` — IBM Cloud architecture persona |
| MCP | `ibm-github-enterprise` — IBM GitHub Enterprise MCP server blueprint |

---

## License

By contributing, you agree your contributions are licensed under Apache 2.0.

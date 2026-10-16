# Everything Bob Development Rules

These rules govern all work done within the everything-bob repository itself.

## Skill Authoring Standards
- Every new skill goes in `skills/<skill-name>/SKILL.md` with valid YAML frontmatter
- `name` field must match the directory name exactly
- `description` must start with "Use when..." and name concrete trigger phrases
- Skill body must have numbered steps — no vague prose
- Run `./bin/everything-bob test-skill <name>` before committing

## Hook Script Standards
- All scripts: `#!/usr/bin/env bash`, `set -eo pipefail`
- All scripts must be executable (`chmod +x`)
- `PreToolUse` hooks must output valid JSON on stdout: `{"decision": "allow|deny|ask"}`
- Test hook with: `echo '{"toolCall":{"name":"execute_command","args":{"command":"rm -rf /"}}}' | bash hooks/<name>/scripts/<script>.sh`

## Rule File Standards
- Rules must be actionable and specific — no vague platitudes
- Each rule has a number and a sub-numbered list for precision
- Language in second-person present tense ("Use X", "Never do Y", "Always verify Z")

## Mode Standards
- Slug must match `^[a-zA-Z0-9-]+$` and be unique across all files
- Only use valid group names: read, edit, execute, mcp, skill, todo, subagent, mode
- No curly quotes, em-dashes, or non-breaking spaces in YAML

## Commit Standards
- Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- Reference skill/hook name in commit body: `feat: add tdd-workflow skill`
- Run `npm test` before every commit

# IBM Bob Architecture & Internals

## How Bob Loads Skills

Bob scans the `.bob/skills/` directory (workspace) and `~/.bob/skills/` (global) at startup.
For each `<skill-name>/SKILL.md` found, it extracts only the `name` and `description` frontmatter fields and adds them to the system prompt as a lightweight catalog entry.

When you send a message, Bob's description-matching evaluates whether any skill description closely matches your intent. If it does, Bob invokes `use_skill("<skill-name>")`, which loads the full SKILL.md body into context. The full body is NOT in the prompt until that moment — this is progressive disclosure.

**Key insight**: With 30 skills at ~1,200 tokens each, the full catalog body = ~36,000 tokens. With progressive disclosure, the per-turn cost is just the frontmatter summaries = ~400 tokens. That's a 98% reduction in per-turn skill overhead.

## How Bob Processes Hooks

Bob reads `hooks.json` from `.bob/hooks.json` (workspace) or `~/.bob/hooks.json` (global) at session start.

Supported lifecycle events:
- `PreToolUse` — runs before Bob executes a tool. Can `allow`, `deny`, or `ask`.
- `PostToolUse` — runs after a tool completes. Used for auto-formatting, logging.
- `PreInvocation` — runs before each model reasoning step. Used for context injection.
- `PostInvocation` — runs after each reasoning step. Used for learning instincts.
- `Stop` — runs when Bob is about to stop. Can `stop` or `continue` (with a reason).

Hook scripts receive JSON on `stdin` and must write their JSON decision to `stdout`.

## How Bob Resolves Mode Permissions

Custom modes defined in `custom_modes.yaml` (workspace: `.bob/custom_modes.yaml`, global: `~/.bob/settings/custom_modes.yaml`) grant specific tool permission groups to a persona.

Permission resolution:
1. Start with no permissions
2. Add each group listed in `groups:`
3. If a group has `fileRegex:`, restrict that group to matching paths only

Workspace modes take precedence over global modes with the same slug.

---
name: bob-hook-author
description: >-
  Use when the user wants to create a new Bob lifecycle hook, write a hooks.json file, write a PreToolUse or Stop hook script, intercept tool calls in Bob, auto-format files after Bob writes them, or prevent Bob from stopping prematurely.
---

# Bob Hook Author

Write and wire lifecycle hooks that run shell commands at Bob's critical execution moments.

## Step 1 — Understand the Lifecycle Events
| Event | When it fires | Common use |
| --- | --- | --- |
| `PreToolUse` | Before Bob runs any tool | Safety gates, secret scanning |
| `PostToolUse` | After a tool completes | Auto-formatting, logging |
| `PreInvocation` | Before each model reasoning step | Context injection |
| `PostInvocation` | After each reasoning step | Learning, session logging |
| `Stop` | When Bob is about to stop | Goal verification |

## Step 2 — hooks.json Schema
```json
{
  "my-hook-name": {
    "PreToolUse": [
      {
        "matcher": "execute_command",
        "hooks": [
          {
            "type": "command",
            "command": "bash .bob/hooks/my-hook/scripts/my-hook.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

The `matcher` field filters by tool name. Omit it to match all tools.

## Step 3 — Shell Script Contract
The script receives a JSON payload on `stdin`. For `PreToolUse` and `Stop`, write a JSON decision to `stdout`:

```bash
#!/usr/bin/env bash
set -eo pipefail

PAYLOAD=$(cat)  # Read JSON from stdin

# Extract the tool's command argument
CMD=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  console.log(p.toolInput?.command || '');
} catch(e) { console.log(''); }
" "$PAYLOAD" 2>/dev/null || echo "")

# Decision logic
if [[ "$CMD" == *"rm -rf /"* ]]; then
  echo '{"decision": "deny", "reason": "Catastrophic command blocked."}'
  exit 0
fi

echo '{"decision": "allow"}'
```

Valid decisions:
- `{"decision": "allow"}` — proceed
- `{"decision": "deny", "reason": "..."}` — block with message shown to user
- `{"decision": "ask", "reason": "..."}` — pause and ask user to confirm
- `{"decision": "stop"}` — for Stop hooks: let Bob stop
- `{"decision": "continue", "reason": "..."}` — for Stop hooks: keep going

## Step 4 — Wire into Bob
Place `hooks.json` at `.bob/hooks.json` (workspace) or `~/.bob/hooks.json` (global).

Multiple hook bundles can be merged into one `hooks.json`, or Bob can load from individual bundle files if placed in `.bob/hooks/`.

## Step 5 — Test the Hook
```bash
# Simulate a PreToolUse payload manually
echo '{"toolInput":{"command":"rm -rf /"}}' | bash .bob/hooks/my-hook/scripts/my-hook.sh
# Expected: {"decision": "deny", "reason": "..."}

# Make sure the script is executable
chmod +x .bob/hooks/my-hook/scripts/my-hook.sh
```

## Verification Checklist
- [ ] Script starts with `#!/usr/bin/env bash` and `set -eo pipefail`
- [ ] Script is executable (`chmod +x`)
- [ ] Script outputs valid JSON on stdout
- [ ] Script handles empty/invalid stdin gracefully (defaults to `allow`)
- [ ] hooks.json is valid JSON (test with `node -e "JSON.parse(require('fs').readFileSync('.bob/hooks.json','utf8'))"`)
- [ ] Hook fires correctly in a live Bob session

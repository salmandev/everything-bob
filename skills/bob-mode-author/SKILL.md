---
name: bob-mode-author
description: >-
  Use when the user wants to create a new custom Bob mode, write a custom_modes.yaml entry, define a Bob persona with specific tool permissions, or troubleshoot why a mode is not appearing in the mode picker.
---

# Bob Mode Author

Create production-quality custom Bob modes with the right persona and tool permissions.

## Step 1 — Decide the Persona and Scope
Answer these before writing any YAML:
1. **What role should this mode play?** (e.g. "security auditor", "documentation writer")
2. **What tools does it need?** Map to Bob's permission groups.
3. **What should it NOT do?** Restrictions are as important as permissions.
4. **Workspace or global?** Workspace = `.bob/custom_modes.yaml`. Global = `~/.bob/settings/custom_modes.yaml`.

## Step 2 — Permission Groups Reference
| Group | What it enables |
| --- | --- |
| `read` | `read_file`, `list_files`, `grep`, `glob` |
| `edit` | `write_file`, `apply_diff`, `search_and_replace`, `insert_content` |
| `execute` | `execute_command` |
| `mcp` | All registered MCP server tools |
| `skill` | `use_skill` (load skill playbooks) |
| `todo` | `update_todo_list` |
| `subagent` | `spawn_subagent` |
| `mode` | `switch_mode` |

> **Critical**: Wrong group names fail **silently** — the mode loads but tools are missing. Only use exact names from the table above.

## Step 3 — Write the YAML Entry

```yaml
customModes:
  - slug: my-custom-mode           # ^[a-zA-Z0-9-]+$ only, unique across all files
    name: My Custom Mode           # Display name in mode picker
    roleDefinition: >-
      You are a [specific persona]. Your primary focus is [concrete mission].
      You [key behavioral constraint]. You always [core discipline].
    whenToUse: Use when [specific trigger situation].
    groups:
      - read
      - skill
      - todo
      # Restricted edit — only .md files:
      # - - edit
      #   - fileRegex: ".*\\.md$"
```

## Step 4 — Read Before Writing (Avoid Duplicate Slugs)
```bash
# Check workspace modes
cat .bob/custom_modes.yaml 2>/dev/null | grep "slug:"

# Check global modes
cat ~/.bob/settings/custom_modes.yaml 2>/dev/null | grep "slug:"
```
A duplicate slug in the same file **drops the entire file** — all modes vanish.

## Step 5 — Write the File
- **Workspace**: `.bob/custom_modes.yaml` (no `settings/` subdirectory)
- **Global**: `~/.bob/settings/custom_modes.yaml` (note the `settings/` subdirectory)

Use `read_file` to check for existing content, then append your new entry under `customModes:`.

## Step 6 — Verify
Modes hot-reload — no restart needed. Open the mode picker immediately after saving. If the mode does not appear:
1. Check slug regex: `^[a-zA-Z0-9-]+$` — no underscores, no spaces
2. Check for duplicate slugs in the file
3. Check for invalid group names
4. Check for curly quotes or em-dashes (must be plain ASCII)

## Verification Checklist
- [ ] Slug is unique across workspace and global files
- [ ] Slug matches `^[a-zA-Z0-9-]+$`
- [ ] All group names are exact matches from the table above
- [ ] No curly quotes or non-ASCII characters in the YAML
- [ ] Mode appears in the mode picker after saving

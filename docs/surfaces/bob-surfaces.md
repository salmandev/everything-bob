# IBM Bob Surfaces

## 1. Bob Desktop App
The primary Bob interface. Supports:
- Chat interface with file explorer integration
- Mode picker for switching personas
- Hook execution in the background
- Full skill library and MCP server integration

**Config location**: `.bob/` in the open workspace

## 2. Bob VS Code Extension
Inline AI assistance within VS Code:
- Code completion and suggestions
- Diff & apply for file changes
- Mode switching via command palette
- Inherits `.bob/` config from the workspace root

## 3. Bob CLI
Terminal-based Bob access:
- Headless scripting and CI integration
- Same `.bob/` config format
- Useful for automated pipelines

## Global vs. Workspace Config

| Location | Purpose |
| --- | --- |
| `~/.bob/settings/custom_modes.yaml` | Global modes (all workspaces) |
| `~/.bob/skills/<name>/SKILL.md` | Global skills (all workspaces) |
| `.bob/custom_modes.yaml` | Workspace modes (this project only, no `settings/` subdir) |
| `.bob/hooks.json` | Workspace lifecycle hooks |
| `.bob/skills/<name>/SKILL.md` | Workspace skills (override global) |

**Note**: Global modes live under `~/.bob/settings/`, but workspace modes do NOT have a `settings/` subdirectory — they live directly at `.bob/custom_modes.yaml`.

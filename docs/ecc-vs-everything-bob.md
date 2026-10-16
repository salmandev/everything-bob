# ECC vs. Everything Gemini vs. Everything Bob

> A comprehensive architectural comparison of the three open-source AI harness ecosystems.

---

## The Family Tree

All three harnesses share a common philosophy: **structure your AI assistant with skills, rules, hooks, and modes** so it becomes consistently excellent instead of inconsistently powerful.

```
Everything Claude Code (ECC) — Affan Mustafa
    └── Inspired ──► Everything Gemini (everything-gemini) — salmandev
                         └── Inspired ──► Everything Bob (everything-bob) — salmandev
                                               "No one knows Bob better than Bob himself"
```

---

## Comparison Table

| Feature | ECC (Claude Code) | Everything Gemini (Antigravity) | Everything Bob (IBM Bob) |
| :--- | :--- | :--- | :--- |
| **AI Platform** | Anthropic Claude Code | Google Antigravity (AGY) | IBM Bob 2.x |
| **Config Root** | `.claude/` | `.agents/` | `.bob/` |
| **Global Config** | `~/.claude/` | `~/.gemini/config/` | `~/.bob/` |
| **Skill Format** | `.md` runbooks | `SKILL.md` (YAML FM) | `SKILL.md` (YAML FM) |
| **Skill Auto-Invoke** | Description matching | Progressive Disclosure (lazy) | Description matching + `use_skill` |
| **Custom Modes** | Slash personas | YAML subagent specs | `custom_modes.yaml` with tool groups |
| **Mode Tool Permissions** | Limited | N/A | Full group system: read/edit/execute/mcp/skill/todo/subagent/mode |
| **Lifecycle Hooks** | `.claude/settings.json` | `hooks.json` (protojson typed) | `hooks.json` (shell commands) |
| **Hook Events** | PreToolUse | PreToolUse/PostToolUse/PreInvocation/Stop | PreToolUse/PostToolUse/PreInvocation/PostInvocation/Stop |
| **MCP Integration** | Standard MCP | MCP Stdio + SSE | First-class `bob mcp` CLI + ACP |
| **Programmatic API** | Anthropic API | Google Antigravity SDK | ACP (Agent Client Protocol) |
| **Enterprise Focus** | General | General + Google Cloud | IBM Cloud, watsonx, Db2, IBM i |
| **IBM-Specific Skills** | None | None | watsonx.ai, IBM Cloud, Db2, IBM i RPG, z/OS JCL |
| **Bob as Tool** | N/A | N/A | Bob ACP + LangChain integration |
| **CLI Tool** | N/A | `everything-gemini` | `everything-bob` / `ebob` |
| **Installation Profiles** | Manual | core/developer/full | core/developer/full |
| **Test Suite** | None | `npm test` | 59-test suite (`npm test`) |

---

## Philosophy Differences

### Everything Claude Code (ECC)
- **Pioneer**: The first structured harness for Claude Code
- **Approach**: Flat markdown files, manual assembly
- **Strength**: Simplicity, battle-tested by large community
- **Best for**: Claude Code power users who want structured guidance

### Everything Gemini
- **Innovator**: Introduced Antigravity's Progressive Disclosure architecture
- **Approach**: YAML frontmatter skills + protojson hooks + multi-surface (Desktop, IDE, CLI, SDK)
- **Strength**: Token efficiency via lazy-loading, native multimodal vision, 1M+ context window
- **Best for**: Google Cloud teams, Python AI/ML engineers, multimodal workflows

### Everything Bob
- **Enterprise-First**: Built for IBM's enterprise AI platform by Bob himself
- **Approach**: Bob-native `.bob/` config, `custom_modes.yaml` tool permission groups, ACP integration
- **Strength**: IBM platform depth (watsonx, Db2, IBM i, z/OS), strict mode personas, Bob-as-a-tool via ACP
- **Best for**: IBM customers, enterprise teams, IBM Cloud deployments, regulated industries

---

## When to Choose Each

```
Working with Anthropic Claude? ──────────────────────► ECC
Working with Google Gemini / Antigravity? ────────────► Everything Gemini
Working with IBM Bob? ────────────────────────────────► Everything Bob
  ├── IBM Cloud / watsonx / Db2 / IBM i? ──────────────► everything-bob (IBM plugins)
  ├── Strict enterprise personas needed? ───────────────► everything-bob (custom modes with tool groups)
  └── Bob as part of a multi-agent pipeline? ───────────► everything-bob (ACP + langchain-bob skill)
```

---

## Token Efficiency Comparison

| Harness | Skills | Per-Turn Overhead | Loading Strategy |
| :--- | :--- | :--- | :--- |
| ECC | ~20-30 markdown files | ~30,000+ tokens if all loaded | Manual, no lazy-loading |
| Everything Gemini | 37 skills | ~3,400 tokens (summaries only) | Antigravity progressive disclosure |
| Everything Bob | 37+ skills | ~2,800 tokens (summaries only) | Bob skill description matching |

---

## What Everything Bob Does Uniquely

1. **IBM Platform Skills**: `watsonx-integration`, `ibm-cloud-deploy`, `db2-architect`, `ibm-i-rpg`, `zos-jcl` — no other harness has these
2. **Bob ACP Integration**: `langchain-bob` skill teaches you to call Bob programmatically from Python orchestration pipelines
3. **Mode Permission Groups**: Bob's `custom_modes.yaml` has the most granular tool permission system of the three harnesses — restrict a mode to only edit `.md` files, or only read without executing
4. **Bob-Native Meta-Skills**: `bob-mode-author`, `bob-hook-author`, `bob-rules-author`, `bob-skill-author` — Bob teaches you to extend Bob
5. **Self-Referential**: The repo's own `.bob/` runs the full everything-bob profile — Bob uses everything-bob to maintain everything-bob

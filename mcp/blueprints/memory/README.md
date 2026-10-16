# Memory MCP Server

Gives Bob persistent semantic memory across sessions — store entities, relations, and observations.

## Installation
```json
"memory": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-memory"]
}
```

## Use Cases
- Remember architectural decisions made in previous sessions
- Track known issues and workarounds across context resets
- Store team conventions Bob has learned
- Remember the state of long-running multi-session projects

## Available Tools
| Tool | Description |
| --- | --- |
| `create_entities` | Store named entities with observations |
| `search_nodes` | Semantic search over stored knowledge |
| `add_observations` | Add new facts to existing entities |
| `create_relations` | Link entities together |
| `open_nodes` | Retrieve specific entities by name |

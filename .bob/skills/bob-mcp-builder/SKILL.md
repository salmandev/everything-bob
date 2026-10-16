---
name: bob-mcp-builder
description: >-
  Use when the user wants to build a custom MCP server for Bob, register a new MCP tool, configure MCP in Bob's settings, troubleshoot an MCP server, or add a new MCP integration to a project.
---

# Bob MCP Builder

Build, register, and test custom MCP (Model Context Protocol) servers for IBM Bob.

## Step 1 — Scaffold the MCP Server
```bash
mkdir my-mcp-server && cd my-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk
```

## Step 2 — Implement the Server (v2 API)
```typescript
// src/index.ts
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

const server = new McpServer({
  name: 'my-mcp-server',
  version: '1.0.0',
});

server.registerTool(
  'get_weather',
  {
    description: 'Get current weather for a city',
    inputSchema: z.object({
      city: z.string().describe('City name'),
    }),
  },
  async ({ city }) => {
    // Implementation here
    return {
      content: [{ type: 'text', text: `Weather for ${city}: Sunny, 22°C` }],
    };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
```

## Step 3 — Register with Bob
Add to Bob's MCP settings (workspace `.bob/` or global `~/.bob/`):
```json
{
  "mcpServers": {
    "my-mcp-server": {
      "command": "node",
      "args": ["./my-mcp-server/dist/index.js"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

## Step 4 — Test the Server
```bash
# Test with the MCP inspector
npx @modelcontextprotocol/inspector node ./dist/index.js
```

## Verification Checklist
- [ ] Server starts without errors
- [ ] All tools have clear descriptions and typed input schemas
- [ ] Server registered in Bob's MCP config
- [ ] Tools accessible from Bob in a new conversation

# MCP Server Blueprints for IBM Bob

This directory contains production-ready MCP (Model Context Protocol) server configurations for IBM Bob.

## How to Configure MCP in Bob

Add server definitions to Bob's settings. Bob reads MCP config from:
- **Workspace**: `.bob/` directory settings
- **Global**: `~/.bob/settings/`

## Available Blueprints

| Blueprint | Purpose |
| :--- | :--- |
| [memory](./blueprints/memory/) | Persistent semantic memory across Bob sessions |
| [github](./blueprints/github/) | GitHub API — PRs, issues, code search |
| [postgres](./blueprints/postgres/) | PostgreSQL read/write database access |
| [sqlite](./blueprints/sqlite/) | Local SQLite database access |
| [redis](./blueprints/redis/) | Redis cache inspection and management |
| [fetch](./blueprints/fetch/) | Web fetch — retrieve live documentation and URLs |
| [docker](./blueprints/docker/) | Docker container and image management |

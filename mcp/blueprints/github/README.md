# GitHub MCP Server

Gives Bob direct access to GitHub repositories, issues, PRs, and code search.

## Installation
```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

## Required Permissions
Create a GitHub Personal Access Token with:
- `repo` (for private repositories)
- `read:org` (for organization access)
- `write:issues` (to create/update issues)

## Use Cases
- Search code across repositories
- Create and update issues
- Review PR diffs
- Manage labels and milestones
- Trigger GitHub Actions workflows

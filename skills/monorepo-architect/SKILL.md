---
name: monorepo-architect
description: >-
  Use when the user wants to set up a monorepo, configure Turborepo or Nx, share packages between apps, configure workspace dependencies, set up monorepo CI caching, or structure a large codebase into multiple packages.
---

# Monorepo Architect

Structure and configure production monorepos with Turborepo for maximum DX and build speed.

## Step 1 — Initialize with Turborepo
```bash
npx create-turbo@latest my-monorepo
cd my-monorepo
```

Or add to an existing project:
```bash
npm install turbo --save-dev
```

## Step 2 — Directory Structure
```
my-monorepo/
├── apps/
│   ├── web/          # Next.js app
│   ├── api/          # Express/Fastify API
│   └── docs/         # Documentation site
├── packages/
│   ├── ui/           # Shared React components
│   ├── config/       # Shared TS/ESLint/Tailwind configs
│   ├── db/           # Prisma schema + generated client
│   └── utils/        # Shared utility functions
├── turbo.json
└── package.json      # Root workspace config
```

## Step 3 — Root package.json Workspaces
```json
{
  "name": "my-monorepo",
  "private": true,
  "workspaces": ["apps/*", "packages/*"],
  "scripts": {
    "build": "turbo build",
    "dev": "turbo dev",
    "lint": "turbo lint",
    "test": "turbo test",
    "typecheck": "turbo typecheck"
  },
  "devDependencies": {
    "turbo": "^2.0.0"
  }
}
```

## Step 4 — turbo.json Pipeline Config
```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "package.json", "tsconfig.json"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "test": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "tests/**"],
      "outputs": ["coverage/**"]
    },
    "lint": {
      "inputs": ["src/**", ".eslintrc*"]
    },
    "typecheck": {
      "dependsOn": ["^build"]
    }
  }
}
```

## Step 5 — Shared Package Setup
```json
// packages/ui/package.json
{
  "name": "@repo/ui",
  "exports": {
    ".": "./src/index.ts"
  },
  "devDependencies": {
    "@repo/config": "*"
  }
}
```

```json
// apps/web/package.json — consume the shared package
{
  "dependencies": {
    "@repo/ui": "*",
    "@repo/db": "*"
  }
}
```

## Step 6 — Remote Caching (Free on Vercel)
```bash
npx turbo login
npx turbo link
# Now CI builds share cache across all machines
```

## Verification Checklist
- [ ] `turbo.json` `dependsOn: ["^build"]` set for all tasks that need built dependencies
- [ ] `outputs` correctly defined so Turbo can cache them
- [ ] Shared packages use `"exports"` field, not `"main"` only
- [ ] Remote caching enabled for CI
- [ ] `dev` task has `"cache": false` and `"persistent": true`

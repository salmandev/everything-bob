---
name: devops-pipeline
description: >-
  Use when the user wants to set up CI/CD, write a GitHub Actions workflow, create a Dockerfile, configure deployment pipelines, automate testing in CI, or set up build caching.
---

# DevOps Pipeline

Build reliable, fast CI/CD pipelines. Every commit should be deployable.

## Step 1 — Write a Multi-Stage Dockerfile
```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3: Runner (smallest possible image)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
EXPOSE 3000
USER node
CMD ["node", "dist/index.js"]
```

## Step 2 — Write the GitHub Actions Workflow
```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
      - run: npm run build

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build & Push Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker push myapp:${{ github.sha }}
```

## Step 3 — Cache Dependencies
Always cache `node_modules`, `~/.cache/pip`, or equivalent to cut CI time.

## Step 4 — Protect Main Branch
- Require passing CI before merge
- Require at least 1 reviewer approval
- Enable branch protection rules on GitHub

## Verification Checklist
- [ ] Dockerfile uses multi-stage builds
- [ ] CI runs tests on every PR
- [ ] Build artifacts cached between runs
- [ ] Deployment only runs on main branch after tests pass

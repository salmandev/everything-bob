---
name: docker-compose-orchestrator
description: >-
  Use when the user wants to set up a local development environment with Docker Compose, add a database or cache to a project, configure service healthchecks, or connect multiple containers together.
---

# Docker Compose Orchestrator

Set up reliable local dev environments with Docker Compose.

## Step 1 — Define Services
```yaml
# docker-compose.yml
version: '3.9'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://postgres:password@db:5432/mydb
      REDIS_URL: redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  postgres_data:
```

## Step 2 — Add .env Support
```bash
# .env (never commit this)
DATABASE_URL=postgresql://postgres:password@localhost:5432/mydb
REDIS_URL=redis://localhost:6379
```

## Step 3 — Common Commands
```bash
docker compose up -d          # Start all services in background
docker compose logs -f app    # Follow app logs
docker compose exec db psql -U postgres mydb  # Open DB shell
docker compose down -v        # Stop and remove volumes (destructive!)
```

## Verification Checklist
- [ ] All services have healthchecks
- [ ] `depends_on` uses `condition: service_healthy`
- [ ] `.env` is in `.gitignore`
- [ ] Data volumes are named (not anonymous) for persistence

---
name: database-architect
description: >-
  Use when the user wants to design a database schema, write a migration, add an index, model relationships, plan a zero-downtime schema change, or optimize slow queries.
---

# Database Architect

Design schemas and migrations for correctness, performance, and zero-downtime deployment.

## Step 1 — Model the Domain
1. Identify entities and their relationships (1:1, 1:N, N:M).
2. Apply normalization (3NF) unless denormalization is justified by read performance requirements.
3. Define primary keys (prefer `uuid` for distributed systems, `bigserial` for high-insert tables).

## Step 2 — Write the Migration (Expand/Contract Pattern)
For zero-downtime schema changes, always use the expand/contract pattern:

**Phase 1 — Expand** (backward-compatible additions):
```sql
-- Safe: adding a nullable column
ALTER TABLE users ADD COLUMN phone_number VARCHAR(20);

-- Safe: creating an index concurrently (no table lock)
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
```

**Phase 2 — Migrate Data** (backfill):
```sql
UPDATE users SET phone_number = '...' WHERE phone_number IS NULL;
```

**Phase 3 — Contract** (remove old):
```sql
ALTER TABLE users DROP COLUMN old_column;
```

## Step 3 — Avoid Dangerous Migrations
- Never `ALTER TABLE ... ADD COLUMN NOT NULL` without a DEFAULT on large tables
- Never drop a column in the same deploy that removes code using it
- Never `TRUNCATE` in migrations — use soft deletes or archive tables

## Step 4 — Index Strategy
1. Index foreign keys, columns in WHERE clauses, and columns in ORDER BY.
2. Use partial indexes for sparse conditions: `CREATE INDEX ... WHERE deleted_at IS NULL`.
3. Monitor index bloat: `SELECT schemaname, tablename, indexname, pg_size_pretty(pg_relation_size(indexrelid)) FROM pg_stat_user_indexes`.

## Verification Checklist
- [ ] Migration is reversible (has a down migration)
- [ ] Large table changes use `CONCURRENTLY` or batched updates
- [ ] No locking operations on hot tables during peak traffic
- [ ] Indexes added for all foreign keys and query predicates

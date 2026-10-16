---
name: performance-profiler
description: >-
  Use when the user reports slow performance, wants to profile CPU or memory usage, needs to identify N+1 query problems, wants to analyze slow database queries, or needs to find bottlenecks in a critical path.
---

# Performance Profiler

Find bottlenecks with evidence. Never optimize without measuring first.

## Step 1 — Establish a Baseline
1. Measure current performance with a reproducible benchmark before any changes.
2. Identify the critical path: what code runs on every request?
3. Set a target: what is the acceptable latency/throughput?

## Step 2 — Profile the Application Layer
For Node.js:
```bash
node --prof app.js
node --prof-process isolate-*.log > profile.txt
```
For Python:
```bash
python -m cProfile -o output.pstats app.py
python -c "import pstats; p = pstats.Stats('output.pstats'); p.sort_stats('cumulative'); p.print_stats(20)"
```

## Step 3 — Identify N+1 Query Problems
1. Enable query logging in development.
2. Look for loops that execute queries: `for item in items: db.query(...)`.
3. Fix with eager loading / JOINs / DataLoader batching.

## Step 4 — Analyze Slow Queries
```sql
-- PostgreSQL: find slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- EXPLAIN ANALYZE a specific query
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
```

## Step 5 — Profile Memory
1. For Node.js: use `--expose-gc` and `v8.getHeapStatistics()`.
2. Look for: objects accumulating in closures, event listeners not removed, large arrays in memory.

## Step 6 — Apply Targeted Fixes
1. Fix one bottleneck at a time.
2. Measure again after each fix to confirm improvement.
3. Document: what was slow, what the fix was, and the before/after numbers.

## Verification Checklist
- [ ] Baseline measured before any changes
- [ ] Top 3 bottlenecks identified with evidence
- [ ] N+1 queries eliminated
- [ ] Performance improvement measured and documented

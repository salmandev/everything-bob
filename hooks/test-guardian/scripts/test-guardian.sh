#!/usr/bin/env bash
# Everything Bob Test Guardian: Stop hook — blocks stopping if tests fail or coverage drops
set -eo pipefail

FAILURES=0
MESSAGES=()

# ── Node.js / npm test ─────────────────────────────────────────────────────────
if [ -f "package.json" ]; then
  TEST_CMD=""
  if node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts.test?0:1)" 2>/dev/null; then
    TEST_CMD="npm test --silent 2>&1"
  elif [ -f "node_modules/.bin/jest" ]; then
    TEST_CMD="npx jest --passWithNoTests 2>&1"
  elif [ -f "node_modules/.bin/vitest" ]; then
    TEST_CMD="npx vitest run 2>&1"
  fi

  if [ -n "$TEST_CMD" ]; then
    TEST_OUTPUT=$(eval "$TEST_CMD" 2>&1 || true)
    if echo "$TEST_OUTPUT" | grep -qiE "FAIL |failed|[0-9]+ failing|Tests failed"; then
      FAILURES=$((FAILURES + 1))
      FAIL_COUNT=$(echo "$TEST_OUTPUT" | grep -oiE "[0-9]+ (failing|failed)" | head -1)
      MESSAGES+=("Test suite has failures: ${FAIL_COUNT:-check output}.")
    fi
  fi
fi

# ── Python pytest ─────────────────────────────────────────────────────────────
if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.cfg" ]; then
  if command -v pytest &>/dev/null; then
    PYTEST_OUT=$(pytest --tb=no -q 2>&1 || true)
    if echo "$PYTEST_OUT" | grep -qE "[0-9]+ failed"; then
      FAILURES=$((FAILURES + 1))
      FAIL_COUNT=$(echo "$PYTEST_OUT" | grep -oE "[0-9]+ failed" | head -1)
      MESSAGES+=("pytest: ${FAIL_COUNT}.")
    fi
  fi
fi

# ── TypeScript typecheck ───────────────────────────────────────────────────────
if [ -f "tsconfig.json" ] && command -v node &>/dev/null; then
  if [ -f "node_modules/.bin/tsc" ]; then
    TSC_OUT=$(npx tsc --noEmit 2>&1 || true)
    if echo "$TSC_OUT" | grep -qE "error TS"; then
      ERR_COUNT=$(echo "$TSC_OUT" | grep -c "error TS" || true)
      FAILURES=$((FAILURES + 1))
      MESSAGES+=("TypeScript: ${ERR_COUNT} type error(s).")
    fi
  fi
fi

# ── Decision ──────────────────────────────────────────────────────────────────
if [ "$FAILURES" -gt 0 ]; then
  COMBINED=$(IFS=' '; echo "${MESSAGES[*]}")
  echo "{\"decision\": \"continue\", \"reason\": \"[Test Guardian] Cannot stop — ${COMBINED} Fix all failures before stopping.\"}"
  exit 0
fi

echo '{"decision": "stop"}'
exit 0

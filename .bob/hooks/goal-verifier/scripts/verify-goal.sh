#!/usr/bin/env bash
# Everything Bob Goal Verifier: Stop hook — prevents premature completion
set -eo pipefail

# Check if tests are failing
if [ -f "package.json" ]; then
  if npm test --silent 2>&1 | grep -qE "FAIL|failing|Error|error"; then
    echo '{"decision": "continue", "reason": "[Everything Bob Goal Verifier] Tests are still failing. Fix all test failures before stopping."}'
    exit 0
  fi
fi

# Check for uncommitted changes to critical files
UNCOMMITTED=$(git status --porcelain 2>/dev/null | grep -E "\.ts$|\.js$|\.py$|\.go$" | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt "0" ]; then
  echo "{\"decision\": \"continue\", \"reason\": \"[Everything Bob Goal Verifier] There are ${UNCOMMITTED} modified source files not yet saved or committed. Review before stopping.\"}"
  exit 0
fi

# Check for TODO markers left by Bob
TODO_COUNT=$(grep -r "TODO: Bob" . --include="*.ts" --include="*.js" --include="*.py" --include="*.go" 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt "0" ]; then
  echo "{\"decision\": \"continue\", \"reason\": \"[Everything Bob Goal Verifier] Found ${TODO_COUNT} 'TODO: Bob' markers still unresolved in the codebase.\"}"
  exit 0
fi

echo '{"decision": "stop"}'
exit 0

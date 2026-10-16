#!/usr/bin/env bash
# Everything Bob Context Injector: PreInvocation — injects workspace context
set -eo pipefail

CONTEXT=""

# Git branch
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  CONTEXT="${CONTEXT}Current git branch: ${BRANCH}. "
  
  # Last commit message
  LAST_COMMIT=$(git log -1 --oneline 2>/dev/null || echo "no commits")
  CONTEXT="${CONTEXT}Last commit: ${LAST_COMMIT}. "
fi

# Check for failing tests indicator file
if [ -f ".bob/context/last-test-result.txt" ]; then
  LAST_RESULT=$(cat .bob/context/last-test-result.txt)
  CONTEXT="${CONTEXT}Last test result: ${LAST_RESULT}. "
fi

# Check for open tasks file
if [ -f ".bob/context/open-tasks.md" ]; then
  CONTEXT="${CONTEXT}Open tasks file exists at .bob/context/open-tasks.md. "
fi

if [ -n "$CONTEXT" ]; then
  echo "{\"contextInjection\": \"[Everything Bob Context]: ${CONTEXT}\"}"
fi

exit 0

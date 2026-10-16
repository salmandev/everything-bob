#!/usr/bin/env bash
# Everything Bob Auto Lint Formatter: PostToolUse — runs formatter after file writes
set -eo pipefail

PAYLOAD=$(cat)

FILE_PATH=""
if command -v node &>/dev/null; then
  FILE_PATH=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  const path = p.toolInput?.path || p.toolCall?.args?.path || '';
  console.log(path);
} catch (e) {
  console.log('');
}
" "$PAYLOAD" 2>/dev/null || echo "")
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    if command -v prettier &>/dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null || true
    elif [ -f "node_modules/.bin/prettier" ]; then
      node_modules/.bin/prettier --write "$FILE_PATH" 2>/dev/null || true
    fi
    if command -v eslint &>/dev/null; then
      eslint --fix "$FILE_PATH" 2>/dev/null || true
    elif [ -f "node_modules/.bin/eslint" ]; then
      node_modules/.bin/eslint --fix "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff format "$FILE_PATH" 2>/dev/null || true
      ruff check --fix "$FILE_PATH" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac

exit 0

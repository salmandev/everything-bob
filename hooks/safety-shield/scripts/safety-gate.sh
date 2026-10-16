#!/usr/bin/env bash
# Everything Bob Safety Shield: PreToolUse Security Gate
# Reads hook payload JSON from stdin, evaluates safety, outputs JSON decision to stdout.

set -eo pipefail

PAYLOAD=$(cat)

# Extract command using node
CMD=""
if command -v node &>/dev/null; then
  CMD=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  const cmd = p.toolInput?.command || p.toolCall?.args?.command || '';
  console.log(cmd);
} catch (e) {
  console.log('');
}
" "$PAYLOAD" 2>/dev/null || echo "")
fi

if [ -z "$CMD" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Catastrophically destructive patterns — always deny
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  ":(){ :|:& };:"
  "mkfs"
  "dd if=/dev/zero"
  "dd if=/dev/random"
  "chmod -R 777 /"
  "git push --force origin main"
  "git push -f origin main"
  "git push --force origin master"
  "git push -f origin master"
  "git push --force-with-lease origin main"
  "DROP DATABASE"
  "drop database"
  "TRUNCATE TABLE"
  "truncate table"
  "> /etc/passwd"
  "> /etc/hosts"
  "format c:"
)

# Patterns requiring user confirmation
ASK_PATTERNS=(
  "git reset --hard"
  "git clean -fd"
  "git clean -fxd"
  "npm publish"
  "yarn publish"
  "docker system prune -a"
  "kubectl delete namespace"
  "kubectl delete --all"
  "terraform destroy"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$CMD" == *"$pattern"* ]]; then
    echo "{\"decision\": \"deny\", \"reason\": \"[Everything Bob Safety Shield] Catastrophic command blocked: '${pattern}'. This operation cannot be undone.\"}"
    exit 0
  fi
done

for pattern in "${ASK_PATTERNS[@]}"; do
  if [[ "$CMD" == *"$pattern"* ]]; then
    echo "{\"decision\": \"ask\", \"reason\": \"[Everything Bob Safety Shield] Potentially destructive command detected: '${pattern}'. Please confirm this is intentional.\"}"
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0

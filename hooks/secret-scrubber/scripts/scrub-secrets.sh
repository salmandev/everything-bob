#!/usr/bin/env bash
# Everything Bob Secret Scrubber: PreToolUse — blocks hardcoded secrets before write
set -eo pipefail

PAYLOAD=$(cat)

CONTENT=""
if command -v node &>/dev/null; then
  CONTENT=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  const content = p.toolInput?.content || p.toolCall?.args?.content || '';
  console.log(content);
} catch (e) {
  console.log('');
}
" "$PAYLOAD" 2>/dev/null || echo "")
fi

if [ -z "$CONTENT" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Patterns that indicate hardcoded secrets
SECRET_PATTERNS=(
  "sk-[a-zA-Z0-9]{20,}"
  "AKIA[0-9A-Z]{16}"
  "ghp_[a-zA-Z0-9]{36}"
  "ghs_[a-zA-Z0-9]{36}"
  "eyJhbGciOiJIUzI1NiJ9"
  "-----BEGIN RSA PRIVATE KEY-----"
  "-----BEGIN OPENSSH PRIVATE KEY-----"
  "-----BEGIN EC PRIVATE KEY-----"
  "password\s*=\s*[\"'][^\"']{8,}[\"']"
  "secret\s*=\s*[\"'][^\"']{8,}[\"']"
  "api_key\s*=\s*[\"'][^\"']{8,}[\"']"
)

for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qP "$pattern" 2>/dev/null; then
    echo "{\"decision\": \"ask\", \"reason\": \"[Everything Bob Secret Scrubber] Possible hardcoded secret detected matching pattern '${pattern}'. Use environment variables instead.\"}"
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0

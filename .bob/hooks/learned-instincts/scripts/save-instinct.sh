#!/usr/bin/env bash
# Everything Bob Learned Instincts: PostInvocation — records corrections into instincts
set -eo pipefail

PAYLOAD=$(cat)

CORRECTION=""
if command -v node &>/dev/null; then
  CORRECTION=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  const messages = p.messages || [];
  const lastUser = messages.filter(m => m.role === 'user').pop();
  const text = lastUser?.content || '';
  // Look for correction indicators
  if (/actually|wrong|incorrect|don't|never|always|instead|should|mistake/i.test(text)) {
    console.log(text.substring(0, 500));
  }
} catch (e) {}
" "$PAYLOAD" 2>/dev/null || echo "")
fi

if [ -n "$CORRECTION" ]; then
  mkdir -p ".bob/rules"
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
  echo "" >> ".bob/rules/learned-instincts.md"
  echo "<!-- Learned ${TIMESTAMP} -->" >> ".bob/rules/learned-instincts.md"
  echo "<!-- ${CORRECTION} -->" >> ".bob/rules/learned-instincts.md"
fi

exit 0

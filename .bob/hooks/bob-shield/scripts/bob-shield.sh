#!/usr/bin/env bash
# Everything Bob Shield: Comprehensive IBM enterprise safety firewall
set -eo pipefail

PAYLOAD=$(cat)

CMD=""
if command -v node &>/dev/null; then
  CMD=$(node -e "
try {
  const p = JSON.parse(process.argv[1]);
  const cmd = p.toolInput?.command || p.toolCall?.args?.command || '';
  console.log(cmd);
} catch (e) { console.log(''); }
" "$PAYLOAD" 2>/dev/null || echo "")
fi

[ -z "$CMD" ] && echo '{"decision": "allow"}' && exit 0

# Critical IBM platform destructive patterns
IBM_BLOCKED=(
  "db2drop"
  "dropdb"
  "shutdown -h"
  "halt"
  "poweroff"
  "rm -rf /"
  ":(){ :|:& };:"
  "mkfs"
  "chmod -R 000"
  "chmod -R 777 /"
  "git push --force origin main"
  "git push --force origin master"
  "terraform destroy -auto-approve"
  "kubectl delete namespace kube-system"
  "ibmcloud resource group-delete"
)

for pattern in "${IBM_BLOCKED[@]}"; do
  if [[ "$CMD" == *"$pattern"* ]]; then
    echo "{\"decision\": \"deny\", \"reason\": \"[Bob Shield] Enterprise safety policy: blocked pattern '${pattern}'. This operation is irreversible.\"}"
    exit 0
  fi
done

# Patterns requiring confirmation
IBM_ASK=(
  "ibmcloud resource"
  "ibmcloud iam"
  "git push"
  "npm publish"
  "docker push"
  "kubectl delete"
  "terraform apply"
)

for pattern in "${IBM_ASK[@]}"; do
  if [[ "$CMD" == *"$pattern"* ]]; then
    echo "{\"decision\": \"ask\", \"reason\": \"[Bob Shield] IBM enterprise safety: '${pattern}' affects production resources. Please confirm this is intentional.\"}"
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0

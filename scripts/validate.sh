#!/usr/bin/env bash
# Everything Bob validation script
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ERRORS=0

echo "🧪 Validating everything-bob components..."
echo ""

# Validate skills
echo "⚡ Skills:"
for skill_dir in "$ROOT/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_md="$skill_dir/SKILL.md"
  
  if [ ! -f "$skill_md" ]; then
    echo "  ✖ $skill_name: SKILL.md missing"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  if ! head -1 "$skill_md" | grep -q "^---"; then
    echo "  ✖ $skill_name: missing frontmatter"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  if ! grep -q "^name:" "$skill_md"; then
    echo "  ✖ $skill_name: missing name field"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  if ! grep -q "^description:" "$skill_md"; then
    echo "  ✖ $skill_name: missing description field"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  echo "  ✔ $skill_name"
done

echo ""
echo "🛡️  Hooks:"
for hook_dir in "$ROOT/hooks"/*/; do
  hook_name=$(basename "$hook_dir")
  hooks_json="$hook_dir/hooks.json"
  
  if [ ! -f "$hooks_json" ]; then
    echo "  ✖ $hook_name: hooks.json missing"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  if ! python3 -m json.tool "$hooks_json" > /dev/null 2>&1 && ! node -e "JSON.parse(require('fs').readFileSync('$hooks_json','utf8'))" 2>/dev/null; then
    echo "  ✖ $hook_name: hooks.json invalid JSON"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  # Check scripts are executable
  if [ -d "$hook_dir/scripts" ]; then
    for script in "$hook_dir/scripts"/*.sh; do
      [ -f "$script" ] || continue
      if [ ! -x "$script" ]; then
        echo "  ✖ $hook_name/scripts/$(basename $script): not executable"
        ERRORS=$((ERRORS + 1))
      fi
    done
  fi
  
  echo "  ✔ $hook_name"
done

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "✨ All validations passed!"
else
  echo "✖ $ERRORS validation error(s) found."
  exit 1
fi

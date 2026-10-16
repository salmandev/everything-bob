#!/usr/bin/env bash
# Everything Bob one-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/salmandev/everything-bob/main/scripts/install.sh | bash

set -eo pipefail

REPO="https://github.com/salmandev/everything-bob.git"
PROFILE="${EVERYTHING_BOB_PROFILE:-developer}"
TARGET_DIR="${EVERYTHING_BOB_TARGET:-.bob}"

echo "🤖 Everything Bob Installer"
echo "Profile: $PROFILE | Target: $TARGET_DIR"
echo ""

# Check dependencies
if ! command -v node &>/dev/null; then
  echo "❌ Node.js is required. Install from https://nodejs.org"
  exit 1
fi

if ! command -v git &>/dev/null; then
  echo "❌ Git is required."
  exit 1
fi

# Clone or update
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo "📥 Cloning everything-bob..."
git clone --depth=1 "$REPO" "$TMP_DIR/everything-bob" 2>/dev/null

echo "🚀 Installing profile: $PROFILE..."
node "$TMP_DIR/everything-bob/bin/everything-bob" install --profile "$PROFILE"

echo ""
echo "✨ everything-bob installed! Start a new Bob session to use your new skills and hooks."
echo "   Run: everything-bob status"

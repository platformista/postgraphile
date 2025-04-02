#!/bin/bash
set -euo pipefail

CONFIG_FILE=".upsun/config.yaml"
REGISTRY_URL="https://docs.upsun.com/registry/images/registry.json"
APP_MACHINE_NAME=$(yq e '.applications | keys | .[0]' "$CONFIG_FILE")

# Ensure yq is installed (or install it dynamically if needed)
if ! command -v yq &> /dev/null; then
  echo "❌ 'yq' is not installed. Please include it in the source operation image."
  exit 1
fi

# Extract language and version from the config file
FULL_TYPE=$(yq e '.applications.'${APP_MACHINE_NAME}'.type' "$CONFIG_FILE")

if [[ "$FULL_TYPE" != *:* ]]; then
  echo "❌ Could not determine language and version from type: '$FULL_TYPE'"
  exit 1
fi

LANGUAGE="${FULL_TYPE%%:*}"
CURRENT_VERSION="${FULL_TYPE##*:}"

echo "📦 Configured runtime: $LANGUAGE:$CURRENT_VERSION"

# Fetch latest active version from the Upsun registry
# Be semver-aware (e.g., 8.10 should come after 8.9 in a sort).
LATEST=$(curl -s "$REGISTRY_URL" | jq -r \
  --arg lang "$LANGUAGE" \
  '.[$lang].versions.supported
   | sort_by(split(".") | map(tonumber))
   | last')

if [ -z "$LATEST" ]; then
  echo "❌ No active versions found for language: $LANGUAGE"
  exit 1
fi

# Compare current and latest versions
if [ "$CURRENT_VERSION" != "$LATEST" ]; then
  echo "🔔 Update available for $LANGUAGE:"
  echo "Current: $CURRENT_VERSION"
  echo "Latest:  $LATEST"
  echo "Suggested change in $CONFIG_FILE:"
  echo "type: $LANGUAGE:$LATEST"
  exit 2
else
  echo "✅ Runtime is up to date: $LANGUAGE:$CURRENT_VERSION"
  exit 0
fi
#!/bin/bash
set -euo pipefail

CONFIG_FILE=".upsun/config.yaml"
REGISTRY_URL="https://docs.upsun.com/registry/images/registry.json"

# Determine application machine name (first key under 'applications')
APP_MACHINE_NAME=$(yq e '.applications | keys | .[0]' "$CONFIG_FILE")

# Extract language and version from the config
FULL_TYPE=$(yq e ".applications.${APP_MACHINE_NAME}.type" "$CONFIG_FILE")

LANGUAGE="${FULL_TYPE%%:*}"
CURRENT_VERSION="${FULL_TYPE##*:}"

echo "📦 App: $APP_MACHINE_NAME"
echo "🔎 Configured runtime: $LANGUAGE:$CURRENT_VERSION"

# Fetch and parse the latest supported version from the registry
LATEST_VERSION=$(curl -s "$REGISTRY_URL" | jq -r \
  --arg lang "$LANGUAGE" \
  '.[$lang].versions.supported
   | sort_by(split(".") | map(tonumber))
   | last')

echo "📚 Latest supported version for $LANGUAGE: $LATEST_VERSION"

# Compare and update if needed
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
  echo "🚀 Updating $LANGUAGE from $CURRENT_VERSION to $LATEST_VERSION"
  yq e ".applications.${APP_MACHINE_NAME}.type = \"${LANGUAGE}:${LATEST_VERSION}\"" -i "$CONFIG_FILE"
  echo "✅ Updated $CONFIG_FILE"
else
  echo "✅ Runtime already up to date."
fi

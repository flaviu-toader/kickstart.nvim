#!/usr/bin/env bash
# Sets up ~/.config/github-copilot/hosts.json for tools that read that file
# (e.g. codecompanion.nvim), using the standard GitHub Device Authorization Flow
# with the Copilot OAuth app.
#
# Run this once per machine. The resulting hosts.json is a secret — do not commit it.

set -euo pipefail

CLIENT_ID="Iv1.b507a08c87ecfe98"

echo "Starting GitHub device flow..."

DEVICE=$(curl -s -X POST https://github.com/login/device/code \
  -H "Accept: application/json" \
  -d "client_id=${CLIENT_ID}&scope=read:user")

DEVICE_CODE=$(echo "$DEVICE" | python3 -c "import sys,json; print(json.load(sys.stdin)['device_code'])")
USER_CODE=$(echo "$DEVICE"   | python3 -c "import sys,json; print(json.load(sys.stdin)['user_code'])")
VERIFY_URL=$(echo "$DEVICE"  | python3 -c "import sys,json; print(json.load(sys.stdin)['verification_uri'])")
INTERVAL=$(echo "$DEVICE"    | python3 -c "import sys,json; print(json.load(sys.stdin).get('interval', 5))")

echo ""
echo "  1. Open:       $VERIFY_URL"
echo "  2. Enter code: $USER_CODE"
echo ""
echo "Waiting for authorization (this may take a moment)..."

while true; do
  sleep "$INTERVAL"
  RESPONSE=$(curl -s -X POST https://github.com/login/oauth/access_token \
    -H "Accept: application/json" \
    -d "client_id=${CLIENT_ID}&device_code=${DEVICE_CODE}&grant_type=urn:ietf:params:oauth:grant-type:device_code")

  ACCESS_TOKEN=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('access_token',''))" 2>/dev/null)
  ERROR=$(echo "$RESPONSE"        | python3 -c "import sys,json; print(json.load(sys.stdin).get('error',''))" 2>/dev/null)

  if [ -n "$ACCESS_TOKEN" ] && [ "$ACCESS_TOKEN" != "None" ]; then
    USERNAME=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" https://api.github.com/user \
      | python3 -c "import sys,json; print(json.load(sys.stdin)['login'])")

    OUT="$HOME/.config/github-copilot/hosts.json"
    mkdir -p "$(dirname "$OUT")"
    python3 -c "
import json
data = {'github.com': {'user': '$USERNAME', 'oauth_token': '$ACCESS_TOKEN'}}
with open('$OUT', 'w') as f:
    json.dump(data, f, indent=2)
"
    echo ""
    echo "Authenticated as $USERNAME. Written to $OUT"
    break
  elif [ "$ERROR" = "authorization_pending" ]; then
    echo -n "."
  elif [ "$ERROR" = "slow_down" ]; then
    INTERVAL=$((INTERVAL + 5))
  else
    echo ""
    echo "Error: $RESPONSE"
    exit 1
  fi
done

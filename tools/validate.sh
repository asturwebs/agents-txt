#!/usr/bin/env bash
# validate.sh — Validate an agents.txt or /api/agents endpoint against the JSON Schema
# Usage: ./validate.sh <url> [path/to/json-schema.json]
set -euo pipefail

URL="${1:?Usage: validate.sh <url> [schema-path]}"
SCHEMA="${2:-./json-schema.json}"
TMPFILE=$(mktemp /tmp/agents-validate-XXXXXX.json)

cleanup() { rm -f "$TMPFILE"; }
trap cleanup EXIT

if [ ! -f "$SCHEMA" ]; then
  echo "ERROR: Schema not found at $SCHEMA"
  exit 1
fi

echo "Validating: $URL"
echo "Schema:     $SCHEMA"
echo ""

HTTP_CODE=$(curl -sS -o "$TMPFILE" -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" -ne 200 ]; then
  echo "FAIL: HTTP $HTTP_CODE"
  cat "$TMPFILE"
  exit 1
fi

CONTENT_TYPE=$(file -b --mime-type "$TMPFILE")

if echo "$CONTENT_TYPE" | grep -qi "json"; then
  echo "Detected: JSON response"
else
  echo "WARN: Content-Type is $CONTENT_TYPE (expected application/json)"
  echo "Attempting JSON parse anyway..."
fi

if ! python3 -c "import json; json.load(open('$TMPFILE'))" 2>/dev/null; then
  echo "FAIL: Response is not valid JSON"
  exit 1
fi

# Check required top-level fields
MISSING=0
for field in "agents-txt" "updated" "identity"; do
  if ! python3 -c "import json; d=json.load(open('$TMPFILE')); assert '$field' in d" 2>/dev/null; then
    echo "FAIL: Missing required field '$field'"
    MISSING=1
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo ""
  echo "Required fields: agents-txt, updated, identity"
  exit 1
fi

# Try ajv-cli if available
if command -v npx &>/dev/null; then
  echo ""
  echo "Running ajv-cli validation..."
  if npx ajv-cli validate -s "$SCHEMA" -d "$TMPFILE" 2>&1; then
    echo ""
    echo "PASS: $URL is valid agents.txt v2.0"
  else
    echo ""
    echo "FAIL: Schema validation errors (see above)"
    exit 1
  fi
else
  echo ""
  echo "WARN: npx not found — install ajv-cli for full schema validation"
  echo "Basic checks passed (JSON valid, required fields present)"
fi

#!/usr/bin/env bash
# validate-md.sh — Validate a Markdown agents.txt file (---yaml blocks) against the v2.0 spec
# Usage: ./validate-md.sh <file-or-url>
# Requires: bash, python3, PyYAML (pip install pyyaml). curl only for URLs.
set -euo pipefail

TARGET="${1:?Usage: validate-md.sh <file-or-url>}"
TMPFILE=""

cleanup() { [ -n "$TMPFILE" ] && rm -f "$TMPFILE" || true; }
trap cleanup EXIT

if [[ "$TARGET" =~ ^https?:// ]]; then
  TMPFILE=$(mktemp /tmp/agents-md-XXXXXX.txt)
  echo "Fetching: $TARGET"
  HTTP_CODE=$(curl -sS -o "$TMPFILE" -w "%{http_code}" "$TARGET")
  if [ "$HTTP_CODE" -ne 200 ]; then
    echo "FAIL: HTTP $HTTP_CODE"
    exit 1
  fi
  TARGET="$TMPFILE"
fi

if [ ! -f "$TARGET" ]; then
  echo "ERROR: File not found: $TARGET"
  exit 1
fi

echo "Validating: $TARGET"
echo ""

python3 - "$TARGET" <<'PYEOF'
import re
import sys

path = sys.argv[1]
try:
    text = open(path, encoding="utf-8").read()
except OSError as e:
    print(f"FAIL: cannot read {path}: {e}")
    sys.exit(1)

try:
    import yaml
except ImportError:
    print("FAIL: PyYAML is required (pip install pyyaml)")
    sys.exit(1)

# Strip HTML comments (commented-out sections must not be parsed)
text = re.sub(r"<!--.*?-->", "", text, flags=re.S)

errors = []
warnings = []

# --- Header checks -----------------------------------------------------------
if not re.search(r"^#\s*Version:\s*2\.0\s*$", text, re.M):
    errors.append("Header missing '# Version: 2.0'")
if not re.search(r"^#\s*Updated:\s*\d{4}-\d{2}-\d{2}\s*$", text, re.M):
    errors.append("Header missing '# Updated: YYYY-MM-DD'")

# --- Extract ---yaml blocks ---------------------------------------------------
blocks = re.findall(r"^---yaml\s*\n(.*?)\n^---\s*$", text, re.M | re.S)
if not blocks:
    errors.append("No '---yaml ... ---' blocks found")

data = {}
for i, block in enumerate(blocks, 1):
    try:
        doc = yaml.safe_load(block)
    except yaml.YAMLError as e:
        errors.append(f"YAML block #{i}: parse error: {e}")
        continue
    if isinstance(doc, dict):
        for key, value in doc.items():
            if key in data:
                warnings.append(f"Key '{key}' defined in more than one yaml block")
            data[key] = value
    else:
        errors.append(f"YAML block #{i}: not a mapping")


def is_uri(value):
    return isinstance(value, str) and re.match(r"^https?://\S+$", value)


def is_email(value):
    return isinstance(value, str) and re.match(r"^[^@\s]+@[^@\s]+\.[^@\s]+$", value)


# --- identity (required by schema) --------------------------------------------
identity = data.get("identity")
if not isinstance(identity, dict):
    errors.append("Missing required 'identity' block")
else:
    for field in ("name", "owner", "website", "email"):
        if not identity.get(field):
            errors.append(f"identity.{field} is required")
    if identity.get("website") and not is_uri(identity["website"]):
        errors.append("identity.website must be an http(s) URI")
    if identity.get("email") and not is_email(identity["email"]):
        errors.append("identity.email does not look like an email")

# --- terms ---------------------------------------------------------------------
DATA_USAGE_KEYS = ("training", "rag", "derivative")
PER_AGENT_USAGE = ("answer-engine", "rag", "training", "derivative")

terms = data.get("terms")
if terms is not None:
    if not isinstance(terms, dict):
        errors.append("'terms' must be a mapping")
    else:
        for field in ("allowed", "denied"):
            if field in terms and not isinstance(terms[field], list):
                errors.append(f"terms.{field} must be a list")
        usage = terms.get("data_usage")
        if usage is not None:
            if not isinstance(usage, dict):
                errors.append("terms.data_usage must be a mapping")
            else:
                for key, value in usage.items():
                    if key not in DATA_USAGE_KEYS:
                        warnings.append(f"terms.data_usage.{key} is not a standard key")
                    elif not isinstance(value, bool):
                        errors.append(f"terms.data_usage.{key} must be a boolean")
        agents = terms.get("agents")
        if agents is not None:
            if not isinstance(agents, list):
                errors.append("terms.agents must be a list")
            else:
                for i, agent in enumerate(agents):
                    tag = f"terms.agents[{i}]"
                    if not isinstance(agent, dict):
                        errors.append(f"{tag} must be a mapping")
                        continue
                    for field in ("agent", "owner", "access"):
                        if not agent.get(field):
                            errors.append(f"{tag}.{field} is required")
                    if agent.get("access") and agent["access"] not in ("full", "answer-engine", "denied"):
                        errors.append(f"{tag}.access '{agent['access']}' not in enum: full | answer-engine | denied")
                    for key in agent.get("data_usage") or []:
                        if key not in PER_AGENT_USAGE:
                            errors.append(f"{tag}.data_usage: '{key}' not in enum: {', '.join(PER_AGENT_USAGE)}")

# --- voice ----------------------------------------------------------------------
voice = data.get("voice")
if voice is not None:
    if not isinstance(voice, dict):
        errors.append("'voice' must be a mapping")
    else:
        for field in ("role", "tone", "perspective"):
            if field in voice and not isinstance(voice[field], str):
                errors.append(f"voice.{field} must be a string")
        for field in ("values", "avoid"):
            if field in voice and not isinstance(voice[field], list):
                errors.append(f"voice.{field} must be a list of strings")

# --- services --------------------------------------------------------------------
services = data.get("services")
if services is not None:
    if not isinstance(services, list):
        errors.append("'services' must be a list")
    else:
        for i, service in enumerate(services):
            tag = f"services[{i}]"
            if not isinstance(service, dict):
                errors.append(f"{tag} must be a mapping")
                continue
            for field in ("id", "name", "description", "url"):
                if not service.get(field):
                    errors.append(f"{tag}.{field} is required")
            if service.get("url") and not is_uri(service["url"]):
                errors.append(f"{tag}.url must be an http(s) URI")

# --- discovery ---------------------------------------------------------------------
discovery = data.get("discovery")
if discovery is not None and not (
    isinstance(discovery, dict)
    and all(isinstance(v, str) for v in discovery.values())
):
    errors.append("'discovery' must be a mapping of name -> URI string")

# --- api_schema --------------------------------------------------------------------
api = data.get("api_schema")
if api is not None:
    if not isinstance(api, dict):
        errors.append("'api_schema' must be a mapping")
    else:
        if api.get("type") not in ("openapi", "mcp"):
            errors.append("api_schema.type must be 'openapi' or 'mcp'")
        if api.get("url") and not is_uri(api["url"]):
            errors.append("api_schema.url must be an http(s) URI")

# --- verdict -------------------------------------------------------------------------
for warning in warnings:
    print(f"WARN: {warning}")

if errors:
    print(f"FAIL: {len(errors)} error(s) in {path}")
    for error in errors:
        print(f"  - {error}")
    sys.exit(1)

print(f"PASS: {path} is a valid agents.txt v2.0 (Markdown format)")
sys.exit(0)
PYEOF

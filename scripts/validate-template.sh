#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
xml="$root/templates/hindsight.xml"
profile="$root/ca_profile.xml"
compose="$root/compose/compose.yaml"
external_compose="$root/compose/external-postgres.yaml"
override="$root/overrides/hermes/plugins/memory/hindsight/__init__.py"

if command -v xmllint >/dev/null 2>&1; then
  xmllint --noout "$xml" "$profile"
else
  python3 - "$xml" "$profile" <<'PY'
import sys
import xml.etree.ElementTree as ET

for path in sys.argv[1:]:
    ET.parse(path)
PY
fi

required=(
  HINDSIGHT_API_DATABASE_URL
  HINDSIGHT_API_TENANT_EXTENSION
  HINDSIGHT_API_TENANT_API_KEY
  HINDSIGHT_CP_DATAPLANE_API_KEY
  HINDSIGHT_CP_ACCESS_KEY
  HINDSIGHT_API_MCP_ENABLED
  HINDSIGHT_API_OTEL_TRACES_ENABLED
)

for name in "${required[@]}"; do
  grep -q "$name" "$xml"
  grep -q "$name" "$compose"
  grep -q "$name" "$external_compose"
done

if grep -R -nE '(:latest|Privileged>true|<Network>host|/var/run/docker.sock)' \
  "$xml" "$compose" "$external_compose"; then
  echo "unsafe or mutable container configuration found" >&2
  exit 1
fi

grep -q 'ghcr.io/vectorize-io/hindsight:0.8.5@sha256:' "$xml"
grep -q 'ghcr.io/vectorize-io/hindsight:0.8.5@sha256:' "$compose"
grep -q 'ghcr.io/vectorize-io/hindsight:0.8.5@sha256:' "$external_compose"
python3 -m py_compile "$override"

echo "template validation passed"

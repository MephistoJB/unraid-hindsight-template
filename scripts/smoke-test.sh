#!/usr/bin/env bash
set -euo pipefail

base_url="${HINDSIGHT_URL:-http://localhost:8888}"
api_key="${HINDSIGHT_API_KEY:?HINDSIGHT_API_KEY is required}"

status_without_key="$(curl -sS -o /dev/null -w '%{http_code}' \
  "$base_url/v1/default/banks")"
case "$status_without_key" in
  401|403) ;;
  *)
    echo "API accepted an unauthenticated request: HTTP $status_without_key" >&2
    exit 1
    ;;
esac

curl -fsS -H "Authorization: Bearer $api_key" "$base_url/health" >/dev/null
echo "authenticated Hindsight health check passed"


#!/usr/bin/env bash
set -euo pipefail

base_url="${HINDSIGHT_URL:-http://localhost:8888}"
api_key="${HINDSIGHT_API_KEY:?HINDSIGHT_API_KEY is required}"
run_id="$(date -u +%Y%m%dT%H%M%SZ)-$$"
bank_id="hermes-e2e-$run_id"
marker="PRIVACY-E2E-$run_id"
tmp_dir="$(mktemp -d)"

auth=(-H "Authorization: Bearer $api_key")
json=(-H "Content-Type: application/json")

cleanup() {
  curl -fsS -X DELETE "${auth[@]}" \
    "$base_url/v1/default/banks/$bank_id" >/dev/null 2>&1 || true
  find "$tmp_dir" -depth -delete
}
trap cleanup EXIT

request() {
  local method="$1"
  local path="$2"
  local body="${3:-}"
  local output="$4"
  local started ended

  started="$(date +%s%3N)"
  if [[ -n "$body" ]]; then
    curl -fsS -X "$method" "${auth[@]}" "${json[@]}" \
      --data "$body" "$base_url$path" >"$output"
  else
    curl -fsS -X "$method" "${auth[@]}" "$base_url$path" >"$output"
  fi
  ended="$(date +%s%3N)"
  echo $((ended - started))
}

unauthenticated_status="$(curl -sS -o /dev/null -w '%{http_code}' \
  "$base_url/v1/default/banks")"
case "$unauthenticated_status" in
  401|403) ;;
  *)
    echo "FAIL unauthenticated API returned HTTP $unauthenticated_status" >&2
    exit 1
    ;;
esac

retain_one="$(printf \
  '{"items":[{"content":"Mein synthetischer Projektcode ist %s-ALPHA.","context":"isolierter automatischer Test","tags":["e2e","privacy"]}],"async":false}' \
  "$marker")"
retain_ms="$(request POST \
  "/v1/default/banks/$bank_id/memories" \
  "$retain_one" "$tmp_dir/retain-one.json")"

recall_one="$(printf \
  '{"query":"Wie lautet mein synthetischer Projektcode?","types":["world","experience"],"budget":"low","max_tokens":800,"tags":["e2e"],"tags_match":"all_strict"}')"
recall_ms="$(request POST \
  "/v1/default/banks/$bank_id/memories/recall" \
  "$recall_one" "$tmp_dir/recall-one.json")"

if ! grep -q "$marker-ALPHA" "$tmp_dir/recall-one.json"; then
  echo "FAIL initial recall did not contain the synthetic marker" >&2
  exit 1
fi

retain_two="$(printf \
  '{"items":[{"content":"Der synthetische Projektcode wurde auf %s-BETA geändert; ALPHA ist veraltet.","context":"isolierter automatischer Test","tags":["e2e","privacy"]}],"async":false}' \
  "$marker")"
contradiction_retain_ms="$(request POST \
  "/v1/default/banks/$bank_id/memories" \
  "$retain_two" "$tmp_dir/retain-two.json")"
contradiction_recall_ms="$(request POST \
  "/v1/default/banks/$bank_id/memories/recall" \
  "$recall_one" "$tmp_dir/recall-two.json")"

if ! grep -q "$marker-BETA" "$tmp_dir/recall-two.json"; then
  echo "FAIL contradiction recall did not contain the current marker" >&2
  exit 1
fi

printf '%s\n' \
  "PASS bank=$bank_id" \
  "retain_ms=$retain_ms" \
  "recall_ms=$recall_ms" \
  "contradiction_retain_ms=$contradiction_retain_ms" \
  "contradiction_recall_ms=$contradiction_recall_ms"


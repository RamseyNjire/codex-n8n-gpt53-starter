#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/_common.sh"

cd "${ROOT_DIR}"

RUN_ID="sync-$(date -u +%Y%m%dT%H%M%SZ)-$$"
START_TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
START_EPOCH="$(date +%s)"
STATUS="success"
FAILED_STEP=""
ERROR_SUMMARY=""

report() {
  local end_ts duration
  end_ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  duration="$(( $(date +%s) - START_EPOCH ))"

  local payload
  payload="$(jq -n \
    --arg event "sync.run" \
    --arg run_id "$RUN_ID" \
    --arg status "$STATUS" \
    --arg start "$START_TS" \
    --arg end "$end_ts" \
    --arg repo_path "$ROOT_DIR" \
    --arg branch "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)" \
    --arg failed_step "$FAILED_STEP" \
    --arg error_summary "$ERROR_SUMMARY" \
    '{event:$event,run_id:$run_id,status:$status,timestamp_start_utc:$start,timestamp_end_utc:$end,duration_sec:($ARGS.positional[0]|tonumber),repo_path:$repo_path,branch:$branch,failed_step:$failed_step,error_summary:$error_summary}' \
    --args "$duration")"

  if [[ -n "${SYNC_MONITOR_WEBHOOK_URL:-}" ]]; then
    if [[ -n "${SYNC_MONITOR_AUTH_TOKEN:-}" ]]; then
      curl -fsSL -X POST "$SYNC_MONITOR_WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${SYNC_MONITOR_AUTH_TOKEN}" \
        -d "$payload" >/dev/null || true
    else
      curl -fsSL -X POST "$SYNC_MONITOR_WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "$payload" >/dev/null || true
    fi
  fi
}

on_error() {
  local code=$?
  STATUS="failure"
  ERROR_SUMMARY="sync run failed (exit ${code})"
  report
  exit "$code"
}
trap on_error ERR
trap report EXIT

FAILED_STEP="sync-project-workflows"
"${SCRIPT_DIR}/sync-project-workflows.sh"

FAILED_STEP="prepush-check"
"${SCRIPT_DIR}/prepush-check.sh"

echo "Sync run completed."

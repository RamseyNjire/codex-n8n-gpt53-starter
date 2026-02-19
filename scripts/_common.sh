#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

: "${N8N_BASE_URL:?N8N_BASE_URL is not set. Add it to .env}"
: "${N8N_API_KEY:?N8N_API_KEY is not set. Add it to .env}"

N8N_BASE_URL="${N8N_BASE_URL%/}"
N8N_PAGE_SIZE="${N8N_PAGE_SIZE:-200}"

api_url() {
  local path="$1"
  printf '%s%s\n' "${N8N_BASE_URL}" "${path}"
}

api_get() {
  local path="$1"
  curl -fsSL \
    -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
    -H "Accept: application/json" \
    "$(api_url "${path}")"
}

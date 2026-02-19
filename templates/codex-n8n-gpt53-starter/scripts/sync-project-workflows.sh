#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/_common.sh"

ALLOWLIST_FILE="${SCRIPT_DIR}/workflow-allowlist.txt"
OUT_DIR="${ROOT_DIR}/workflows/active"
mkdir -p "${OUT_DIR}"

if [[ ! -f "${ALLOWLIST_FILE}" ]]; then
  echo "Missing allowlist: ${ALLOWLIST_FILE}"
  exit 1
fi

mapfile -t IDS < <(grep -vE '^\s*#|^\s*$' "${ALLOWLIST_FILE}")
if [[ "${#IDS[@]}" -eq 0 ]]; then
  echo "No workflow IDs found in ${ALLOWLIST_FILE}"
  exit 1
fi

for id in "${IDS[@]}"; do
  echo "Syncing workflow ${id} ..."
  json="$(api_get "/api/v1/workflows/${id}")"
  name="$(printf '%s' "$json" | jq -r '.name')"
  safe_name="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
  out_file="${OUT_DIR}/${safe_name}-${id}.json"
  printf '%s\n' "$json" | jq '.' > "${out_file}"
  echo "  -> ${out_file}"
done

echo "Sync complete."

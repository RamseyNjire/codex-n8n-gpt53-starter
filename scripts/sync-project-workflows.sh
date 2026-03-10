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

declare -A expected_files=()

for id in "${IDS[@]}"; do
  echo "Syncing workflow ${id} ..."
  json="$(api_get "/api/v1/workflows/${id}")"
  name="$(printf '%s' "$json" | jq -r '.name')"
  safe_name="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
  if [[ -z "${safe_name}" ]]; then
    safe_name="workflow"
  fi
  out_file="${OUT_DIR}/${safe_name}-${id}.json"
  printf '%s\n' "$json" | jq '.' > "${out_file}"
  expected_files["$(basename "${out_file}")"]=1
  echo "  -> ${out_file}"
done

while IFS= read -r stale_file; do
  base_name="$(basename "${stale_file}")"
  if [[ -z "${expected_files[${base_name}]:-}" ]]; then
    echo "Removing stale export ${stale_file}"
    rm -f "${stale_file}"
  fi
done < <(find "${OUT_DIR}" -maxdepth 1 -type f -name '*.json' | sort)

echo "Sync complete."

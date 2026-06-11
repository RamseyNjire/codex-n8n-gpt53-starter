#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/_common.sh"

cd "${ROOT_DIR}"

echo "[1/3] n8n API sanity check..."
api_get "/api/v1/workflows?limit=1" >/dev/null
echo "OK"

echo "[2/3] workflow scope check..."
ALLOWLIST_FILE="${SCRIPT_DIR}/workflow-allowlist.txt"
if [[ ! -f "${ALLOWLIST_FILE}" ]]; then
  echo "ERROR: missing allowlist: ${ALLOWLIST_FILE}"
  exit 1
fi

ALLOWLIST_IDS="$(mktemp)"
SEEN_IDS="$(mktemp)"
trap 'rm -f "${ALLOWLIST_IDS}" "${SEEN_IDS}"' EXIT

while IFS= read -r id; do
  [[ -z "${id}" ]] && continue
  printf '%s\n' "${id}" >> "${ALLOWLIST_IDS}"
done < <(grep -vE '^\s*#|^\s*$' "${ALLOWLIST_FILE}")

if [[ ! -s "${ALLOWLIST_IDS}" ]]; then
  echo "ERROR: no workflow IDs found in ${ALLOWLIST_FILE}"
  exit 1
fi

shopt -s nullglob
for workflow_file in workflows/active/*.json; do
  workflow_id="$(jq -r '.id // empty' "${workflow_file}")"
  if [[ -z "${workflow_id}" ]]; then
    echo "ERROR: workflow file missing .id: ${workflow_file}"
    exit 1
  fi

  if ! grep -Fxq "${workflow_id}" "${ALLOWLIST_IDS}"; then
    echo "ERROR: workflow file is not allowlisted: ${workflow_file} (id ${workflow_id})"
    exit 1
  fi

  if grep -Fxq "${workflow_id}" "${SEEN_IDS}"; then
    echo "ERROR: duplicate workflow export for id ${workflow_id}: ${workflow_file}"
    exit 1
  fi

  printf '%s\n' "${workflow_id}" >> "${SEEN_IDS}"
done
shopt -u nullglob

while IFS= read -r workflow_id; do
  if ! grep -Fxq "${workflow_id}" "${SEEN_IDS}"; then
    echo "ERROR: allowlisted workflow has no export in workflows/active: ${workflow_id}"
    exit 1
  fi
done < "${ALLOWLIST_IDS}"

echo "OK"

echo "[3/3] secret pattern scan..."
if rg -n --hidden -S \
  --glob '!secrets/**' \
  --glob '!.env' \
  '(sk-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z\-_]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|ghp_[A-Za-z0-9]{20,}|-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----|N8N_API_KEY=[A-Za-z0-9_-]{12,})' \
  workflows docs scripts .env.example README.md .gitignore; then
  echo "ERROR: potential secret pattern found"
  exit 1
fi
echo "OK"

echo "Pre-push checks passed."

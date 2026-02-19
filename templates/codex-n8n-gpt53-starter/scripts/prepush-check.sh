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
if [[ -d workflows/active ]]; then
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if [[ "$f" != workflows/active/* ]]; then
      echo "ERROR: workflow file out of scope: $f"
      exit 1
    fi
  done < <(find workflows/active -maxdepth 1 -type f | sed 's#^\./##')
fi
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

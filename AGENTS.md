# AGENTS

Guidelines for any coding agent (Codex, Claude Code, etc.) working on this repo.

## Working model
- PR-first: create branch `codex/<topic>` (or equivalent), no direct `main` pushes.
- Sync-first: treat n8n as mutable runtime and git as audited mirror.
- Docs-with-code: behavior changes require doc updates in same PR.

## Required workflow when making changes
1. Pull latest allowlisted workflow JSONs (`./scripts/sync-project-workflows.sh`).
2. Make scoped changes.
3. Run checks (`./scripts/prepush-check.sh`).
4. Update docs (`README`, inventory/runbook/contracts/changelog as needed).
5. Push branch + open PR.

## Security rules
- Never commit `.env` or real secrets.
- Keep real secrets only in `secrets/` (gitignored).
- Do not broaden workflow scope beyond project allowlist.

## Documentation minimum
- `docs/WORKFLOW_INVENTORY.md`: workflow list + IDs + schedules.
- `docs/RUNBOOK.md`: daily checks and rerun/incident procedures.
- `docs/SYNC_MONITORING.md`: sync reporting and alert path.
- `docs/CHANGELOG.md`: concise operationally relevant entries.

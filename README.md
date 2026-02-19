# n8n Project Starter (System Template)

Use this template for any n8n automation system that has multiple workflows, shared data contracts, operational monitoring, and ongoing n8n↔repo synchronization.

## Core principles
1. Sync-first: keep repo JSON in lockstep with live n8n workflows.
2. PR-first: no direct `main` pushes; use short-lived review branches.
3. Guardrails-first: run pre-push checks (scope + secret scan + API sanity).
4. Docs-with-code: update docs in the same PR as behavior changes.

## Quick start
1. Copy this folder into a new repo.
2. Copy `.env.example` to `.env` and fill local values.
3. Define workflow allowlist in `scripts/workflow-allowlist.txt`.
4. Install hooks:
   ```bash
   ./scripts/install-git-hooks.sh
   ```
5. Pull/sync workflows:
   ```bash
   ./scripts/sync-project-workflows.sh
   ```
6. Run checks before push:
   ```bash
   ./scripts/prepush-check.sh
   ```

## Folder layout
- `docs/`: system-level docs and operating standards.
- `workflows/active/`: current exported workflow JSON files (git source of truth).
- `workflows/archive/`: historical workflow JSON files.
- `scripts/`: sync, validation, and automation support scripts.
- `secrets/`: local-only sensitive material (gitignored).
- `.githooks/`: repo-managed git hooks.

## Minimum maintainability standard
- Every workflow documented in `docs/WORKFLOW_INVENTORY.md`.
- Every schedule documented in `docs/SYSTEM_OVERVIEW.md` + runbook.
- Data contracts documented in `docs/DATA_CONTRACTS.md`.
- Monitoring documented and tested (`docs/SYNC_MONITORING.md`).
- Release checklist followed (`docs/RELEASE_CHECKLIST.md`).
- Security checklist reviewed (`docs/SECURITY.md`).

## Suggested branch workflow
- Branch names: `codex/<short-topic>`
- Commit in logical units.
- Open PR, review, then merge.
- After merge: re-sync from live n8n if UI edits happened during review.

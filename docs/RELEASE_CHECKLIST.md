# Release Checklist

Use this before and after publishing workflow/system changes.

## Pre-Release
- [ ] Validate changes in n8n with representative manual run.
- [ ] Verify only intended workflows were modified.
- [ ] Sync updated workflow JSON into `workflows/active/`.
- [ ] Confirm schedules/active states are correct.
- [ ] Confirm webhook URLs and callback paths are correct.
- [ ] Run pre-push checks (`./scripts/prepush-check.sh`).
- [ ] Update docs in same change set:
  - [ ] `README.md`
  - [ ] `docs/WORKFLOW_INVENTORY.md`
  - [ ] `docs/DATA_CONTRACTS.md` (if schema/contract changed)
  - [ ] `docs/RUNBOOK.md` / `docs/TROUBLESHOOTING.md`
  - [ ] `docs/CHANGELOG.md`

## Release
- [ ] Commit with clear message.
- [ ] Push branch and open PR.
- [ ] Ensure workflows are published/active as intended.

## Post-Release
- [ ] Check first scheduled run outcome.
- [ ] Check monitoring webhook heartbeat.
- [ ] Check alert behavior (success/failure notifications).
- [ ] Spot-check key downstream outputs.

## Rollback Plan
- [ ] Identify last known-good commit/workflow export.
- [ ] Re-import known-good workflow JSONs.
- [ ] Re-activate schedules if needed.
- [ ] Validate with scoped manual run.

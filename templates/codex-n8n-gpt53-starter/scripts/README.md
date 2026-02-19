# Scripts

This starter includes generic guardrails for n8n project maintenance.

## Included scripts
- `scripts/sync-project-workflows.sh`
  - Pulls workflow JSON by ID allowlist into `workflows/active/`.
- `scripts/prepush-check.sh`
  - API sanity check + workflow scope check + secret pattern scan.
- `scripts/run-sync.sh`
  - Wrapper to run sync + checks and post success/failure to monitoring webhook.
- `scripts/install-git-hooks.sh`
  - Sets `core.hooksPath=.githooks`.

## Setup
1. Fill `.env` from `.env.example`.
2. Add workflow IDs to `scripts/workflow-allowlist.txt`.
3. Install hooks:
   ```bash
   ./scripts/install-git-hooks.sh
   ```

## Typical usage
```bash
./scripts/sync-project-workflows.sh
./scripts/prepush-check.sh
./scripts/run-sync.sh
```

## Notes
- Keep scripts idempotent and safe by default.
- Keep allowlist strict to avoid importing unrelated workflows.

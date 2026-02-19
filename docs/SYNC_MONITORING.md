# Sync Monitoring

Use this pattern to monitor repo sync runs.

## Objective
For each sync run, capture:
- success/failure
- timestamp + duration
- run identifier
- brief error summary on failure

## Script side
`./scripts/run-sync.sh` can POST a JSON payload to:
- `SYNC_MONITOR_WEBHOOK_URL`
- optional bearer auth via `SYNC_MONITOR_AUTH_TOKEN`

## Suggested n8n monitor workflow
1. `Webhook` node (POST)
2. `Normalize` node (shape payload)
3. `Append row` to a `Sync_Ops` tab (or equivalent)
4. `IF status == failure` -> send alert email/chat
5. Optional: send success heartbeat email or sheet-only

## Security
- Keep monitor tokens local only (never commit).
- Validate auth token in monitor workflow if used.

## Quick test
1. Set webhook vars in `.env`.
2. Run:
   ```bash
   ./scripts/run-sync.sh
   ```
3. Confirm one monitor execution in n8n.
4. Confirm one row in sync log destination.

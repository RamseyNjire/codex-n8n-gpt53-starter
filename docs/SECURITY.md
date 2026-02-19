# Security

## Core Rules
- Never commit `.env` or real credentials.
- Keep real secrets in `secrets/` (gitignored) or external secret manager.
- Use least-privilege API/database credentials.
- Rotate keys when exposure is suspected.

## n8n API Safety
- Use HTTPS `N8N_BASE_URL`.
- Scope sync scripts with workflow allowlist.
- Run pre-push checks before each push.

## Webhook Safety
- Use auth/signature validation for sensitive webhooks.
- Avoid logging secrets in workflow execution data.

## Incident Steps
1. Revoke/rotate exposed credentials.
2. Audit affected workflows and logs.
3. Document incident + remediation in `docs/CHANGELOG.md`.

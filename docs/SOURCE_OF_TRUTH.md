# Source Of Truth

This repo is not the platform source of truth for Speakeasy ticketing policy.

## Authoritative systems
1. Zammad live platform behavior is authoritative for current runtime reality.
2. `/Users/app/Documents/speakeasy-zammad-poc` is authoritative for Zammad platform implementation notes, scripts, and incidents.
3. `/Users/app/Documents/speakeasy-ticketing-vault` is authoritative for SOP, rollout, and operating-policy history.

## This repo owns
1. n8n workflow logic.
2. AI-assisted follow-up recovery heuristics.
3. Webhook payload handling.
4. Confidence scoring and escalation behavior.
5. Monitoring and runbooks for the automation layer.

## Conflict rule
If a document in this repo conflicts with the Zammad repo or the ticketing vault, the Zammad repo and vault win.

## Required handoff docs
Before changing automation behavior, review:
1. [ZAMMAD_SYSTEM_CONTEXT.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/ZAMMAD_SYSTEM_CONTEXT.md)
2. [PROJECT_DEFINE.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/PROJECT_DEFINE.md)
3. [INTEGRATION_REQUIREMENTS.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/INTEGRATION_REQUIREMENTS.md)
4. [Current Zammad State](/Users/app/Documents/speakeasy-zammad-poc/CURRENT-STATE.md)
5. [N8N Thread Recovery Handoff](/Users/app/Documents/speakeasy-zammad-poc/N8N-THREAD-RECOVERY-HANDOFF.md)

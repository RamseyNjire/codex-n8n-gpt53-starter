# Runbook

## Daily operations
1. Confirm core workflows are in the intended state.
2. Check last execution status.
3. Review alert summary output.

## Current workflows
| Workflow | Intended State | Check | Notes |
|---|---|---|---|
| Speakeasy Zammad Follow-Up Intake Capture | Active for HIT capture after Zammad webhook wiring. | Confirm workflow `WatpsOM8UoML1pJ7` exists in n8n, is active, and the `Fetch Ticket Articles` node has the Zammad HTTP Header Auth credential selected. | Production URL: `https://webhooks.speakeasymarketinginc.com/webhook/speakeasy-zammad-follow-up-intake`; scoped to HIT group id `2`. |

## Safe rerun procedures
- Intake Capture rerun scope: replay one sanitized Zammad new-ticket webhook payload into the test webhook while the workflow is open in n8n.
- Backfill approach: none for capture phase; do not replay historical tickets into mutation workflows until scoring and review rules are approved.

## Incident response
1. Identify failing node/workflow.
2. Capture payload + error.
3. Apply fix from troubleshooting guide.
4. Re-run minimal scope.
5. Confirm downstream consistency.

## Change rollout checklist
- [ ] Update workflow JSON in repo.
- [ ] Publish to n8n.
- [ ] Verify active/schedules.
- [ ] Update docs/changelog.

## Intake capture setup
1. Open workflow `WatpsOM8UoML1pJ7` in n8n.
2. Create or select an n8n HTTP Header Auth credential for Zammad API access.
3. Credential header name: `Authorization`.
4. Credential header value: `Token token=<ZAMMAD_API_TOKEN>`.
5. Select that credential on the `Fetch Ticket Articles` node.
6. Confirm the Zammad webhook endpoint is `https://webhooks.speakeasymarketinginc.com/webhook/speakeasy-zammad-follow-up-intake`.
7. Send one HIT new-ticket webhook payload or create one HIT test ticket.
8. Confirm the response includes `success`, `ticket_id`, `group_id`, `is_hit_scope`, and `missing_fields`.
9. Confirm the normalized output includes `article_fetch.returned_count`, `article_fetch.selected_article_id`, and the original inbound `article.body_excerpt`.
10. Confirm candidate output includes `candidate_lookup.recommendation`, `candidate_lookup.viable_count`, and ranked `candidate_lookup.top_candidates`.
11. If candidates exist, confirm `review_note.written=true` and inspect the internal note on the new Zammad ticket.

## Deterministic candidate tuning
- Healthy exact match: `candidate_lookup.hard_gate_unique_match=true` and one `exact_composite_ticket_level` candidate.
- Healthy review match: `recommendation=candidate_review` with a short candidate list whose reasons include subject similarity or same organization, not only same customer.
- Too noisy: unrelated same-customer tickets appear without subject or organization overlap.
- Tie-break check: when fuzzy candidates share tier and score, ranking should prefer higher subject similarity, then the older ticket as the likely parent.
- Current limitation: candidate scoring is ticket-level only; candidate article participant overlap is not part of v1 scoring yet.

## Review note writeback
- The workflow writes an internal Zammad note only for `high_confidence_review` or `candidate_review`.
- The note is internal, HTML formatted, and review-only.
- The workflow must not merge tickets, change state, change owner, send customer-visible email, or add tags in this phase.
- If note writing fails, inspect node `Create Review Note` and confirm the `Speakeasy Workflows (Zammad) API` credential can create ticket articles.

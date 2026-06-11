# Workflow Inventory

Track every workflow in scope for this project.

| Workflow Name | Workflow ID | Purpose | Trigger Type | Schedule/Timing | Inputs | Outputs | Dependencies | Notes |
|---|---|---|---|---|---|---|---|---|
| Speakeasy Zammad Follow-Up Intake Capture | WatpsOM8UoML1pJ7 | Capture Zammad HIT new-ticket webhooks, fetch source articles, run deterministic candidate scoring, and write internal review notes for possible follow-ups. | webhook | On Zammad new-ticket event for HIT group id `2`; active after production webhook wiring. | Zammad webhook JSON, Zammad ticket articles fetched by `ticket.id`, and recent HIT tickets from `tickets/search?query=group_id:2`. | Internal Zammad note for `high_confidence_review`/`candidate_review`; `200 OK` JSON acknowledgement with ticket id, group id, candidate recommendation, top candidate number/count, and review note article id. | n8n webhook runtime; Zammad webhook configuration; n8n HTTP Header Auth credential for Zammad API. | Review-only: no merge, state change, owner change, customer-visible email, or tag mutation. Production webhook host: `https://webhooks.speakeasymarketinginc.com`; path: `speakeasy-zammad-follow-up-intake`. |

## Rules
- Keep this file updated whenever a workflow is added, renamed, deleted, or re-scoped.
- Include exact workflow IDs from n8n.
- Keep schedule and trigger details explicit (with timezone where relevant).

# Project Define

## Project Snapshot
- Project name: Speakeasy Zammad Follow-Up Recovery
- Date: 2026-05-12
- Version: v0.1
- Prepared by: Codex + Ramsey Njire
- Stakeholders: Ramsey Njire, HIT team, SEO team, Topspot support stakeholders

## Problem Statement
- Business problem: marker-less replies on external email threads create duplicate Zammad tickets instead of appending to the original ticket.
- Why now: ticket adoption is increasing and duplicate-thread behavior will confuse teams and weaken trust in the system.
- If we do nothing: teams keep merging duplicate tickets manually, lose confidence in routing, and fall back to side-channel email habits.

## Success Criteria
- Primary KPI: reduce duplicate tickets caused by marker-less follow-up emails.
- Secondary KPI(s): reduce manual merge load, improve confidence in email-driven ticket intake, and preserve clean ownership history.
- Baseline value(s): duplicate marker-less replies currently create new tickets by default.
- Target value(s): high-confidence follow-up candidates are surfaced for human review with enough context to resolve quickly.
- Measurement window: first 30 days after MVP deployment.

## Current-State Workflow
- Entry points: inbound email to Zammad-linked mailboxes such as `hitteam@speakeasymarketinginc.com`.
- Major process steps:
  - email hits Zammad
  - Zammad tries deterministic threading by subject marker and references
  - if no reliable markers exist, Zammad creates a new ticket
- Current bottlenecks:
  - marker-less replies become duplicate tickets
  - managers or agents must detect and merge manually
- Current manual work:
  - reviewing similar open tickets
  - merging duplicates
  - reconstructing thread history mentally

## Future-State Workflow
- Desired intake flow:
  - Zammad remains the primary intake and deterministic matcher
  - new inbound tickets in scoped groups trigger n8n review for possible marker-less follow-up recovery
- Desired automation boundaries:
  - gather candidate tickets from Zammad
  - normalize subject/body
  - score likely parent tickets
  - ask AI for fuzzy comparison only after deterministic narrowing
- Human-in-the-loop boundaries:
  - MVP should recommend and flag, not auto-merge
  - any low-confidence or ambiguous case stays as a new ticket
- Escalation criteria:
  - multiple high-similarity candidates
  - conflicting sender/group signals
  - missing critical payload fields

## Scope
### In Scope
- Zammad webhook ingestion into n8n
- candidate-ticket lookup
- heuristic plus AI confidence scoring
- internal note / tag / notification recommendation path
- HIT as first rollout lane

### Out of Scope
- replacing Zammad native threading
- silent auto-merge in v1
- broad Topspot department onboarding logic
- outbound email channel reconfiguration

## Risks and Guardrails
- Risk: AI suggests the wrong parent ticket.
  - Guardrail: human review first; no v1 auto-merge.
- Risk: workflow adds noise instead of clarity.
  - Guardrail: only surface candidates above defined thresholds.
- Risk: data contracts drift from live Zammad payloads.
  - Guardrail: document payloads and validate fields before processing.

## Confirmed Facts
- Zammad currently searches follow-ups in subject and references.
- HIT group currently uses a live Gmail-backed inbound mailbox.
- SEO is now a top-level in-house group with its own Gmail-backed inbound mailbox.
- Marker-less external replies are a real operational problem in current usage.
- Zammad is the platform source of truth, not n8n.

## Assumptions
- n8n will be allowed to call the Zammad API for candidate lookup and ticket annotation.
- ticket/article webhook payloads will contain enough metadata for candidate narrowing.
- human reviewers will accept a flagged recommendation queue as an MVP.

## Open Questions
- Which groups should be included in v1 besides HIT?
- Should candidate review notify by internal note only, or also Slack/email?
- What confidence threshold is acceptable for “review suggested” status?

## Decisions Log
- Decision: build this as a sibling repo, not inside the Zammad repo.
  - Rationale: keep platform implementation and automation implementation separate but linked.
  - Date: 2026-05-12
  - Owner: Ramsey Njire
- Decision: start with recommendation flow, not auto-merge.
  - Rationale: mis-threading is riskier than duplicates during early rollout.
  - Date: 2026-05-12
  - Owner: Ramsey Njire

## Discovery Completion Gate
- [x] Business problem and KPI targets are explicit.
- [x] Current-state and future-state workflow are documented.
- [x] Human review and escalation boundaries are defined.
- [x] Assumptions and open questions are visible.
- [ ] Stakeholders approved this define document.

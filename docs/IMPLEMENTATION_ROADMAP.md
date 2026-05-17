# Implementation Roadmap

## Roadmap Summary
- Project: Speakeasy Zammad Follow-Up Recovery
- Date: 2026-05-12
- Owner: Ramsey Njire
- Version: v0.1

## Phase 0: Discovery Closeout
- Goal: close critical unknowns before build.
- Deliverables:
  - approved `PROJECT_DEFINE.md`
  - approved `INTEGRATION_REQUIREMENTS.md`
  - initial risk and guardrail matrix
- Exit criteria:
  - rollout scope approved for HIT-first start
  - webhook payload expectations confirmed
  - human review path approved

## Phase 1: MVP Happy Path
- Goal: prove one end-to-end workflow path.
- Scope:
  - Zammad webhook intake
  - normalize inbound subject/body
  - query recent open HIT tickets
  - heuristic ranking
  - AI ranking of narrowed candidates
  - write recommendation as internal note or tag
- Exit criteria:
  - representative duplicate/follow-up scenarios process successfully
  - false positives are acceptable for review-only flow

## Phase 2: Risk Gates and Human-in-the-Loop
- Goal: add trust and escalation controls.
- Scope:
  - confidence thresholds
  - ambiguous/multi-candidate branch
  - reviewer notification path
  - structured explanation payload
- Exit criteria:
  - ambiguous cases safely escalate to human review
  - no silent auto-merges

## Phase 3: Ops Hardening
- Goal: make the system maintainable in production.
- Scope:
  - monitoring and alerts
  - rerun and incident procedures
  - contract validation
  - failure logging
- Exit criteria:
  - runbook coverage complete
  - recovery procedure tested

## Phase 4: Rollout and Iteration
- Goal: controlled launch and improvements.
- Scope:
  - HIT-first rollout
  - optional expansion to SEO and selected Topspot lanes
  - threshold tuning from live examples
  - evaluate whether any future auto-link or auto-merge path is justified
- Exit criteria:
  - stable review process achieved
  - next optimization backlog prioritized

## Dependencies
- Zammad webhook configuration
- Zammad API credentials
- n8n runtime and secrets
- OpenAI API access
- representative test cases from real duplicate/follow-up tickets

## Milestones and Dates
- Milestone:
  - Target date: discovery docs approved
  - Owner: Ramsey Njire
- Milestone:
  - Target date: HIT MVP workflow built
  - Owner: Ramsey Njire
- Milestone:
  - Target date: first live review cycle completed
  - Owner: Ramsey Njire

## Risks
- Risk: insufficient webhook fields for good candidate narrowing
  - Mitigation: fetch ticket/article details through Zammad API before scoring
  - Owner: Ramsey Njire
- Risk: AI suggestions overwhelm reviewers with weak matches
  - Mitigation: start with conservative thresholds and same-group candidate limits
  - Owner: Ramsey Njire
- Risk: business routing rules change during rollout
  - Mitigation: keep the bridge docs updated with platform changes
  - Owner: Ramsey Njire

## Confirmed Facts
- duplicate marker-less reply behavior exists in live HIT usage
- Zammad deterministic matching should remain the primary thread resolver
- current platform groups and email-channel behavior are tracked in `/Users/app/Documents/speakeasy-zammad-poc/CURRENT-STATE.md`

## Assumptions
- a review-only MVP is acceptable to stakeholders

## Open Questions
- what exact ticket note/tag format should be written back into Zammad?
- should reviewer notification be email, note-only, or both?

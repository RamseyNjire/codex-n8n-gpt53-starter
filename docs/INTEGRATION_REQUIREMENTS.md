# Integration Requirements

## Integration Inventory
### Zammad Production
- Purpose: source ticket events, candidate lookup, and ticket annotation.
- System owner: Speakeasy platform / Ramsey Njire
- Environment: prod
- Authentication method: API token
- Required permission scopes: read tickets, read articles, create internal notes, update tags, optionally merge/link tickets later
- Rate limits / usage constraints: unknown, design for conservative polling and retries
- Compliance notes: sanitize ticket/article payloads before external AI submission if needed

### n8n Runtime
- Purpose: orchestration and decision flow
- System owner: Ramsey Njire
- Environment: dev then prod
- Authentication method: local runtime auth / service credentials
- Required permission scopes: webhook receive, HTTP requests, secret storage
- Rate limits / usage constraints: workflow execution concurrency should be monitored
- Compliance notes: keep tokens in secrets only

### OpenAI API
- Purpose: semantic comparison of new inbound email against candidate open tickets
- System owner: Ramsey Njire
- Environment: dev then prod
- Authentication method: API key
- Required permission scopes: model inference only
- Rate limits / usage constraints: design around token/cost ceilings and retries
- Compliance notes: do not send unnecessary PII

## Data Requirements
### Zammad inbound ticket event
- Producer: Zammad webhook / trigger
- Consumer: n8n intake workflow
- Transport: webhook JSON
- Required fields:
  - `ticket.id` (`number`) - new ticket identifier
  - `ticket.group_id` (`number`) - target group for scoping
  - `ticket.title` (`string`) - subject/title of the inbound ticket
  - `article.body` (`string`) - recent email content or first article body
  - `article.from` (`string`) - sender address
  - `ticket.customer_id` (`number`) - customer identifier if available
  - `ticket.created_at` (`string`) - event timestamp
- Optional fields:
  - `article.cc` (`string`) - cc recipients for similarity hints
  - `article.subject` (`string`) - raw email subject
  - `ticket.organization_id` (`number`) - organization context
- Validation rules:
  - required fields must be present before candidate search
  - group must be in scoped allowlist
- Failure handling:
  - log and drop if payload is missing critical fields

### Candidate ticket lookup result
- Producer: Zammad API lookup step
- Consumer: scoring / AI ranking step
- Transport: n8n item JSON
- Required fields:
  - `id` (`number`) - candidate ticket id
  - `title` (`string`) - candidate title
  - `group_id` (`number`) - candidate group
  - `updated_at` (`string`) - recency signal
- Optional fields:
  - `customer_id` (`number`) - customer signal
  - `article_preview` (`string`) - recent text summary if fetched
- Validation rules:
  - candidates must be open or pending
- Failure handling:
  - no candidates means leave ticket untouched

## Connection Readiness
- [ ] Credentials available and secured.
- [ ] Least-privilege scopes confirmed.
- [ ] Sandbox/test endpoint available.
- [ ] Representative test payloads prepared.
- [ ] Retry/rate-limit handling strategy defined.

## Data Governance Notes
- PII/PHI handling: minimize body text sent to AI; redact where possible.
- Retention policy: follow Zammad retention and repo hygiene practices.
- Logging and redaction requirements: never log secrets; avoid raw sensitive articles in plaintext logs.
- Audit requirements: every AI recommendation should be reproducible from stored score inputs or explanation text.

## Confirmed Facts
- HIT mailbox is already live in Zammad.
- SEO mailbox is already live in Zammad.
- Zammad outbound mail for Google channels must use `smtp-relay.gmail.com:587`, not `smtp.gmail.com:465`, on the current Hetzner host.
- Zammad API token workflows are already in use in adjacent ticketing work.

## Assumptions
- A Zammad webhook can be configured for the scoped events needed.
- Ticket/article payload structure will be stable enough for a v1 contract.

## Missing Inputs Needed From Client
- Preferred review channel: internal note only vs note + email/Slack
- Approved groups for v1 rollout beyond HIT

## Open Questions
- Which exact trigger event should start the workflow: new ticket, new article, or both?
- Should candidate lookup search only same group first, or allow cross-group candidates for some lanes?

## Recommendations
- Recommended integration approach: Zammad trigger/webhook -> n8n -> Zammad API annotate path
- Recommended storage/logging approach: lightweight structured execution logs in n8n plus ticket note evidence
- Recommended fallback strategy: leave ticket untouched when confidence is not clearly high enough for review suggestion

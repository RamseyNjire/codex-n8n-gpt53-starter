# Data Contracts

Capture payload and schema contracts between workflows and external systems.

## Contract Name
### Zammad Webhook Inbound Event
- Producer workflow/node: Zammad trigger/webhook
- Consumer workflow/node: `Speakeasy Zammad Follow-Up Intake Capture` / `Zammad New Ticket Webhook`
- Transport: webhook body
- Required fields:
  - `ticket.id` (`number`) - Zammad ticket id for the newly created ticket
  - `ticket.group_id` (`number`) - scoped group id
  - `ticket.title` (`string`) - ticket title / normalized email subject candidate
- Optional fields:
  - `article.body` (`string`) - inbound article body
  - `article.subject` (`string`) - raw subject if separate from ticket title
  - `article.cc` (`string`) - cc string
  - `event` (`string`) - trigger event type
  - `ticket.customer_id` (`number`) - customer reference
  - `ticket.organization_id` (`number`) - organization reference
- Validation rules:
  - missing `ticket.id`, `ticket.group_id`, or `ticket.title` should stop article fetching
  - only allowlisted groups continue; capture v1 allowlist is HIT group id `2`
  - webhook `article` may be a Zammad-generated notification; source article selection must fetch ticket articles by `ticket.id`
- Failure handling:
  - write structured error and exit cleanly without ticket mutation

## Contract Name
### Ticket Article Fetch
- Producer workflow/node: `Fetch Ticket Articles`
- Consumer workflow/node: `Select Source Article`
- Transport: Zammad API response from `/api/v1/ticket_articles/by_ticket/{ticket.id}`
- Required fields:
  - `id` (`number`) - Zammad article id
  - `ticket_id` (`number`) - owning Zammad ticket id
  - `type` or `type_id` (`string|number`) - article channel/type
  - `from` (`string`) - sender display/address
  - `subject` (`string`) - article subject
  - `body` (`string`) - article body
  - `created_at` (`string`) - article creation timestamp
- Selection rules:
  - prefer earliest non-internal email article that does not look like a HIT system notification
  - exclude articles from `hitteam@speakeasymarketinginc.com`, `sender=System`, subjects beginning `New HIT intake ticket`, and bodies containing the HIT intake notification text
  - fall back to first non-internal email article, then first available article, if no preferred candidate exists
- Failure handling:
  - article-fetch failures should not mutate Zammad; capture should be reviewed before downstream scoring

## Contract Name
### Intake Capture Normalized Output
- Producer workflow/node: `Select Source Article`
- Consumer workflow/node: `Acknowledge Capture`, later candidate lookup/scoring nodes
- Transport: n8n item JSON
- Required fields:
  - `ticket.id` (`number|null`) - parsed Zammad ticket id
  - `ticket.group_id` (`number|null`) - parsed Zammad group id
  - `ticket.title` (`string|null`) - parsed ticket title or article subject
  - `article.from` (`string|null`) - parsed sender email
  - `article.body_excerpt` (`string`) - whitespace-normalized excerpt capped at 2,000 characters
  - `article_fetch.returned_count` (`number`) - number of Zammad articles returned
  - `article_fetch.selected_article_id` (`number|null`) - selected source article id
  - `article_fetch.selection_strategy` (`string`) - selection path used
  - `is_hit_scope` (`boolean`) - whether `ticket.group_id` is `2`
  - `missing_fields` (`array`) - required fields not present in the incoming payload
  - `valid_for_scoring` (`boolean`) - true only when the ticket is HIT-scoped and required fields are present
- Optional fields:
  - `ticket.customer_id` (`number|null`) - customer reference
  - `ticket.organization_id` (`number|null`) - organization reference
  - `payload_shape` (`object`) - top-level, ticket, and article key names for discovery
- Failure handling:
  - response remains `200 OK` with `captured_needs_review`; no Zammad mutation occurs

## Contract Name
### Deterministic Candidate Lookup
- Producer workflow/node: `Search HIT Candidate Tickets` and `Score Deterministic Candidates`
- Consumer workflow/node: `Acknowledge Capture`, later AI ranking/review nodes
- Transport: n8n item JSON
- Required fields:
  - `candidate_lookup.strategy` (`string`) - current value `deterministic_ticket_level_v1`
  - `candidate_lookup.query` (`string`) - current Zammad query, `group_id:2`
  - `candidate_lookup.searched_count` (`number`) - raw ticket count returned by Zammad search
  - `candidate_lookup.scored_count` (`number`) - scored count after excluding the new ticket itself
  - `candidate_lookup.viable_count` (`number`) - count of candidates with a non-`no_match` tier
  - `candidate_lookup.recommendation` (`string`) - `high_confidence_review`, `candidate_review`, or `no_candidate`
  - `candidate_lookup.top_candidates` (`array`) - up to five ranked candidates
- Optional fields:
  - `candidate_lookup.top_candidate_id` (`number|null`) - highest ranked candidate ticket id
  - `candidate_lookup.top_candidate_number` (`string|null`) - highest ranked candidate ticket number
  - `candidate_lookup.hard_gate_unique_match` (`boolean`) - true when exactly one exact composite candidate exists
- Validation rules:
  - only state ids `1`, `2`, `3`, and `6` are considered open-ish
  - exact composite requires same group, open-ish state, within 60 days, same customer, exact normalized non-generic subject, and not the new ticket itself
  - strong composite requires same group, open-ish state, within 60 days, same customer or organization, and normalized subject similarity at least `0.75`
  - fuzzy ticket-level candidates require same group, open-ish state, within 60 days, score at least `45`, and subject similarity at least `0.45` or same organization
  - ranked candidates sort by match tier, deterministic score, subject similarity, then older ticket creation time to prefer likely parent tickets over newer duplicate/test tickets
  - current v1 is ticket-level only; candidate article participant overlap is deferred until the next enrichment pass
- Failure handling:
  - no candidates means response remains successful with `recommendation=no_candidate`; no Zammad mutation occurs

## Contract Name
### Review Note Writeback
- Producer workflow/node: `Prepare Review Note`, `Create Review Note`, and `Attach Review Note Result`
- Consumer workflow/node: Zammad ticket articles API and `Acknowledge Capture`
- Transport: `POST /api/v1/ticket_articles`
- Write condition:
  - only when `candidate_lookup.recommendation` is `high_confidence_review` or `candidate_review`
  - only when at least one ranked candidate exists
- Required payload fields:
  - `ticket_id` (`number`) - new ticket id receiving the internal note
  - `subject` (`string`) - `Possible follow-up detected for #<ticket_number>`
  - `body` (`string`) - HTML review summary with recommendation, hard-gate flag, source article, normalized subject, and ranked candidates
  - `content_type` (`string`) - `text/html`
  - `type` (`string`) - `note`
  - `internal` (`boolean`) - `true`
  - `sender` (`string`) - `Agent`
- Response fields:
  - `review_note.written` (`boolean`) - true when Zammad returns a created article id
  - `review_note.article_id` (`number|null`) - created internal note article id
- Safety rules:
  - no merge, state change, owner change, customer-visible email, or tag mutation occurs in this phase
  - `no_candidate` results must not write a review note

## Contract Name
### AI Match Decision
- Producer workflow/node: AI ranking step
- Consumer workflow/node: action router
- Transport: n8n item JSON
- Required fields:
  - `best_match_ticket_id` (`number|null`) - most likely parent ticket
  - `confidence` (`number`) - 0-1 confidence score
  - `reason` (`string`) - concise justification
  - `decision` (`string`) - one of `review`, `no_match`, `auto_action`
- Optional fields:
  - `runner_up_ticket_ids` (`array`) - secondary candidates
  - `score_breakdown` (`object`) - heuristic/AI blend metadata
- Validation rules:
  - `confidence` must be between `0` and `1`
  - `decision=auto_action` should remain disabled in v1
- Failure handling:
  - invalid decision payload becomes `review` only

## Notes
- Update this whenever payload shape changes.
- Keep examples sanitized and avoid live secrets or customer-sensitive content.

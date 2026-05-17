# Data Contracts

Capture payload and schema contracts between workflows and external systems.

## Contract Name
### Zammad Webhook Inbound Event
- Producer workflow/node: Zammad trigger/webhook
- Consumer workflow/node: n8n intake webhook
- Transport: webhook body
- Required fields:
  - `ticket.id` (`number`) - Zammad ticket id for the newly created or updated ticket
  - `ticket.group_id` (`number`) - scoped group id
  - `ticket.title` (`string`) - ticket title / normalized email subject candidate
  - `article.body` (`string`) - inbound article body
  - `article.from` (`string`) - sender email
  - `event` (`string`) - trigger event type
- Optional fields:
  - `article.subject` (`string`) - raw subject if separate from ticket title
  - `article.cc` (`string`) - cc string
  - `ticket.customer_id` (`number`) - customer reference
  - `ticket.organization_id` (`number`) - organization reference
- Validation rules:
  - missing `ticket.id`, `ticket.group_id`, `ticket.title`, or `article.from` should stop scoring
  - only allowlisted groups continue
- Failure handling:
  - write structured error and exit cleanly without ticket mutation

## Contract Name
### Candidate Match Request
- Producer workflow/node: candidate lookup and normalization step
- Consumer workflow/node: AI ranking step
- Transport: n8n item JSON
- Required fields:
  - `new_ticket.id` (`number`) - new inbound ticket id
  - `new_ticket.group_id` (`number`) - new inbound group id
  - `new_ticket.normalized_subject` (`string`) - cleaned subject
  - `new_ticket.sender_email` (`string`) - sender address
  - `new_ticket.body_excerpt` (`string`) - bounded body excerpt
  - `candidates` (`array`) - candidate tickets to evaluate
- Optional fields:
  - `new_ticket.cc_emails` (`array`) - parsed CC list
  - `new_ticket.organization_id` (`number`) - org hint
- Validation rules:
  - candidate list may be empty
  - body excerpt should be truncated to a safe token budget
- Failure handling:
  - if AI step fails, no ticket mutation; optionally notify reviewer

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

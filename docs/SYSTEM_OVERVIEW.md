# System Overview

## Purpose
Recover likely follow-up emails that arrive on marker-less external threads and would otherwise become duplicate Zammad tickets.

## In Scope
- inbound Zammad webhook from selected groups
- candidate ticket lookup through Zammad API
- subject/body normalization
- heuristic scoring and AI-assisted ranking
- recommendation note/tag/notification back into Zammad or adjacent ops channels

## Out of Scope
- replacing Zammad native ticket threading
- broad business-process orchestration for all ticket flows
- automatic irreversible ticket merges in v1

## Upstream Dependencies
- Zammad production instance
- Zammad webhook payload
- Zammad API credentials
- OpenAI model access for similarity reasoning
- n8n runtime

## Downstream Outputs
- internal note on candidate duplicate/follow-up ticket
- manager/ticket-master alert for review
- optional tags such as `possible-follow-up` or `possible-duplicate`
- later: optional merge/link action via Zammad API

## Runtime Model
- Trigger: webhook on new inbound ticket events for scoped groups.
- Worker behavior:
  - parse payload
  - normalize ticket context
  - fetch ticket articles from Zammad by `ticket.id`
  - select the first relevant non-system external email article
  - search recent HIT tickets with Zammad query `group_id:2`
  - score deterministic ticket-level candidate matches by state, recency, customer, organization, and normalized subject similarity
  - return review-only candidate recommendation metadata
- Webhook endpoints in use:
  - `https://webhooks.speakeasymarketinginc.com/webhook/speakeasy-zammad-follow-up-intake`: active n8n capture workflow for HIT new-ticket payload discovery

## Ownership
- Business owner: Ramsey Njire
- Technical owner: Ramsey Njire
- Escalation path: Ramsey Njire -> platform owner / ticketing stakeholders

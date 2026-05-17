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
- Trigger: webhook on new inbound ticket/article events for scoped groups.
- Worker behavior:
  - parse payload
  - normalize message subject and recent article body
  - fetch candidate open tickets
  - score and rank candidates
  - branch by confidence
- Webhook endpoints in use:
  - planned n8n inbound review endpoint for Zammad webhook

## Ownership
- Business owner: Ramsey Njire
- Technical owner: Ramsey Njire
- Escalation path: Ramsey Njire -> platform owner / ticketing stakeholders

# Zammad System Context

## Business context
Speakeasy is using Zammad as the in-house ticketing backbone while gradually reducing operational dependence on Topspot.

Topspot still handles support intake and multiple internal departments. HIT and SEO are already being moved in-house. The ticketing system is meant to preserve visibility, capture institutional knowledge, and make cross-department routing explicit instead of hidden in private inboxes.

For deeper organizational/adoption context, read `/Users/app/Documents/speakeasy-zammad-poc/docs/architecture/ORGANIZATIONAL-CONTEXT.md`.

## Core routing model
1. Requesters are still familiar with `support@speakeasymarketinginc.com`.
2. Topspot acts as a multi-department vendor lane with a Ticket Master role.
3. HIT and SEO act as direct in-house department lanes where the manager is effectively the ticket master.
4. Cross-department routing is intentionally allowed because work often spans teams.

## Active groups of interest
1. `HIT`
2. `Topspot`
3. `SEO`
4. `CDT`

Known Topspot internal departments expected to be onboarded over time:
1. `Video`
2. `Newsletter`
3. `Marketing`
4. `Book`

Important current-state notes:
1. `SEO` is now a top-level group, not `Topspot::SEO`.
2. HIT and SEO are direct in-house department lanes.
3. Topspot remains a multi-department vendor lane and still needs a Ticket Master role for initial routing.
4. Zammad platform state is documented in `/Users/app/Documents/speakeasy-zammad-poc/CURRENT-STATE.md`.

## Queue model
Each active department currently follows the same four queue views:
1. `All New`
2. `Assigned/Open`
3. `Pending/Blocked`
4. `Completed/Closed`

Visibility policy:
1. Department managers and agents should only see their own department queues.
2. Admins can see queues for all departments.

## Email channel context
Current live intake/sender addresses:
1. `hitteam@speakeasymarketinginc.com` -> `HIT`
2. `seoteam@speakeasymarketinginc.com` -> `SEO`

Zammad uses Google Email channels for inbound intake. Outbound replies for those channels must use the Google Workspace SMTP relay on `smtp-relay.gmail.com:587` because direct Google SMTP on `smtp.gmail.com:465` is blocked from the Hetzner VPS.

n8n workflows should not patch or own Zammad email-channel configuration. Treat that as platform configuration owned by `/Users/app/Documents/speakeasy-zammad-poc`.

## Why this automation exists
Zammad handles deterministic email follow-up matching well when at least one of these is present:
1. `Ticket#...` subject marker
2. `References` / `In-Reply-To` headers from a Zammad-generated email

Problem case:
1. A normal external thread begins outside Zammad.
2. `hitteam@...` or another intake mailbox is copied.
3. Zammad creates the first ticket.
4. People keep replying to the original external thread instead of the Zammad-generated message.
5. Later emails arrive without Zammad markers.
6. Zammad creates duplicate tickets because it cannot match confidently.

## Automation goal
The automation layer should help identify likely marker-less follow-ups and route them into a human review flow for merge or linkage.

It should not become the primary ticketing system and should not silently merge unrelated work based on weak heuristics.

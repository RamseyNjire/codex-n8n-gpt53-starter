# Changelog

Use concise operational entries for workflow/system changes.

## Change Entry Template
### YYYY-MM-DD
- Changed:
  - 
- Why:
  - 
- Risk:
  - Low / Medium / High
- Rollback:
  - 

---

## 2026-06-09
- Changed:
  - Created inactive n8n workflow `Speakeasy Zammad Follow-Up Intake Capture` (`WatpsOM8UoML1pJ7`) for HIT new-ticket webhook payload capture.
  - Added the workflow to the project allowlist and synced its JSON export into `workflows/active/`.
  - Documented the capture workflow in inventory, runbook, system overview, and data contracts.
  - Made sync/pre-push scripts compatible with the default macOS Bash runtime.
- Why:
  - Establish the first real intake path for learning the live Zammad webhook payload before building candidate matching.
- Risk:
  - Low (workflow is inactive and does not mutate Zammad).
- Rollback:
  - Remove workflow `WatpsOM8UoML1pJ7` from n8n and revert this commit.

---

## 2026-06-10
- Changed:
  - Activated workflow `Speakeasy Zammad Follow-Up Intake Capture` and wired Zammad production webhook traffic through `webhooks.speakeasymarketinginc.com`.
  - Added Zammad article fetching and source-article selection so capture uses the original inbound article instead of trigger-generated notification articles.
  - Documented the n8n HTTP Header Auth credential requirement for the `Fetch Ticket Articles` node.
  - Updated workflow sync exports to omit n8n `shared` and `pinData` metadata.
- Why:
  - Avoid scoring against Zammad auto-response articles when a trigger fires after notification creation.
  - Keep owner metadata and pinned payload samples out of the audited workflow mirror.
- Risk:
  - Medium (workflow is active and now requires an n8n HTTP Header Auth credential for Zammad API access; still no Zammad mutation).
- Rollback:
  - Disable Zammad trigger/webhook or deactivate workflow `WatpsOM8UoML1pJ7`, then revert this commit.

---

## 2026-06-11
- Changed:
  - Added deterministic ticket-level candidate lookup to workflow `Speakeasy Zammad Follow-Up Intake Capture`.
  - Search now pulls recent HIT tickets with Zammad query `group_id:2` and scores candidates by open-ish state, 60-day recency, same customer, same organization, normalized subject similarity, and exact composite gates.
  - Tightened fuzzy candidate eligibility so same-customer-only tickets do not appear without subject or organization overlap.
  - Updated fuzzy tie-breaking to prefer stronger subject similarity, then older ticket creation time, instead of most recently updated tickets.
  - Added internal Zammad review-note writeback for `high_confidence_review` and `candidate_review` results.
  - Documented candidate lookup output, scoring tiers, and tuning checks.
- Why:
  - Provide a transparent candidate shortlist before introducing AI ranking.
  - Surface likely follow-up recommendations inside the ticket where managers already work.
- Risk:
  - Medium (active workflow now performs an additional Zammad ticket search and writes internal notes on matched HIT new-ticket events).
- Rollback:
  - Remove or bypass the review-note nodes, or revert workflow `WatpsOM8UoML1pJ7` to the article-capture-only version and resync the repo.

---

## 2026-02-19
- Changed:
  - Added missing starter docs for inventory/changelog/system/contracts/security.
- Why:
  - Complete baseline documentation set expected by README/checklists.
- Risk:
  - Low (documentation only).
- Rollback:
  - Revert this commit.

---

## 2026-03-10
- Changed:
  - Tightened sync/check scripts so allowlisted workflow exports are validated and stale exports are removed.
  - Fixed sync monitoring to emit a single report per run, including failures.
  - Documented local prerequisites and sync behavior in starter docs.
- Why:
  - Make the template safer to reuse across real n8n repos and reduce drift between live workflows and checked-in JSON.
- Risk:
  - Medium (script behavior now fails faster on invalid or missing exports).
- Rollback:
  - Revert this commit.

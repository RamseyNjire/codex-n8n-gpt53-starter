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

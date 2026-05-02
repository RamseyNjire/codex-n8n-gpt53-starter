# n8n Project Starter (System Template)

Use this template for any n8n automation system that has multiple workflows, shared data contracts, operational monitoring, and ongoing n8n↔repo synchronization.

## Core principles
1. Sync-first: keep repo JSON in lockstep with live n8n workflows.
2. PR-first: no direct `main` pushes; use short-lived review branches.
3. Guardrails-first: run pre-push checks (scope + secret scan + API sanity).
4. Docs-with-code: update docs in the same PR as behavior changes.

## Start with Discovery (Codex Interview Mode)
Before building workflows, use Codex to interview stakeholders and produce a defining spec.

Why this matters:
- Most automation failures come from unclear business rules, missing edge cases, and unknown system constraints.
- A better first step is "Interview -> Spec -> Roadmap -> Build", not "nodes first".

Expected discovery outputs:
- `docs/PROJECT_DEFINE.md`:
  - business problem and success metrics
  - current workflow and bottlenecks
  - future-state workflow and escalation boundaries
  - assumptions, unknowns, and decisions
- `docs/INTEGRATION_REQUIREMENTS.md`:
  - required systems, data fields, auth scopes, and data owners
- `docs/IMPLEMENTATION_ROADMAP.md`:
  - phased plan (happy path -> risk gates -> ops hardening)

Suggested Codex prompt:

```text
Act as a solutions architect for an n8n automation project.
Interview me in short rounds to define the project before any implementation.

Rules:
1) Ask 5-8 focused questions per round.
2) Prioritize: business outcome, current process, edge cases, human approvals, data/contracts, and integrations.
3) After each round, summarize:
   - Confirmed facts
   - Assumptions
   - Open questions
   - Risks
4) Recommend required data fields and external connections with rationale.
5) Produce three docs:
   - PROJECT_DEFINE.md
   - INTEGRATION_REQUIREMENTS.md
   - IMPLEMENTATION_ROADMAP.md
6) Include confidence level per section and a "missing inputs" checklist.
7) Do not start building workflows until I approve the define docs.
```

Discovery completion gate (before build):
- [ ] Business outcome and KPI target are explicit.
- [ ] Human-in-the-loop boundaries are defined.
- [ ] Data contract v1 is drafted (required vs optional fields).
- [ ] Integration/auth requirements are listed and feasible.
- [ ] MVP happy path and failure paths are both defined.

## Quick start
1. Copy this folder into a new repo.
2. Copy `.env.example` to `.env` and fill local values.
3. Define workflow allowlist in `scripts/workflow-allowlist.txt`.
4. Install hooks:
   ```bash
   ./scripts/install-git-hooks.sh
   ```
5. Pull/sync workflows:
   ```bash
   ./scripts/sync-project-workflows.sh
   ```
6. Run checks before push:
   ```bash
   ./scripts/prepush-check.sh
   ```

## Prerequisites
- `bash`
- `curl`
- `git`
- `jq`
- `rg` (`ripgrep`)

## Folder layout
- `docs/`: system-level docs and operating standards.
- `workflows/active/`: current exported workflow JSON files (git source of truth).
- `workflows/archive/`: historical workflow JSON files.
- `scripts/`: sync, validation, and automation support scripts.
- `secrets/`: local-only sensitive material (gitignored).
- `.githooks/`: repo-managed git hooks.

## Minimum maintainability standard
- Every workflow documented in `docs/WORKFLOW_INVENTORY.md`.
- Every schedule documented in `docs/SYSTEM_OVERVIEW.md` + runbook.
- Data contracts documented in `docs/DATA_CONTRACTS.md`.
- Monitoring documented and tested (`docs/SYNC_MONITORING.md`).
- Release checklist followed (`docs/RELEASE_CHECKLIST.md`).
- Security checklist reviewed (`docs/SECURITY.md`).

## Suggested branch workflow
- Branch names: `codex/<short-topic>`
- Commit in logical units.
- Open PR, review, then merge.
- After merge: re-sync from live n8n if UI edits happened during review.

## Sync behavior
- `scripts/sync-project-workflows.sh` exports every allowlisted workflow into `workflows/active/`.
- Stale workflow exports are removed when they no longer match the current allowlist + live workflow names.
- `scripts/prepush-check.sh` verifies that every exported workflow JSON maps to an allowlisted workflow ID.

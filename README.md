# Speakeasy Ticketing n8n

This repo is the automation companion to the live Speakeasy ticketing system.

Its first job is to host the n8n workflows and AI-assisted logic for Zammad edge cases that Zammad does not solve deterministically on its own, especially marker-less email follow-ups that currently create duplicate tickets instead of appending to an existing thread.

## Current focus
1. Build a safe follow-up recovery workflow for marker-less external email threads.
2. Keep Zammad as the primary ticketing system of record.
3. Use AI only as a confidence-scored helper for possible duplicate/follow-up matching.
4. Start with human review before any auto-merge behavior.

## Core principles
1. Sync-first: keep repo JSON in lockstep with live n8n workflows.
2. Zammad-first: deterministic Zammad matching remains the primary path.
3. Human-safe: low-confidence AI results must never silently rewrite ticket history.
4. Docs-with-code: workflow behavior and routing rules must be documented in the same repo.

## Source of truth
Read [SOURCE_OF_TRUTH.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/SOURCE_OF_TRUTH.md) before making behavior changes.

## Start here
1. [PROJECT_DEFINE.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/PROJECT_DEFINE.md)
2. [SYSTEM_OVERVIEW.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/SYSTEM_OVERVIEW.md)
3. [INTEGRATION_REQUIREMENTS.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/INTEGRATION_REQUIREMENTS.md)
4. [DATA_CONTRACTS.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/DATA_CONTRACTS.md)
5. [IMPLEMENTATION_ROADMAP.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/IMPLEMENTATION_ROADMAP.md)
6. [ZAMMAD_SYSTEM_CONTEXT.md](/Users/app/Documents/speakeasy-ticketing-n8n/docs/ZAMMAD_SYSTEM_CONTEXT.md)

## Folder layout
- `docs/`: system-level docs and operating standards.
- `workflows/active/`: current exported workflow JSON files (git source of truth).
- `workflows/archive/`: historical workflow JSON files.
- `scripts/`: sync, validation, and automation support scripts.
- `secrets/`: local-only sensitive material (gitignored).
- `.githooks/`: repo-managed git hooks.

## Minimum maintainability standard
- Every workflow documented in `docs/WORKFLOW_INVENTORY.md`.
- Every schedule documented in `docs/SYSTEM_OVERVIEW.md` and `docs/RUNBOOK.md`.
- Data contracts documented in `docs/DATA_CONTRACTS.md`.
- Monitoring documented and tested in `docs/SYNC_MONITORING.md`.
- Release checklist followed from `docs/RELEASE_CHECKLIST.md`.
- Security checklist reviewed in `docs/SECURITY.md`.

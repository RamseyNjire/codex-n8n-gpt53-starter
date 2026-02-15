# AGENTS.md

This file defines how Codex should operate inside this repository.

## Objectives
- Help build, document, and maintain n8n automation workflows.
- Keep changes reviewable, testable, and easy to roll back.

## Workflow Rules
- Prefer small commits with clear messages.
- Export updated workflows to `workflows/active/` after any n8n change.
- Never commit secrets or private key material.
- Ask before running destructive commands.

## Project Conventions
- Branches should use `codex/<topic>`.
- Docs updates belong in `docs/`.
- Automation JSON files are source-controlled artifacts.

## Definition of Done
- Relevant workflow JSON exported and committed.
- Docs updated if behavior changed.
- Manual verification notes captured in commit or PR description.

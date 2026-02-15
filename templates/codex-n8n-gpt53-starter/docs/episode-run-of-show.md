# Episode Run-of-Show

## Segment 1: What We Are Building (2-3 min)
- Show final state: Codex + n8n + GitHub workflow.
- Explain value: chat with GPT-5.3 Codex to scaffold automation work safely.

## Segment 2: Codex App Context (1-2 min)
- Mention Codex is already installed for this walkthrough.
- Show workspace selection and project open.

## Segment 3: Project Scaffold (4-6 min)
- Tour folder structure.
- Explain why `docs/`, `workflows/`, `secrets/`, and `skills/` exist.

## Segment 4: Git + GitHub Connect (5-7 min)
- Create repo, push initial commit.
- Create `codex/<topic>` branch and explain PR process.

## Segment 5: Google Service Account + Drive Access (5-7 min)
- Show where JSON key lives (`secrets/`).
- Show Drive folder sharing with service account email.
- Explain least-privilege permissions.

## Segment 6: n8n Integration Basics (6-8 min)
- Export/import workflow JSON into `workflows/active/`.
- Explain credential handling and env separation.

## Segment 7: Gotchas (3-5 min)
- Secrets accidentally committed.
- Credential IDs mismatch between environments.
- Workflow JSON drift between n8n and git.

## Segment 8: Close + Next Episode (1-2 min)
- Recap operating model: Codex (builder), n8n (runner), GitHub (safety net).
- Tease follow-up: validation scripts and CI checks.

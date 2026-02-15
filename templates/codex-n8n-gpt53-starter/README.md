# Codex + n8n Automation Starter (GPT-5.3)

This template is for building and versioning n8n automations with Codex in a local project.

## What This Includes
- Clean project structure for `docs`, `workflows`, `scripts`, `secrets`, and `skills`
- Git + GitHub setup checklist
- Google Cloud service account setup notes for Drive access
- Episode run-of-show so you can record setup from start to finish

## Folder Layout
```text
codex-n8n-gpt53-starter/
├── AGENTS.md
├── .env.example
├── .gitignore
├── docs/
│   ├── episode-run-of-show.md
│   ├── github-setup.md
│   └── google-drive-service-account.md
├── scripts/
├── secrets/
├── skills/
└── workflows/
    ├── active/
    └── archive/
```

## Quick Start
1. Copy this folder to a new project name.
2. Initialize git and first commit:
   ```bash
   git init
   git add .
   git commit -m "chore: initialize codex+n8n starter"
   ```
3. Copy environment template:
   ```bash
   cp .env.example .env
   ```
4. Fill `.env` values for your n8n/API setup.
5. Open this folder in Codex and VS Code.
6. Follow docs:
   - `docs/github-setup.md`
   - `docs/google-drive-service-account.md`
   - `docs/episode-run-of-show.md`

## Conventions
- Keep active production workflows in `workflows/active/`.
- Move deprecated/old exports to `workflows/archive/`.
- Never commit raw secret files or private keys.
- Keep episode notes and architecture decisions in `docs/`.

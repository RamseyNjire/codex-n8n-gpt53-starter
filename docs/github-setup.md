# GitHub Setup Walkthrough

Use this section during the episode when connecting your local Codex project to GitHub.

## 1) Create Repo on GitHub
1. Create a new empty repository (no README or .gitignore auto-generated).
2. Copy the repo URL.

## 2) Initialize and Push Local Project
```bash
git init
git checkout -b main
git add .
git commit -m "chore: initial codex+n8n project scaffold"
git remote add origin <your-repo-url>
git push -u origin main
```

## 3) Daily Branch Flow
```bash
git checkout -b codex/<feature-name>
# make changes
git add .
git commit -m "feat(workflow): describe change"
git push -u origin codex/<feature-name>
```

Open a PR and review JSON workflow diffs before merge.

## Gotchas to Mention On Camera
- Forgetting `.gitignore` for `.env` and `secrets/`.
- Making edits directly on `main`.
- Not exporting workflow JSON after editing in n8n.

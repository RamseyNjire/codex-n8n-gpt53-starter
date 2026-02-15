# Google Drive Service Account Setup

Use this if your n8n workflows/scripts need Drive access through a Google service account.

## 1) Create Service Account (Google Cloud)
1. Open Google Cloud Console.
2. Select your project.
3. Go to IAM & Admin -> Service Accounts.
4. Create service account and grant only required roles.
5. Generate a JSON key and store it at:
   - `secrets/google-service-account.json`

## 2) Share Drive Assets With Service Account
1. Copy the service account email (ends with `iam.gserviceaccount.com`).
2. In Google Drive, share target folders/files with that email.
3. Give minimum required permission (Viewer/Editor).

## 3) Wire to Local Project
Set `.env` values:
```bash
GOOGLE_PROJECT_ID=your-project-id
GOOGLE_SERVICE_ACCOUNT_EMAIL=svc-name@project-id.iam.gserviceaccount.com
GOOGLE_APPLICATION_CREDENTIALS=./secrets/google-service-account.json
```

## 4) n8n Credential Note
If using Google credentials in n8n:
- Configure a Google credential using service account auth where supported.
- Keep credential IDs environment-specific (dev/prod often differ).

## Gotchas to Mention On Camera
- Service account has no access until you share the Drive folder explicitly.
- Wrong file path for `GOOGLE_APPLICATION_CREDENTIALS`.
- Overly broad IAM roles instead of least privilege.

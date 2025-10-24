GCP Hot-Cold DR Terraform Project (generated)
- Edit variables in variables.tf
- Place GitHub PAT into Secret Manager or set GitHub Actions secrets
- Use terraform init && terraform apply as appropriate

Cloud Function:
- Environment variables required for runtime:
  GITHUB_REPO (owner/repo)
  GITHUB_TOKEN (PAT or use Secret Manager with Terraform)

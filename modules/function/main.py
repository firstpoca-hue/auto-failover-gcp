import os
import base64
import json
import requests
 
def failover_trigger(event, context):
    # Read Pub/Sub message
    if 'data' in event:
        message = base64.b64decode(event['data']).decode('utf-8')
        print(f"Received alert message: {message}")
 
    # Environment variables (injected during deployment)
    github_repo = os.environ["GITHUB_REPO"]          # e.g. "your-org/failover-repo"
    github_token = os.environ["GITHUB_TOKEN_SECRET"] # GitHub PAT (stored in Secret Manager)
    workflow_file = os.environ.get("WORKFLOW_FILE", "failover.yml")
 
    # Trigger GitHub Actions workflow
    url = f"https://api.github.com/repos/{github_repo}/actions/workflows/{workflow_file}/dispatches"
    payload = {"ref": "main"}
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {github_token}"
    }
 
    response = requests.post(url, headers=headers, json=payload)
    print(f"GitHub Actions trigger response: {response.status_code} - {response.text}")
 
    return "Triggered failover workflow"
import os, json, requests

def trigger_failover(request):
    # Validate webhook token
    expected_token = os.getenv("WEBHOOK_TOKEN")
    auth_header = request.headers.get("Authorization", "")
    
    if expected_token and not auth_header.endswith(expected_token):
        print("Invalid webhook token")
        return ("Unauthorized", 401)
    
    try:
        payload = request.get_json() or {}
    except Exception:
        payload = {}
    
    repo = os.getenv("GITHUB_REPO")
    token = os.getenv("GH_PAT")
    
    if not repo or not token:
        print("GITHUB_REPO or GH_PAT not set")
        return ("missing config", 500)
    
    url = f"https://api.github.com/repos/{repo}/dispatches"
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}"
    }
    data = {
        "event_type": "failover_trigger",
        "client_payload": {"reason":"monitoring", "payload": str(payload)}
    }
    r = requests.post(url, headers=headers, json=data)
    print("GitHub response", r.status_code, r.text)
    return ("ok", 200)
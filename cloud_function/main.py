import base64, os, json, requests

def trigger_failover(event, context):
    try:
        payload = base64.b64decode(event['data']).decode('utf-8')
    except Exception:
        payload = "{}"
    
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
        "client_payload": {"reason":"monitoring", "payload": payload}
    }
    r = requests.post(url, headers=headers, json=data)
    print("GitHub response", r.status_code, r.text)
    return ("ok", 200)
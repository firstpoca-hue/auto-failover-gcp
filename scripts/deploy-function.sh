#!/bin/bash

PROJECT_ID="hot-cold-drp"
FUNCTION_NAME="failover-trigger"
REGION="us-central1"

echo "🚀 Deploying Cloud Function..."

gcloud functions deploy $FUNCTION_NAME \
  --runtime python39 \
  --trigger-topic monitoring-alerts \
  --source cloud_function/ \
  --entry-point trigger_failover \
  --set-env-vars GITHUB_REPO="your-org/your-repo" \
  --set-env-vars GH_PAT="$GH_PAT" \
  --region=$REGION \
  --project=$PROJECT_ID

echo "✅ Function deployed!"
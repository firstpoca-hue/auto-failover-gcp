#!/bin/bash

PROJECT_ID="hot-cold-drp"
BACKEND_SERVICE="app-lb-backend"

echo "🔄 Switching to maintenance page..."
gcloud compute network-endpoint-groups update maintenance-page-neg \
  --zone=us-central1-a \
  --add-endpoint="fqdn=storage.googleapis.com,port=443" \
  --project=$PROJECT_ID

gcloud compute backend-services add-backend $BACKEND_SERVICE \
  --network-endpoint-group=maintenance-page-neg \
  --network-endpoint-group-zone=us-central1-a \
  --balancing-mode=UTILIZATION \
  --max-utilization=1.0 \
  --global \
  --project=$PROJECT_ID

echo "⏳ Waiting 30 seconds for maintenance page..."
sleep 30

echo "🔄 Switching to secondary region..."
for zone in us-west1-a us-west1-b us-west1-c; do
  NEG_NAME="secondary-neg-${zone}"
  
  gcloud compute backend-services add-backend $BACKEND_SERVICE \
    --network-endpoint-group=$NEG_NAME \
    --network-endpoint-group-zone=$zone \
    --balancing-mode=UTILIZATION \
    --max-utilization=0.8 \
    --global \
    --project=$PROJECT_ID || true
done

echo "🗑️ Removing primary backends..."
for zone in us-central1-a us-central1-b us-central1-c; do
  NEG_NAME="primary-neg-${zone}"
  
  gcloud compute backend-services remove-backend $BACKEND_SERVICE \
    --network-endpoint-group=$NEG_NAME \
    --network-endpoint-group-zone=$zone \
    --global \
    --project=$PROJECT_ID || true
done

echo "🗑️ Removing maintenance page..."
gcloud compute backend-services remove-backend $BACKEND_SERVICE \
  --network-endpoint-group=maintenance-page-neg \
  --network-endpoint-group-zone=us-central1-a \
  --global \
  --project=$PROJECT_ID || true

echo "✅ Failover complete!"
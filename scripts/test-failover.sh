#!/bin/bash

PROJECT_ID="hot-cold-drp"

echo "🧪 Testing failover by simulating primary region failure..."

# Method 1: Scale down deployment to 0 replicas
echo "📉 Scaling down primary application..."
kubectl scale deployment web-app --replicas=0

echo "⏳ Waiting for health checks to fail (2-3 minutes)..."
echo "Monitor alerts at: https://console.cloud.google.com/monitoring/alerting"

# Method 2: Remove all endpoints from NEGs
echo "🔌 Removing endpoints from primary NEGs..."
for zone in us-central1-a us-central1-b us-central1-c; do
  NEG_NAME="primary-neg-${zone}"
  
  # List and remove all endpoints
  gcloud compute network-endpoint-groups list-network-endpoints $NEG_NAME \
    --zone=$zone --format="value(networkEndpoint.instance,networkEndpoint.ipAddress,networkEndpoint.port)" | \
  while IFS=$'\t' read -r instance ip port; do
    if [ -n "$ip" ]; then
      echo "Removing endpoint ${ip}:${port} from ${NEG_NAME}"
      gcloud compute network-endpoint-groups update $NEG_NAME \
        --zone=$zone \
        --remove-endpoint="instance=${instance},ip=${ip},port=${port}" \
        --project=$PROJECT_ID || true
    fi
  done
done

echo "🚨 Primary region is now unhealthy - alert should fire in 2-3 minutes"
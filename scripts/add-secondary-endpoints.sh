#!/bin/bash

PROJECT_ID="hot-cold-drp"
REGION="us-west1"

NODE_IPS=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')

for zone in us-west1-a us-west1-b us-west1-c; do
  NEG_NAME="secondary-neg-${zone}"
  
  for ip in $NODE_IPS; do
    NODE_ZONE=$(gcloud compute instances list --filter="networkInterfaces.networkIP:${ip}" --format="value(zone)" | head -1)
    
    if [[ "$NODE_ZONE" == *"$zone"* ]]; then
      echo "Adding endpoint ${ip}:30080 to NEG ${NEG_NAME}"
      gcloud compute network-endpoint-groups update $NEG_NAME \
        --zone=$zone \
        --add-endpoint="instance=,ip=${ip},port=30080" \
        --project=$PROJECT_ID || true
    fi
  done
done
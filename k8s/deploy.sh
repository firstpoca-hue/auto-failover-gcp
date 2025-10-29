#!/bin/bash

# Get GKE credentials
gcloud container clusters get-credentials gke-primary-cluster --region=us-central1 --project=hot-cold-drp

# Deploy application
kubectl apply -f app.yaml

# Deploy monitoring
kubectl apply -f monitoring.yaml

# Wait for services
echo "Waiting for services to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/web-app
kubectl wait --for=condition=available --timeout=300s deployment/prometheus -n monitoring
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n monitoring

# Get service IPs
echo "Application service:"
kubectl get service app-service

echo "Prometheus service:"
kubectl get service prometheus -n monitoring

echo "Grafana service:"
kubectl get service grafana -n monitoring

echo "Grafana login: admin/admin123"
############################
# Project & Regions
############################
project_id        = "hot-cold-drp"
primary_region    = "us-central1"
secondary_region  = "us-west1"
 
# Create secondary infra only during failover (set true in GH Actions failover job)
deploy_secondary  = false
 
############################
# Network
############################
network_name   = "dr-net"
primary_cidr   = "10.10.0.0/20"
secondary_cidr = "10.20.0.0/20"
psa_range_name    = "private-ip-address"
psa_prefix_length = 20

 
############################
# GKE
############################
primary_cluster_name    = "gke-primary"
secondary_cluster_name  = "gke-secondary"
 
# Node sizing (tune as needed)
primary_node_count      = 2
secondary_node_count    = 2
node_machine_type       = "e2-standard-2"
enable_private_nodes    = false
 
############################
# Load Balancer (HTTPS)
############################
lb_name            = "app-lb-backend"
health_check_path  = "/"
health_check_port = 80
 
# Using self-signed certs (files live in modules/lb/certs/)
use_managed_cert   = false
 
# NEG wiring (primary known at start, secondary populated on failover)
# Replace the <replace> parts after your Service with NEG annotation is deployed.
primary_neg_name   = "k8s1-<replace>-app-service-80"
primary_neg_zone   = "us-central1-a"
secondary_neg_name = "k8s1-<replace>-app-service-80"
secondary_neg_zone = "us-west1-a"
 
############################
# Database (Cloud SQL Postgres)
############################
name_prefix   = "DRP"
database_version      = "MYSQL_8_0"
db_tier          = "db-n1-standard-1"
db_storage_gb    = 50
enable_replica   = true 
db_name ="primary"
 # pre-create cross-region read replica
 
############################
# Monitoring & Alerts
############################
alert_policy_name            = "gke-failover-alert"
 
# If your monitoring module uses a webhook notification channel to the Cloud Function,
# set this token only if you configured "webhook_tokenauth" type.
cloud_function_auth_token    = "change-me-if-using-tokenauth"
 
# (Optional) If your monitoring module needs a direct Function URL instead of channel id.
# function_url                = "https://REGION-PROJECT.cloudfunctions.net/failover-trigger"
 
############################
# Cloud Function (Failover trigger → GitHub Actions)
############################
function_name       = "failover-trigger"
function_region     = "us-central1"
 
# GitHub Actions repository details (used by the Function to call repository_dispatch)
github_owner        = "firstpoca-hue"
github_repo         = "auto-failover-gcp"
github_event_type   = "failover_trigger"
 
# If your Function reads the PAT from Secret Manager, set this name; otherwise ignore.
github_pat_secret   = "github-pat"
 
# The branch/ref your workflow should run on
github_ref          = "refs/heads/main"
 
# Handy to pass secondary region to the workflow dispatch inputs
failover_secondary_region = "us-west1"
 
############################
# Artifact Registry (optional hints)
############################
# If you template AR names/locations in modules, set them here
artifact_registry_primary   = "ar-primary"
artifact_registry_secondary = "ar-secondary"
alert_email = "firstpoca@gmail.com"

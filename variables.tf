variable "project_id" { 
default = "hot-cold-drp" 
}
# variable "primary_region" {
# default = "us-central1" 
# }
# variable "secondary_region" {
#  default = "us-west1" 
#  }
variable "deploy_secondary" {
 type = bool
 default = false 
 }

variable "github_repo" { 
description = "owner/repo for actions"
default = "REPLACE_WITH_OWNER/REPO" 
}
variable "github_token_secret_name" {
default = "github-pat" 
}

variable "primary_region" {
  description = "Region for primary GKE cluster"
  type        = string
}

variable "secondary_region" {
  description = "Region for secondary GKE cluster"
  type        = string
}

variable "alert_email"{
  type = string
  default = "firstpoca@gmail.com"
}
variable "database_version" {
  type = string
  default = "MYSQL_8_0"
}

variable "db_tier" {
  type = string
  default = "db-n1-standard-1"
}

variable "lb_name" {
  type = string
  default = "app-lb-backend"
}

variable "github_pat_secret" {
  description = "Name of the secret in Secret Manager containing GitHub PAT"
  type = string
  default = "github-pat"
}

variable "psa_range_name" {
  type = string
  default = "servicenetworking-range"
}

variable "psa_prefix_length" {
  type = number
  default = 24
}

variable "name_prefix" {
  type = string
  default = "DRP"
}

variable "network_name" {
  type = string
  default = "dr-net"
}

variable "primary_cidr" {
  type = string
  default = "10.10.0.0/20"
}

variable "secondary_cidr" {
  type = string
  default = "10.20.0.0/20"
}

variable "primary_cluster_name" {
  type = string
  default = "gke-primary"
}

variable "secondary_cluster_name" {
  type = string
  default = "gke-secondary"
}

variable "primary_node_count" {
  type = number
  default = 2
}

variable "secondary_node_count" {
  type = number
  default = 2
}

variable "node_machine_type" {
  type = string
  default = "e2-standard-2"
}

variable "enable_private_nodes" {
  type = bool
  default = false
}

variable "use_managed_cert" {
  type = bool
  default = false
}

variable "primary_neg_name" {
  type = string
  default = "k8s1-default-app-service-80"
}

variable "primary_neg_zone" {
  type = string
  default = "us-central1-a"
}

variable "secondary_neg_name" {
  type = string
  default = "k8s1-default-app-service-80"
}

variable "secondary_neg_zone" {
  type = string
  default = "us-west1-a"
}

variable "db_storage_gb" {
  type = number
  default = 50
}

variable "enable_replica" {
  type = bool
  default = true
}

variable "db_name" {
  type = string
  default = "primary"
}

variable "alert_policy_name" {
  type = string
  default = "gke-failover-alert"
}

variable "cloud_function_auth_token" {
  type = string
  default = "change-me-if-using-tokenauth"
}

variable "function_name" {
  type = string
  default = "failover-trigger"
}

variable "function_region" {
  type = string
  default = "us-central1"
}

variable "github_owner" {
  type = string
  default = "your-org"
}

variable "github_repo" {
  type = string
  default = "your-repo"
}

variable "github_event_type" {
  type = string
  default = "failover_trigger"
}

variable "github_ref" {
  type = string
  default = "refs/heads/main"
}

variable "failover_secondary_region" {
  type = string
  default = "us-west1"
}

variable "artifact_registry_primary" {
  type = string
  default = "ar-primary"
}

variable "artifact_registry_secondary" {
  type = string
  default = "ar-secondary"
}

# variable "primary_neg" {
#   description = "Primary backend NEG for the load balancer"
# }

variable "health_check_path" {
  default = "/"
}

variable "health_check_port" {
  default = 80
}

# variable "primary_neg" {
#   description = "Primary backend NEG for the load balancer"
#   default     = "zones/${var.primary_neg_zone}/networkEndpointGroups/${var.primary_neg_name}"
# }

variable "db_name_prefix" {
  type = string
  default = "DRP"
}
# variable "network_name" {
#   description = "Name of the VPC network for Cloud SQL connectivity"
#   type        = string
# }


# NEW for PSA (Private Service Access)

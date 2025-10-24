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
variable"database_version"{

}
variable "db_tier" {
  
}
variable "lb_name" {
  default = "app-lb-backend"
}

variable "primary_neg" {
  description = "Primary backend NEG for the load balancer"
}

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

# 

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "region_secondary" {
  type = string
  default = ""   # optional if you want
}

variable "network_id" {
  type = string
}

variable "subnetwork_id" {
  type = string
}

variable "enabled" {
  description = "Whether to deploy the secondary GKE cluster"
  type        = bool
  default     = true
}
variable project_id{}
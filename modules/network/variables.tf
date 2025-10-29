variable "name" { default = "dr-net" }
variable "primary_region" {}
variable "secondary_region" {}
# NEW: required for Cloud SQL Private IP (PSA = Private Service Access)
variable "psa_range_name" {
  description = "Name of reserved range for Service Networking (VPC peering)"
  type        = string
}
variable "psa_prefix_length" {
  description = "Prefix length (e.g., 24 for /24) for the PSA reserved range"
  type        = number
}


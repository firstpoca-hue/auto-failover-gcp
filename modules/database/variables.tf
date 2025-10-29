# 

variable "project_id" {}
variable "name_prefix" {}
variable "network" {}
variable "enable_replica" {
type = bool
default = true
}

variable "primary_region" {}
variable "secondary_region" {}
variable "database_version" { # e.g., "POSTGRES_14" or "MYSQL_8_0"
  type = string
}

variable "db_tier" {}

variable "psa_range_name" {
  type = string
  default = "servicenetworking-range"
}
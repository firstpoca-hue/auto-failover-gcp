variable "project_id" {}
variable "name_prefix" {}
variable "region_primary" {}
variable "region_replica" {}
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
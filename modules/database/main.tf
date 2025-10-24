locals {
  primary_name = "${var.name_prefix}-primary"
  replica_name = "${var.name_prefix}-replica"
}

resource "google_sql_database_instance" "primary" {
  name             = "app-db-primary"
  project          = var.project_id
  region           = var.primary_region
  database_version = var.database_version

  settings {
    tier              = "db-custom-2-7680"
    availability_type = "REGIONAL"
  }
}

## Read replica (cross-region)
resource "google_sql_database_instance" "replica" {
  name             = "app-db-replica"
  project          = var.project_id
  region           = var.secondary_region
  database_version = var.database_version

  # IMPORTANT: point to the primary
  master_instance_name = "${var.project_id}:${google_sql_database_instance.primary.name}"
  # (Some provider versions call this field master_instance_name; it must reference the primary.)
}

# resource "google_sql_database_instance" "replica" {
#   count = var.enable_replica ? 1 : 0
#   name = local.replica_name
#   project = var.project_id
#   region = var.region_replica
#   master_instance_name = google_sql_database_instance.primary.name
#   settings { tier = "db-custom-1-3840" }
# }

output "primary_connection_name" { value = google_sql_database_instance.primary.connection_name }
output "replica_connection_name" { value = var.enable_replica ? google_sql_database_instance.replica[0].connection_name : null }

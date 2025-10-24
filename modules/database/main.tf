locals {
  primary_name = "${var.name_prefix}-primary"
  replica_name = "${var.name_prefix}-replica"
}

resource "google_sql_database_instance" "primary" {
  name             = "app-db-primary"
  project          = var.project_id
  region           = var.primary_region
  database_version = var.database_version
  deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    # 🟩 FIXED: Removed unsupported MySQL flag "log_bin"
    # database_flags {
    #   name  = "log_bin"
    #   value = "on"
    # }

    # 🟩 CORRECT: Enable binary logs properly for MySQL HA
    backup_configuration {
      enabled             = true
      binary_log_enabled  = true
    }
  }
}

resource "google_sql_database_instance" "replica" {
  name             = "app-db-replica"
  project          = var.project_id
  region           = var.secondary_region
  database_version = var.database_version
  deletion_protection = false

  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.db_tier
    # backup_configuration {
    #   enabled             = true
    #   binary_log_enabled  = true
    # }
  }
}

# Outputs remain unchanged
output "primary_connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "replica_connection_name" {
  value = var.enable_replica ? google_sql_database_instance.replica.connection_name : null
}

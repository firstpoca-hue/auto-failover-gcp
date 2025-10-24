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
    tier              = var.db_tier
    availability_type = "REGIONAL"

    # 🟩 FIXED: Correct flags for MySQL HA
    database_flags {
      name  = "log_bin"
      value = "on"
    }

    # 🟩 ADDED: Enable binary logging and HA explicitly for MySQL
    backup_configuration {
      enabled = true
      binary_log_enabled = true   # ✅ required for MySQL HA
    }
  }
}

resource "google_sql_database_instance" "replica" {
  name             = "app-db-replica"
  project          = var.project_id
  region           = var.secondary_region
  database_version = var.database_version

  master_instance_name = "${google_sql_database_instance.primary.name}"

  settings {
    tier = var.db_tier
  }
}

# Outputs remain same
output "primary_connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "replica_connection_name" {
  value = var.enable_replica ? google_sql_database_instance.replica.connection_name : null
}

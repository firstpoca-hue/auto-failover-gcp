locals {
  primary_name = "${var.name_prefix}-primary"
  replica_name = "${var.name_prefix}-replica"
}

data "google_compute_global_address" "private_ip_address" {
  name = var.psa_range_name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [data.google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "primary" {
  name             = "app-db-primary"
  project          = var.project_id
  region           = var.primary_region
  database_version = var.database_version
  deletion_protection = false
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }

    backup_configuration {
      enabled             = true
      binary_log_enabled  = true
    }
  }

  replica_configuration {
    failover_target = false
  }
}



output "primary_connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "primary_private_ip" {
  value = google_sql_database_instance.primary.private_ip_address
}



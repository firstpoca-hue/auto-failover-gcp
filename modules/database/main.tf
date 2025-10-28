# Private IP allocation for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

# Private service connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Random suffix for unique naming
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Primary database instance
resource "google_sql_database_instance" "primary" {
  name                = "primary-db-${random_id.db_name_suffix.hex}"
  database_version    = var.database_version
  region              = var.primary_region
  deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }

    backup_configuration {
      enabled            = false
      binary_log_enabled = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# Cross-region read replica
resource "google_sql_database_instance" "replica" {
  count                = var.enable_replica ? 1 : 0
  name                 = "replica-db-${random_id.db_name_suffix.hex}"
  database_version     = var.database_version
  region               = var.secondary_region
  deletion_protection  = false
  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.db_tier
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }
  }

  depends_on = [google_sql_database_instance.primary]
}

# Outputs
output "primary_connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "primary_private_ip" {
  value = google_sql_database_instance.primary.private_ip_address
}

output "replica_connection_name" {
  value = var.enable_replica ? google_sql_database_instance.replica[0].connection_name : null
}

output "replica_private_ip" {
  value = var.enable_replica ? google_sql_database_instance.replica[0].private_ip_address : null
}
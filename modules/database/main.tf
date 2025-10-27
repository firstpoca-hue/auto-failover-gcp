resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "primary" {
  name                = "appdbprimary${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region              = var.primary_region
  database_version    = var.database_version
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }

  replica_configuration {
    failover_target = false
  }
}

resource "google_sql_database_instance" "replica" {
  count                = var.enable_replica ? 1 : 0
  name                 = "appdbreplica${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region               = var.secondary_region
  database_version     = var.database_version
  deletion_protection  = false
  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.db_tier
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }
  }
}

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
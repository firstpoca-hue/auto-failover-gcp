resource "google_compute_network" "vpc" {
  name = "${var.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name = "${var.name}-subnet-primary"
  ip_cidr_range = "10.10.0.0/20"
  region = var.primary_region
  network = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "secondary" {
  name = "${var.name}-subnet-secondary"
  ip_cidr_range = "10.20.0.0/20"
  region = var.secondary_region
  network = google_compute_network.vpc.id
}

data "google_compute_zones" "available" {
  region = var.primary_region
}

# resource "google_compute_network_endpoint_group" "app_service_neg" {
#   for_each = toset(data.google_compute_zones.available.names)

#   name                  = "app-service-neg-${each.value}"
#   network               = google_compute_network.vpc.id     # pass from variables.tf or main.tf
#   subnetwork            = google_compute_subnetwork.primary.id 
#   zone                  = each.value  # pass from variables.tf or main.tf
#   default_port          = 80
#   network_endpoint_type = "GCE_VM_IP_PORT"   # or SERVERLESS

#   description = "App Service NEG for zone ${each.value}"
# }

 

resource "google_compute_global_address" "psa_range" {
  name          = var.psa_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_prefix_length
  network       = google_compute_network.vpc.self_link
}

# NEW: Establish Private Service Access peering (required for Cloud SQL Private IP)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range.name]
  # lifecycle {
  #   prevent_destroy = false
  # }
  
}

resource "google_compute_firewall" "allow_gke_to_sql" {
  name    = "allow-gke-to-sql"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.0.0/8"] # match your GKE subnet range
  target_tags   = ["cloudsql"]
}



output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "primary_subnet_id" {
  value = google_compute_subnetwork.primary.id
}

output "secondary_subnet_id" {
  value = google_compute_subnetwork.secondary.id
}

# output "neg" {
#   value = google_compute_network_endpoint_group.app_service_neg[each.Key].self_link
# }

# output "neg_self_links" {
#   value = {
#     for zone in data.google_compute_zones.available.names :
#     zone => google_compute_network_endpoint_group.app_service_neg[zone].self_link
#   }
# }

output "psa_connection_id" {
  value = google_service_networking_connection.private_vpc_connection.id
}

# output "psa_connection_name" {
#   value = google_service_networking_connection.private_vpc_connection.id
# }
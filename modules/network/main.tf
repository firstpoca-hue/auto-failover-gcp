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

data "google_compute_zones" "primary" {
  region = var.primary_region
}

data "google_compute_zones" "secondary" {
  region = var.secondary_region
}

resource "google_compute_network_endpoint_group" "primary_neg" {
  for_each = toset(data.google_compute_zones.primary.names)

  name                  = "primary-neg-${each.value}"
  network               = google_compute_network.vpc.id
  subnetwork            = google_compute_subnetwork.primary.id 
  zone                  = each.value
  default_port          = 30080
  network_endpoint_type = "GCE_VM_IP_PORT"
}

resource "google_compute_network_endpoint_group" "secondary_neg" {
  count = var.deploy_secondary ? length(data.google_compute_zones.secondary.names) : 0
  
  name                  = "secondary-neg-${data.google_compute_zones.secondary.names[count.index]}"
  network               = google_compute_network.vpc.id
  subnetwork            = google_compute_subnetwork.secondary.id
  zone                  = data.google_compute_zones.secondary.names[count.index]
  default_port          = 30080
  network_endpoint_type = "GCE_VM_IP_PORT"
}

# Maintenance page bucket NEG
# resource "google_compute_network_endpoint_group" "maintenance_neg" {
#   name                  = "maintenance-page-neg"
#   network               = google_compute_network.vpc.id
#   default_port          = 443
#   network_endpoint_type = "INTERNET_FQDN_PORT"
#   zone                  = data.google_compute_zones.primary.names[0]
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

output "primary_neg_self_links" {
  value = {
    for zone in data.google_compute_zones.primary.names :
    zone => google_compute_network_endpoint_group.primary_neg[zone].self_link
  }
}

output "secondary_neg_self_links" {
  value = var.deploy_secondary ? {
    for i, zone in data.google_compute_zones.secondary.names :
    zone => google_compute_network_endpoint_group.secondary_neg[i].self_link
  } : {}
}

output "maintenance_neg_self_link" {
  value = google_compute_network_endpoint_group.maintenance_neg.self_link
}

output "psa_connection_id" {
  value = google_service_networking_connection.private_vpc_connection.id
}

# output "psa_connection_name" {
#   value = google_service_networking_connection.private_vpc_connection.id
# }
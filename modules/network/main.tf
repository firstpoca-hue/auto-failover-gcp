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
# 🔹 Create cluster only if enabled == true
resource "google_container_cluster" "this" {
  count                     = var.enabled ? 1 : 0          # CHANGED
  name                      = "${var.name}-cluster"
  location                  = var.region
  network                   = var.network_id
  subnetwork                = var.subnetwork_id
  remove_default_node_pool  = true
  initial_node_count        = 1
  deletion_protection = false

  release_channel {
    channel = "REGULAR"
  }
   workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# 🔹 Node pool depends on the cluster
resource "google_container_node_pool" "nodes" {
  count    = var.enabled ? 1 : 0                           # CHANGED
  name     = "${var.name}-pool"
  cluster  = google_container_cluster.this[0].name
  location = var.region
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_type     = "pd-standard"     # ✅ Cheaper HDD
    disk_size_gb  = 50 
  }
}
resource "google_compute_firewall" "allow_gke_to_sql" {
  count    = var.enabled ? 1 : 0
  name    = "allow-gke-to-sql"
  network = var.network_id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.0.0/8"] # match your GKE subnet range
  target_tags   = ["cloudsql"]
}

# Output only if cluster is created

output "cluster_name" {
  value       = var.enabled ? google_container_cluster.this[0].name : null  # CHANGED
  description = "GKE cluster name"
}

output "neg_self_link" {
  value = var.enabled ? "projects/${var.project_id}/zones/${var.region}-a/networkEndpointGroups/app-service-neg" : null
  description = "Self link for the app service NEG"
}


output "gke_cluster_name" {
  value = google_container_cluster.this[0].name
}

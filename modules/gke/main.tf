resource "google_container_cluster" "this" {
  count = var.enabled ? 1 : 0
  name  = "${var.name}-cluster"
  location = var.region
  network = var.network_id
  subnetwork = var.subnetwork_id
  remove_default_node_pool = true
  initial_node_count = 1
  release_channel { 
  channel = "REGULAR" 
  }
}

resource "google_container_node_pool" "nodes" {
  count = var.enabled ? 1 : 0
  name = "${var.name}-pool"
  cluster = google_container_cluster.this[0].name
  location = var.region
  node_count = 2
  node_config {
   machine_type = "e2-medium" 
  }
}

# NOTE: Kubernetes NEG is created by a k8s Service with NEG annotation; this is a placeholder output
output "neg_self_link" {
  value = "/projects/${var.name}/regions/${var.region}/networkEndpointGroups/app-service-neg"
}

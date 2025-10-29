#Optional: GCS backend example (fill bucket to enable)
terraform {
  backend "gcs" {
    bucket = "hot-cold-drb"
    prefix = "gke-modular/state"
  }
}
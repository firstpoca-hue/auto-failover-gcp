terraform {
  required_providers {
    google = { source = "hashicorp/google", version = ">= 4.0" }
    random = { source = "hashicorp/random", version = ">= 3.1" }
  }
}
provider "google" {
  project = var.project_id
  region  = var.primary_region
}

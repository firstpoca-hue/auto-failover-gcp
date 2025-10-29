module "network" {
  source = "./modules/network"
  name = "dr-net"
  primary_region = var.primary_region
  secondary_region = var.secondary_region
  psa_range_name = var.psa_range_name
  psa_prefix_length = var.psa_prefix_length
}

# --- PRIMARY GKE CLUSTER (always created)
module "gke_primary" {
  source        = "./modules/gke"
  name          = "gke-primary"
  project_id    = var.project_id  
  region        = var.primary_region
  network_id    = module.network.vpc_id
  subnetwork_id = module.network.primary_subnet_id   # 🔹 FIXED: use primary subnet
  enabled       = true                               # 🔹 Explicitly set to always create
}

# --- SECONDARY GKE CLUSTER (only during failover)
# 🔹 Wrap the module in a conditional block using count
module "gke_secondary" {
  count         = var.deploy_secondary ? 1 : 0       # 🔹 <--- Key change: evaluated only if true
  source        = "./modules/gke"
  name          = "gke-secondary"
  project_id =    var.project_id
  region        = var.secondary_region
  network_id    = module.network.vpc_id
  subnetwork_id = module.network.secondary_subnet_id
  enabled       = var.deploy_secondary               # 🔹 Passed to module for internal control
}

module "database" {
  source           = "./modules/database"
  project_id       = var.project_id
  name_prefix      = var.name_prefix
  primary_region   = var.primary_region
  secondary_region = var.secondary_region
  database_version = var.database_version
  network          = module.network.vpc_id
  enable_replica   = true
  db_tier          = var.db_tier
  psa_range_name   = var.psa_range_name
}

module "lb" {
  source = "./modules/lb"
  name    = "app-lb"
  backends = []

  lb_name            = var.lb_name
  #neg                = module.network.neg_self_links           # 🔹 Get NEG self-link from network module
  health_check_path  = var.health_check_path
  health_check_port  = var.health_check_port
  depends_on = [module.gke_primary]
  region = var.primary_region
}
    # primary backend NEG filled after k8s NEG exists; failover run will add secondary


module "artifact_registry" {
  source = "./modules/artifact-registry"
  project_id = var.project_id
  region = var.primary_region
}

module "monitoring" {
  source = "./modules/monitoring"
  project_id = var.project_id
  alert_email = var.alert_email
}

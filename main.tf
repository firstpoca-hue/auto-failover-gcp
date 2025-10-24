module "network" {
  source = "./modules/network"
  name = "dr-net"
  primary_region = var.primary_region
  secondary_region = var.secondary_region
}

# --- PRIMARY GKE CLUSTER (always created)
module "gke_primary" {
  source        = "./modules/gke"
  name          = "gke-primary"
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
  region        = var.secondary_region
  network_id    = module.network.vpc_id
  subnetwork_id = module.network.secondary_subnet_id
  enabled       = var.deploy_secondary               # 🔹 Passed to module for internal control
}

# module "database" {
#   source = "./modules/database"
#   project_id = var.project_id
#   name_prefix = "app"
#   region_primary = var.primary_region
#   region_replica = var.secondary_region
#   network = module.network.vpc_id
#   enable_replica = true
# }

# module "lb" {
#   source = "./modules/lb"
#   name = "app-lb"
#   backends = [] # primary backend NEG filled after k8s NEG exists; failover run will add secondary
# }

# module "monitoring" {
#   source = "./modules/monitoring"
#   project_id = var.project_id
#   alert_name = var.alert_email
# }

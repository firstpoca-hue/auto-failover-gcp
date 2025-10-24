module "network" {
  source = "./modules/network"
  name = "dr-net"
  primary_region = var.primary_region
  secondary_region = var.secondary_region
}

# module "gke_primary" {
#   source        = "./modules/gke"
#   name          = "gke-primary"
#   region        = var.primary_region
#   region_secondary = var.secondary_region
#   network_id    = module.network.vpc_id
#   subnetwork_id = module.network.secondary_subnet_id
# }


# module "gke_secondary" {
#   source        = "./modules/gke"
#   name          = "secondary"
#   region        = var.secondary_region
#   network_id    = module.network.vpc_id
#   subnetwork_id = module.network.secondary_subnet_id
#   enabled       = var.deploy_secondary
# }
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

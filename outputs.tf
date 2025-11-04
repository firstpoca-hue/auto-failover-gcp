##Network Module Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_self_link" {
  value = module.network.vpc_self_link
}

output "primary_subnet_id" {
  value = module.network.primary_subnet_id
}

output "secondary_subnet_id" {
  value = module.network.secondary_subnet_id
}

output "psa_connection_id" {
  value = module.network
}

##GKE Module Outputs
output "gke_cluster_name" {
    value = module.gke_primary.cluster_name
}

output "neg_self_link" {
    value = module.gke_primary.neg_self_link
}

##Database Module Outputs
output "primary_connection_name" {
  value = module.database.primary_connection_name
}

output "primary_private_ip" {
  value = module.database.primary_private_ip
}

output "replica_connection_name" {
  value = module.database.replica_connection_name
}

output "replica_private_ip" {
  value = module.database.replica_private_ip
}
output "sql_private_ip" {
  value = module.database.sql_private_ip
}

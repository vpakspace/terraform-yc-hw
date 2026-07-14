output "cluster_id" {
  description = "ID кластера example"
  value       = module.mysql_cluster.cluster_id
}

output "host_count" {
  description = "Число хостов (1 при HA=false, 2 при HA=true)"
  value       = module.mysql_cluster.host_count
}

output "host_fqdns" {
  description = "FQDN хостов кластера"
  value       = module.mysql_cluster.host_fqdns
}

output "database" {
  description = "Созданная БД и пользователь"
  value = {
    name = module.mysql_database.database_name
    user = module.mysql_database.username
  }
}

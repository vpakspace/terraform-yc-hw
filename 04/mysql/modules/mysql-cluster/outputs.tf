output "cluster_id" {
  description = "ID кластера Managed MySQL — для передачи в модуль mysql-database"
  value       = yandex_mdb_mysql_cluster.this.id
}

output "cluster_name" {
  description = "Имя кластера"
  value       = yandex_mdb_mysql_cluster.this.name
}

output "host_count" {
  description = "Число хостов в кластере"
  value       = length(yandex_mdb_mysql_cluster.this.host)
}

output "host_fqdns" {
  description = "FQDN хостов кластера"
  value       = yandex_mdb_mysql_cluster.this.host[*].fqdn
}

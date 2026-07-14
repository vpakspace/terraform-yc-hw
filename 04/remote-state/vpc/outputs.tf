# Эти outputs читает второй root-модуль (vm) через data "terraform_remote_state".
output "network_id" {
  description = "ID сети"
  value       = module.vpc.network_id
}

output "subnet_ids" {
  description = "ID подсетей по зонам"
  value       = module.vpc.subnet_ids
}

output "subnet_zones" {
  description = "Список зон подсетей"
  value       = module.vpc.subnet_zones
}

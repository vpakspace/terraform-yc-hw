# Задание 1: сводка по ВМ (внешний IP для ssh + метки проектов).
output "marketing_vm" {
  description = "ВМ проекта marketing: внешний IP, fqdn, метки"
  value = {
    external_ip = module.marketing_vm.external_ip_address
    fqdn        = module.marketing_vm.fqdn
    labels      = module.marketing_vm.labels
  }
}

output "analytics_vm" {
  description = "ВМ проекта analytics: внешний IP, fqdn, метки"
  value = {
    external_ip = module.analytics_vm.external_ip_address
    fqdn        = module.analytics_vm.fqdn
    labels      = module.analytics_vm.labels
  }
}

# Задание 2: подсети develop-сети, возвращённые vpc-модулем.
output "develop_subnet_ids" {
  description = "ID подсетей develop-сети (из vpc-модуля)"
  value       = module.vpc.subnet_ids
}

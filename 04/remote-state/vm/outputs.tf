output "vm_external_ip" {
  description = "Внешний IP созданной ВМ"
  value       = module.vm.external_ip_address
}

output "vm_fqdn" {
  description = "FQDN созданной ВМ"
  value       = module.vm.fqdn
}

output "used_network_id" {
  description = "ID сети, прочитанный из remote state модуля vpc"
  value       = data.terraform_remote_state.vpc.outputs.network_id
}

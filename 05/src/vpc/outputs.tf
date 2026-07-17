# Задание 2: модуль возвращает в root-модуль информацию о yandex_vpc_subnet.
output "subnets" {
  description = "Полные объекты созданных подсетей (yandex_vpc_subnet) по зонам"
  value       = yandex_vpc_subnet.this
}

output "network_id" {
  description = "ID созданной облачной сети"
  value       = yandex_vpc_network.this.id
}

output "network_name" {
  description = "Имя созданной облачной сети"
  value       = yandex_vpc_network.this.name
}

# Для передачи в модуль ВМ: { zone = subnet_id }.
output "subnet_ids" {
  description = "ID подсетей по зонам"
  value       = { for zone, subnet in yandex_vpc_subnet.this : zone => subnet.id }
}

output "subnet_zones" {
  description = "Список зон, в которых созданы подсети"
  value       = keys(yandex_vpc_subnet.this)
}

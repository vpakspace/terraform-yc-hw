# Задание 4 — ОДИН output с instance_name, external_ip и fqdn для каждой ВМ.
# Значения берутся из атрибутов ресурсов (без хардкода).
output "vms_info" {
  description = "Имя, внешний IP и FQDN каждой ВМ"
  value = {
    web = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.fqdn
    }
    db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform_db.fqdn
    }
  }
}

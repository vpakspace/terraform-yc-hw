locals {
  # HA=true → 2 хоста, HA=false → 1 хост (задание 5.1).
  host_count = var.ha ? 2 : 1
  host_zones = slice(var.zones, 0, local.host_count)
}

resource "yandex_mdb_mysql_cluster" "this" {
  name        = var.name
  environment = var.environment
  network_id  = var.network_id
  version     = var.mysql_version

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type_id
    disk_size          = var.disk_size
  }

  # Один host-блок на зону: при HA=false — один хост, при HA=true — два в разных зонах.
  dynamic "host" {
    for_each = local.host_zones
    content {
      zone      = host.value
      subnet_id = var.subnet_ids[host.value]
    }
  }
}

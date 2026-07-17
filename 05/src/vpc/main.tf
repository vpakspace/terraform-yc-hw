locals {
  # Задание 2 (zone + cidr) и задание 4* (subnets = list(object)) в одном модуле:
  # если задан список subnets — берём его, иначе собираем одну подсеть из zone + cidr.
  subnets = var.subnets != null ? var.subnets : [
    { zone = var.zone, cidr = var.cidr }
  ]
}

# Одна облачная сеть на каждый вызов модуля.
resource "yandex_vpc_network" "this" {
  name = var.env_name

  lifecycle {
    precondition {
      condition     = var.subnets != null || (var.zone != null && var.cidr != null)
      error_message = "Задайте либо subnets (список объектов), либо пару zone + cidr."
    }
  }
}

# Подсети: одна (задание 2) или по одной в каждой зоне (задание 4*). Ключ for_each — зона.
resource "yandex_vpc_subnet" "this" {
  for_each = { for s in local.subnets : s.zone => s }

  name           = "${var.env_name}-${each.value.zone}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [each.value.cidr]
}

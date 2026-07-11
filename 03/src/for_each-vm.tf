########################################################################
#  Задание 2.2: две РАЗНЫЕ ВМ баз данных (main, replica) через for_each.
#  - Общая переменная var.each_vm типа list(object(...)).
#  - list -> map по имени ВМ, чтобы for_each принял стабильные ключи.
#  - main и replica различаются по cpu/ram/disk_volume.
########################################################################

resource "yandex_compute_instance" "db" {
  # list(object) -> map(vm_name => object): ключи main/replica вместо индексов
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name                      = each.value.vm_name
  hostname                  = each.value.vm_name
  platform_id               = var.vm_platform_id
  zone                      = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.db_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.enable_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vm_metadata
}

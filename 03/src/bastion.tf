########################################################################
#  Задание 6*: bastion-хост (jump-host).
#  Создаётся только при enable_bastion=true. Всегда имеет внешний IP,
#  через него ansible достаёт целевые ВМ, у которых nat=false.
########################################################################

resource "yandex_compute_instance" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                      = "bastion"
  hostname                  = "bastion"
  platform_id               = var.vm_platform_id
  zone                      = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = var.bastion_vm.cpu
    memory        = var.bastion_vm.ram
    core_fraction = var.bastion_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.bastion_vm.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true # bastion всегда доступен извне
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vm_metadata
}

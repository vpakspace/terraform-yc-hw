########################################################################
#  Задание 2.1: две ОДИНАКОВЫЕ web-ВМ (web-1, web-2) через count.
#  - Имя web-${count.index + 1} => web-1, web-2 (а не web-0/web-1).
#  - Назначена группа безопасности из Задания 1 (yandex_vpc_security_group.example).
#  - Задание 2.3: создаются ПОСЛЕ ВМ баз данных (depends_on).
########################################################################

resource "yandex_compute_instance" "web" {
  count = var.web_vm_count

  # Задание 2.3: web-ВМ создаются после ВМ из for_each-vm.tf
  depends_on = [yandex_compute_instance.db]

  name                      = "web-${count.index + 1}"
  hostname                  = "web-${count.index + 1}"
  platform_id               = var.vm_platform_id
  zone                      = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = var.web_vm.cpu
    memory        = var.web_vm.ram
    core_fraction = var.web_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.web_vm.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.enable_nat
    # Задание 2.1: группа безопасности из Задания 1
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  # Задание 2.4: metadata с ssh-ключом, считанным через file() (см. locals.tf)
  metadata = local.vm_metadata
}

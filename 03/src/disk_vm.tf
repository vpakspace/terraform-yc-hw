########################################################################
#  Задание 3: три одинаковых диска (count) + одиночная ВМ storage,
#  к которой они подключаются через dynamic secondary_disk (for_each).
########################################################################

# Задание 3.1: 3 одинаковых диска по 1 ГБ через count
resource "yandex_compute_disk" "storage" {
  count = var.storage_disk_count

  name = "storage-disk-${count.index + 1}"
  size = var.storage_disk_size
  zone = var.default_zone
  type = "network-hdd"
}

# Задание 3.2: ОДИНОЧНАЯ ВМ storage (без count/for_each — запрещено заданием №4),
# дополнительные диски подключаются блоком dynamic secondary_disk.
resource "yandex_compute_instance" "storage" {
  name                      = "storage"
  hostname                  = "storage"
  platform_id               = var.vm_platform_id
  zone                      = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = var.storage_vm.cpu
    memory        = var.storage_vm.ram
    core_fraction = var.storage_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.storage_vm.disk_volume
    }
  }

  # Динамическое подключение всех дисков из yandex_compute_disk.storage
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage
    content {
      disk_id = secondary_disk.value.id
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

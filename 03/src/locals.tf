locals {
  # Задание 2.4: публичный ssh-ключ считывается функцией file() в local-переменной
  # и далее подставляется в metadata всех ВМ (без хардкода самого ключа).
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))

  # Общий metadata для всех ВМ проекта (serial-console + ssh-ключ пользователя ubuntu).
  vm_metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}

########################################################################
#  Задание 4: динамический ansible inventory через templatefile.
#  Передаём 5 ВМ тремя группами (web / databases / storage) + bastion.
#  Задание 6*: применение playbook через null_resource + local-exec.
########################################################################

resource "local_file" "inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web        # Задание 2.1 (count -> list)
    databases  = values(yandex_compute_instance.db) # Задание 2.2 (for_each -> map -> list)
    storage    = [yandex_compute_instance.storage]  # Задание 3.2 (одиночная -> list)
    bastion    = yandex_compute_instance.bastion    # Задание 6* (count -> list 0/1)
  })
  filename        = "${path.module}/hosts.ini"
  file_permission = "0644"
}

# Задание 6*: применяем ansible-playbook к ВМ из inventory-файла.
resource "null_resource" "web_provision" {
  count = var.web_provision ? 1 : 0

  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage,
    yandex_compute_instance.bastion,
    local_file.inventory,
  ]

  # Один shell: поднимаем ssh-agent, добавляем ключ (нужен и для ProxyCommand
  # через bastion, и для доступа к целевым ВМ) и запускаем playbook.
  provisioner "local-exec" {
    command     = <<-EOT
      eval $(ssh-agent -s)
      ssh-add ${pathexpand(var.ssh_private_key_path)}
      ansible-playbook -i ${abspath("${path.module}/hosts.ini")} ${abspath("${path.module}/test.yml")}
    EOT
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    on_failure  = continue
  }

  # Пересоздание при изменении inventory (аналог triggers из демонстрации)
  triggers = {
    inventory_content = local_file.inventory.content
  }
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    # null_resource — для задания 6 (local-exec запуск ansible)
    null = {
      source = "hashicorp/null"
    }
    # local_file — для задания 4 (генерация ansible inventory)
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = "~>1.12.0"
}

provider "yandex" {
  # Аутентификация через ключ сервисного аккаунта: не истекает, в отличие от OAuth-токена.
  # Файл ~/.authorized_key.json в .gitignore — в репозиторий не попадает.
  # Альтернатива — OAuth-токен: token = var.token (тогда вернуть переменную token в variables.tf).
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}

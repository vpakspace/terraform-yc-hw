terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    # template — для data "template_file" (задание 1: рендер cloud-init с ssh-ключом
    # через блок vars). Провайдер архивный (deprecated), но на linux_amd64 работает;
    # версия 2.2.0 тянется из зеркала Yandex. Именно про MacOS в ДЗ сказано, что там
    # будет "Incompatible provider version" — на Linux этой проблемы нет.
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
  required_version = "~>1.12.0"
}

provider "yandex" {
  # Аутентификация ключом сервисного аккаунта: не истекает, в отличие от OAuth-токена.
  # Файл ~/.authorized_key.json в .gitignore — в репозиторий не попадает.
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}

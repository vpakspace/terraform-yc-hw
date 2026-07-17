terraform {
  required_version = "~>1.12.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.215"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }

  # backend не задан намеренно: это bootstrap-модуль, который сам создаёт бакет
  # для remote state. Хранить его состояние в бакете, которого ещё нет, нельзя —
  # классическая проблема курицы и яйца. Поэтому state здесь остаётся локальным.
}

provider "yandex" {
  service_account_key_file = file(var.sa_key_file)
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}

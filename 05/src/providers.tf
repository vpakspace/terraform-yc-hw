terraform {
  # ───────────────────────────────────────────────────────────────────────────
  # Задание 2: remote state в Object Storage со встроенными блокировками.
  # Значения взяты из output `backend_config_example` модуля 05/backend-infra
  # (задание 7*). Переменные здесь использовать нельзя: блок backend читается
  # до инициализации graph'а, поэтому named values (var/local/data) в нём
  # запрещены — имя бакета и ключ могут быть только литералами либо приходить
  # из -backend-config. Секретов тут нет: access/secret key backend берёт из
  # переменных окружения AWS_* или из ~/.aws/credentials.
  # ───────────────────────────────────────────────────────────────────────────
  backend "s3" {
    bucket = "netology-tfstate-ykcc53e2"
    key    = "terraform-05/terraform.tfstate"
    region = "ru-central1"

    # Встроенный механизм блокировок (Terraform >= 1.6): рядом со state
    # создаётся lock-файл, отдельная YDB/DynamoDB не нужна.
    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    # Object Storage — S3-совместимое, но не AWS: проверки регионов,
    # аккаунта и контрольных сумм AWS-специфичны и отключаются.
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      # Без ограничения версии сборка невоспроизводима: приедет любая версия,
      # вплоть до мажорной с ломающими изменениями (tflint: terraform_required_providers).
      version = "~> 0.217"
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
  # Путь вынесен в переменную: локально это ~/.authorized_key.json (файл в .gitignore
  # и в репозиторий не попадает), а в CI/CD (задание 6*) раннер кладёт ключ из секрета
  # по своему пути и передаёт его через TF_VAR_sa_key_file.
  service_account_key_file = file(var.sa_key_file)
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}

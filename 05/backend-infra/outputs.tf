output "bucket_name" {
  description = "Имя бакета для хранения tfstate"
  value       = yandex_storage_bucket.tfstate.bucket
}

output "access_key_id" {
  description = "Access key ID сервисного аккаунта для backend S3"
  value       = yandex_iam_service_account_static_access_key.tfstate.access_key
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret key сервисного аккаунта для backend S3"
  value       = yandex_iam_service_account_static_access_key.tfstate.secret_key
  sensitive   = true
}

# Готовый к копированию блок backend для основного проекта (05/src/providers.tf).
# Ключи в него не подставляются намеренно: секретам не место в репозитории —
# backend читает их из переменных окружения AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
# либо из ~/.aws/credentials.
output "backend_config_example" {
  description = "Пример конфигурации backend для основного проекта"
  value       = <<-EOT
    terraform {
      required_version = "~>1.12.0"

      backend "s3" {
        bucket = "${yandex_storage_bucket.tfstate.bucket}"
        key    = "${var.state_key}"
        region = "${var.region}"

        # Встроенный механизм блокировок (Terraform >= 1.6): lock-файл
        # ${var.state_key}.tflock создаётся в этом же бакете, YDB не нужна.
        use_lockfile = true

        endpoints = {
          s3 = "${var.s3_endpoint}"
        }

        skip_region_validation      = true
        skip_credentials_validation = true
        skip_requesting_account_id  = true
        skip_s3_checksum            = true
      }
    }
  EOT
}

# Строки для ~/.aws/credentials — секреты выводятся только по явному
# terraform output -raw, в логи apply не попадают.
output "aws_credentials_file_example" {
  description = "Содержимое ~/.aws/credentials для локальной работы с backend"
  value       = <<-EOT
    [default]
    aws_access_key_id = ${yandex_iam_service_account_static_access_key.tfstate.access_key}
    aws_secret_access_key = ${yandex_iam_service_account_static_access_key.tfstate.secret_key}
  EOT
  sensitive   = true
}

terraform {
  required_version = "~>1.12.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "> 0.9"
    }
    # Модуль terraform-yc-s3 объявляет aws-провайдер (S3-совместимый API).
    # Реальные операции идут по IAM Yandex; ключи здесь — заглушки, как в примере simple-bucket.
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 3.5"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

# В каждом модуле — свой required_providers, иначе Terraform пытается резолвить
# hashicorp/yandex вместо yandex-cloud/yandex.
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12.0"
}

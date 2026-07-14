# Уникальный суффикс — имена бакетов в YC глобально уникальны.
resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Задание 6*: готовый модуль terraform-yc-s3 (пример examples/simple-bucket).
# Бакет создаётся по IAM провайдера (SA terraform), без статического ключа.
# max_size = 1 ГБ — в пределах бесплатного объёма; бакет НЕ удаляем (нужен для ДЗ к лекции 5).
module "s3" {
  source = "github.com/terraform-yc-modules/terraform-yc-s3"

  bucket_name = "netology-tf-04-${random_string.unique_id.result}"
  max_size    = 1073741824 # 1 ГБ (1 * 1024^3 байт)

  # versioning/ACL/policy требуют S3 API со статическим ключом и ролью storage.admin.
  # Для минимального бесплатного бакета обходимся созданием по IAM-токену провайдера.
}

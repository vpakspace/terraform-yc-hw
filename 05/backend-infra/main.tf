# ─────────────────────────────────────────────────────────────────────────────
# Задание 7*: отдельный root-модуль, создающий инфраструктуру для remote state:
#   1) сервисный аккаунт с ролью storage.editor — под ним работает backend,
#   2) статический access key для него (S3 API не принимает IAM-токен),
#   3) бакет для tfstate с версионированием.
# Отдельная база для блокировок (YDB/DynamoDB) не нужна: backend работает
# с use_lockfile = true — lock-файл лежит в этом же бакете рядом со state.
#
# Почему сервисных аккаунта два. storage.editor даёт права на объекты (Get/Put/
# Delete — этого хватает и для tfstate, и для lock-файла), но включить
# версионирование им нельзя: PutBucketVersioning — операция над самим бакетом,
# она требует storage.admin (проверено: иначе AccessDenied, 403). Раздавать
# рабочему аккаунту админские права ради разовой настройки неправильно, поэтому
# бакет создаёт и настраивает отдельный admin-аккаунт, а наружу в backend
# отдаётся ключ аккаунта с минимально необходимым storage.editor.
# ─────────────────────────────────────────────────────────────────────────────

# Имена бакетов в Object Storage уникальны глобально, поэтому к префиксу
# добавляется случайный суффикс.
resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# ─── Аккаунт-администратор бакета (используется только при создании) ─────────
resource "yandex_iam_service_account" "bucket_admin" {
  name        = var.admin_sa_name
  folder_id   = var.folder_id
  description = "Создание и настройка бакета с remote state (ДЗ 05)"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket_admin" {
  folder_id = var.folder_id
  role      = var.admin_sa_role
  member    = "serviceAccount:${yandex_iam_service_account.bucket_admin.id}"
}

resource "yandex_iam_service_account_static_access_key" "bucket_admin" {
  service_account_id = yandex_iam_service_account.bucket_admin.id
  description        = "Ключ для создания бакета и включения версионирования (ДЗ 05)"
}

# ─── Рабочий аккаунт backend: только чтение/запись объектов ──────────────────
resource "yandex_iam_service_account" "tfstate" {
  name        = var.sa_name
  folder_id   = var.folder_id
  description = "Доступ Terraform к бакету с remote state (ДЗ 05)"
}

# Права на чтение/запись объектов бакета: и сам tfstate, и lock-файл.
resource "yandex_resourcemanager_folder_iam_member" "tfstate" {
  folder_id = var.folder_id
  role      = var.sa_role
  member    = "serviceAccount:${yandex_iam_service_account.tfstate.id}"
}

# Статический ключ: backend "s3" аутентифицируется по протоколу AWS S3,
# IAM-токен Yandex Cloud он не понимает.
resource "yandex_iam_service_account_static_access_key" "tfstate" {
  service_account_id = yandex_iam_service_account.tfstate.id
  description        = "Static access key для backend S3 (ДЗ 05)"
}

# ─── Шифрование ─────────────────────────────────────────────────────────────
# checkov CKV_YC_3 «Ensure storage bucket is encrypted»: state — это слепок всей
# инфраструктуры, включая чувствительные значения, поэтому в бакете он должен
# лежать зашифрованным. Object Storage шифрует объекты ключом KMS.
resource "yandex_kms_symmetric_key" "tfstate" {
  name              = var.kms_key_name
  folder_id         = var.folder_id
  description       = "Шифрование бакета с remote state (ДЗ 05)"
  default_algorithm = var.kms_algorithm
  rotation_period   = var.kms_rotation_period
}

# Оба аккаунта должны уметь шифровать/расшифровывать: admin — чтобы настроить
# бакет, editor — чтобы backend мог читать и писать state и lock-файл.
resource "yandex_kms_symmetric_key_iam_member" "bucket_admin" {
  symmetric_key_id = yandex_kms_symmetric_key.tfstate.id
  role             = var.kms_role
  member           = "serviceAccount:${yandex_iam_service_account.bucket_admin.id}"
}

resource "yandex_kms_symmetric_key_iam_member" "tfstate" {
  symmetric_key_id = yandex_kms_symmetric_key.tfstate.id
  role             = var.kms_role
  member           = "serviceAccount:${yandex_iam_service_account.tfstate.id}"
}

# ─── Бакет ──────────────────────────────────────────────────────────────────
# Роли выдаются асинхронно: без паузы создание бакета ключом SA падает
# с AccessDenied — ключ уже есть, а права ещё не распространились.
resource "time_sleep" "wait_for_iam" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.bucket_admin,
    yandex_resourcemanager_folder_iam_member.tfstate,
    yandex_kms_symmetric_key_iam_member.bucket_admin,
    yandex_kms_symmetric_key_iam_member.tfstate,
  ]
  create_duration = var.iam_propagation_delay
}

resource "yandex_storage_bucket" "tfstate" {
  access_key = yandex_iam_service_account_static_access_key.bucket_admin.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket_admin.secret_key

  bucket   = "${var.bucket_prefix}-${random_string.unique_id.result}"
  max_size = var.bucket_max_size

  # История версий state: позволяет откатиться, если состояние испортили.
  versioning {
    enabled = true
  }

  # Шифрование объектов ключом KMS (checkov CKV_YC_3).
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tfstate.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [time_sleep.wait_for_iam]
}

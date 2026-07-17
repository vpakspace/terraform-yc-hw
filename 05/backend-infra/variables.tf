###cloud vars
variable "cloud_id" {
  type        = string
  description = "ID облака Yandex Cloud"
}

variable "folder_id" {
  type        = string
  description = "ID каталога Yandex Cloud"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона доступности по умолчанию"
}

variable "sa_key_file" {
  type        = string
  default     = "~/.authorized_key.json"
  description = "Путь к файлу авторизованного ключа сервисного аккаунта, от имени которого работает провайдер"
}

###backend infra vars
variable "sa_name" {
  type        = string
  default     = "tfstate-editor"
  description = "Имя сервисного аккаунта, которому выдаётся доступ к бакету с remote state"
}

variable "sa_role" {
  type        = string
  default     = "storage.editor"
  description = "Роль сервисного аккаунта: чтение/запись объектов бакета (tfstate + lock-файл)"
}

variable "admin_sa_name" {
  type        = string
  default     = "tfstate-admin"
  description = "Имя сервисного аккаунта, создающего бакет и включающего версионирование"
}

variable "admin_sa_role" {
  type        = string
  default     = "storage.admin"
  description = "Роль администратора бакета: PutBucketVersioning недоступна для storage.editor"
}

variable "iam_propagation_delay" {
  type        = string
  default     = "15s"
  description = "Пауза на распространение выданных ролей перед обращением к S3 API"
}

variable "bucket_prefix" {
  type        = string
  default     = "netology-tfstate"
  description = "Префикс имени бакета; к нему добавляется случайный суффикс, т.к. имена бакетов уникальны глобально"
}

variable "bucket_max_size" {
  type        = number
  default     = 1073741824 # 1 * 1024^3 = 1 ГБ
  description = "Максимальный размер бакета в байтах (ограничение для экономии)"
}

variable "state_key" {
  type        = string
  default     = "terraform-05/terraform.tfstate"
  description = "Ключ (путь) state-файла внутри бакета — попадает в пример конфигурации backend"
}

variable "region" {
  type        = string
  default     = "ru-central1"
  description = "Регион S3-совместимого хранилища Yandex Cloud"
}

variable "s3_endpoint" {
  type        = string
  default     = "https://storage.yandexcloud.net"
  description = "Endpoint S3-совместимого API Yandex Cloud"
}

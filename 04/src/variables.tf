###cloud vars
# Аутентификация — через ключ сервисного аккаунта (см. providers.tf), поэтому переменная token не нужна.

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона по умолчанию для провайдера и для develop-подсети (задание 2)"
}

variable "default_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR develop-подсети (задание 2, скалярный интерфейс vpc-модуля)"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "Имя develop-сети/окружения (env_name для vpc-модуля)"
}

###common vars

variable "public_key" {
  type        = string
  description = "Публичный ssh-ключ для пользователя ubuntu (подставляется в cloud-init через template_file). Значение — в personal.auto.tfvars, без хардкода в коде."
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС для ВМ (без хардкода image_id)"
}

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
  description = "Зона по умолчанию для провайдера"
}

variable "ha" {
  type        = bool
  default     = false
  description = "Задание 5.3: false → кластер example из 1 хоста; true → 2 хоста. Переключается для scale-up."
}

variable "resource_preset_id" {
  type        = string
  default     = "b1.medium"
  description = "Класс хостов MySQL. b1.medium — минимальный burstable (2 ядра / 4 ГБ, зоны a, b)."
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Пароль пользователя app (мин. 8 символов). Значение — в personal.auto.tfvars."
}

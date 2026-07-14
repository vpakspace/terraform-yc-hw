variable "name" {
  type        = string
  description = "Имя кластера Managed MySQL"
}

variable "network_id" {
  type        = string
  description = "ID сети, в которой размещается кластер"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Подсети по зонам { zone = subnet_id } для размещения хостов"
}

variable "ha" {
  type        = bool
  default     = true
  description = "true → 2 хоста (высокая доступность), false → 1 хост"
}

variable "zones" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b"]
  description = "Зоны хостов по порядку. Для single-host берётся первая, для HA — первые две."
}

variable "mysql_version" {
  type        = string
  default     = "8.0"
  description = "Версия MySQL"
}

variable "environment" {
  type        = string
  default     = "PRESTABLE"
  description = "PRESTABLE (дешевле, для тестов) или PRODUCTION"
}

variable "resource_preset_id" {
  type        = string
  default     = "b1.medium"
  description = "Класс хостов. b1.medium — минимальный burstable (2 ядра / 4 ГБ)."
}

variable "disk_type_id" {
  type        = string
  default     = "network-ssd"
  description = "Тип диска"
}

variable "disk_size" {
  type        = number
  default     = 10
  description = "Размер диска, ГБ (минимум для экономии)"
}

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

variable "public_key" {
  type        = string
  description = "Публичный ssh-ключ для cloud-init. Значение — в personal.auto.tfvars."
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС"
}

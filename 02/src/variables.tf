###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}


###network vars

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона подсети develop (web-ВМ). https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "CIDR подсети develop в зоне ru-central1-a"
}

variable "default_zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "Зона второй подсети develop-b (db-ВМ)"
}
variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "CIDR подсети develop-b в зоне ru-central1-b"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###metadata vars

/* Задание 6: одиночный ssh-ключ заменён общей map-переменной vms_metadata — не используется.
variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "public-часть ssh-ключа (ssh-keygen -t ed25519), пользователь ubuntu"
}
*/

# Задание 6 — общий metadata для всех ВМ (serial-port + ssh-keys).
# Реальное значение (с ssh-ключом) задаётся в personal.auto.tfvars (в .gitignore).
variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:<your_ssh_ed25519_key>"
  }
  description = "Общие metadata обеих ВМ"
}

### Переменные ВМ (Задание 3)
### Сюда перенесены все переменные первой (web) ВМ из variables.tf
### и объявлены переменные второй (db) ВМ.
### В Задании 6 часть переменных закомментирована (заменены на vms_resources / locals).

######## web VM — префикс vm_web_ ########

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа загрузочного диска (общий образ обеих ВМ)"
}

/* Задание 5: имя ВМ теперь собирается в locals.tf (local.vm_web_name) — не используется.
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя web-ВМ"
}
*/

variable "vm_web_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона доступности web-ВМ"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Платформа web-ВМ (Intel Cascade Lake — поддерживает core_fraction=5)"
}

/* Задание 6: cores/memory/core_fraction объединены в vms_resources — не используются.
variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Кол-во vCPU web-ВМ"
}

variable "vm_web_memory" {
  type        = number
  default     = 2
  description = "RAM (ГБ) web-ВМ"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Гарантированная доля vCPU (%) web-ВМ"
}
*/

variable "vm_web_nat" {
  type        = bool
  default     = false
  description = "Внешний IP (NAT) web-ВМ. Задание 9: false — выход в интернет через NAT gateway"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Прерываемая (preemptible) web-ВМ"
}


######## db VM — префикс vm_db_ ########

/* Задание 5: имя ВМ теперь собирается в locals.tf (local.vm_db_name) — не используется.
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Имя db-ВМ"
}
*/

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Зона доступности db-ВМ (по заданию — ru-central1-b)"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Платформа db-ВМ"
}

/* Задание 6: cores/memory/core_fraction объединены в vms_resources — не используются.
variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Кол-во vCPU db-ВМ"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "RAM (ГБ) db-ВМ"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Гарантированная доля vCPU (%) db-ВМ"
}
*/

variable "vm_db_nat" {
  type        = bool
  default     = false
  description = "Внешний IP (NAT) db-ВМ. Задание 9: false — выход в интернет через NAT gateway"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Прерываемая (preemptible) db-ВМ"
}


######## Компоненты имён ВМ — Задание 5 (используются в locals.tf) ########

variable "project" {
  type        = string
  default     = "netology"
  description = "Префикс проекта в имени ВМ"
}

variable "vm_web_role" {
  type        = string
  default     = "web"
  description = "Роль web-ВМ в составном имени"
}

variable "vm_db_role" {
  type        = string
  default     = "db"
  description = "Роль db-ВМ в составном имени"
}


######## Ресурсы ВМ единой map-переменной — Задание 6 ########

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
  description = "Конфиги CPU/RAM обеих ВМ (вложенный map(object))"
}

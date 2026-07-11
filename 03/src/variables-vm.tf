########################################################################
#  Переменные виртуальных машин и управляющие флаги проекта.
#  Значения по умолчанию рассчитаны на ОСНОВНОЙ прогон (задания 1–5):
#     enable_nat=true, enable_bastion=false, web_provision=false.
#  Для задания 6* используется файл task6.tfvars (см. README).
########################################################################

### --- Общие для всех ВМ ---

variable "image_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Семейство образа загрузочного диска (единое для всех ВМ)"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Платформа ВМ (Intel Ice Lake)"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Путь к публичному ssh-ключу (Задание 2.4 — считывается через file())"
}

variable "ssh_private_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Путь к приватному ssh-ключу (Задание 6 — ssh-add перед ansible)"
}

variable "enable_nat" {
  type        = bool
  default     = true
  description = "Публичный IP (NAT) у целевых ВМ. Задание 6*: false — доступ только через bastion"
}

### --- Задание 2.1: web-ВМ (мета-аргумент count) ---

variable "web_vm_count" {
  type        = number
  default     = 2
  description = "Количество одинаковых web-ВМ (web-1, web-2)"
}

variable "web_vm" {
  type = object({
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
  })
  default = {
    cpu           = 2
    ram           = 1
    disk_volume   = 10
    core_fraction = 20
  }
  description = "Параметры одинаковых web-ВМ (count)"
}

### --- Задание 2.2: ВМ баз данных (мета-аргумент for_each) ---

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 15
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
  ]
  description = "ВМ БД для for_each: main и replica — разные по cpu/ram/disk_volume"
}

variable "db_core_fraction" {
  type        = number
  default     = 20
  description = "Гарантированная доля vCPU (%) для ВМ баз данных"
}

### --- Задание 3: диски и одиночная ВМ storage ---

variable "storage_disk_count" {
  type        = number
  default     = 3
  description = "Количество дополнительных дисков (count)"
}

variable "storage_disk_size" {
  type        = number
  default     = 1
  description = "Размер каждого дополнительного диска, ГБ"
}

variable "storage_vm" {
  type = object({
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
  })
  default = {
    cpu           = 2
    ram           = 1
    disk_volume   = 10
    core_fraction = 20
  }
  description = "Параметры одиночной ВМ storage"
}

### --- Задание 6*: bastion и запуск ansible ---

variable "enable_bastion" {
  type        = bool
  default     = false
  description = "Создавать ли bastion-ВМ (Задание 6*)"
}

variable "bastion_vm" {
  type = object({
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
  })
  default = {
    cpu           = 2
    ram           = 1
    disk_volume   = 10
    core_fraction = 20
  }
  description = "Параметры bastion-ВМ"
}

variable "web_provision" {
  type        = bool
  default     = false
  description = "Запускать ли ansible-playbook через null_resource + local-exec (Задание 6*)"
}

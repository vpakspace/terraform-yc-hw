variable "env_name" {
  type        = string
  description = "Имя окружения — используется как имя сети и префикс имён подсетей (develop, production, ...)"
}

# ── Интерфейс задания 2: одна подсеть через скалярные zone + cidr ──
variable "zone" {
  type        = string
  default     = null
  description = "Зона одиночной подсети (задание 2). Игнорируется, если задан список subnets."
}

variable "cidr" {
  type        = string
  default     = null
  description = "v4_cidr_blocks одиночной подсети (задание 2). Игнорируется, если задан список subnets."
}

# ── Интерфейс задания 4*: подсети во всех зонах через list(object) ──
variable "subnets" {
  type = list(object({
    zone = string
    cidr = string
  }))
  default     = null
  description = "Список подсетей по зонам (задание 4*). Приоритетнее zone/cidr. Пример: [{ zone = \"ru-central1-a\", cidr = \"10.0.1.0/24\" }]"

  validation {
    condition     = var.subnets == null ? true : length(var.subnets) > 0
    error_message = "Список subnets не может быть пустым: передайте хотя бы одну подсеть."
  }
}

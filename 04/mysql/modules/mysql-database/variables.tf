variable "cluster_id" {
  type        = string
  description = "ID существующего кластера Managed MySQL"
}

variable "database" {
  type        = string
  description = "Имя базы данных"
}

variable "username" {
  type        = string
  description = "Имя пользователя"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Пароль пользователя (мин. 8 символов). Задаётся в personal.auto.tfvars."
}

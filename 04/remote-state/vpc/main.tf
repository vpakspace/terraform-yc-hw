# Задание 8*: root-модуль №1 — только сеть и подсеть.
# Переиспользуем тот же локальный vpc-модуль из задания 2.
module "vpc" {
  source   = "../../src/vpc"
  env_name = "remote-state"
  zone     = var.default_zone
  cidr     = "10.30.1.0/24"
}

# Задание 5 — имя каждой ВМ через интерполяцию ${..} с НЕСКОЛЬКИМИ переменными.
# Итоговые имена совпадают с прежними, поэтому terraform apply не пересоздаёт ВМ:
#   netology-develop-platform-web  и  netology-develop-platform-db
locals {
  vm_web_name = "${var.project}-${var.vpc_name}-platform-${var.vm_web_role}"
  vm_db_name  = "${var.project}-${var.vpc_name}-platform-${var.vm_db_role}"
}

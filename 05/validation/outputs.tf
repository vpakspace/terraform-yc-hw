# Каталог существует ради проверки блоков validation, ресурсов в нём нет, поэтому
# переменные formально нигде не использовались — tflint справедливо считал их
# мёртвым кодом (terraform_unused_declarations). Outputs делают их частью
# конфигурации и заодно позволяют посмотреть значения без terraform console:
# terraform output vm_ip
output "vm_ip" {
  description = "Проверенный ip-адрес (задание 4)"
  value       = var.vm_ip
}

output "vm_ip_list" {
  description = "Проверенный список ip-адресов (задание 4)"
  value       = var.vm_ip_list
}

output "any_string" {
  description = "Проверенная строка без символов верхнего регистра (задание 5*)"
  value       = var.any_string
}

output "in_the_end_there_can_be_only_one" {
  description = "Проверенный объект: ровно один Горец (задание 5*)"
  value       = var.in_the_end_there_can_be_only_one
}

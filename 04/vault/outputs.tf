# Задание 7.4: весь словарь секрета (nonsensitive — чтобы показать значение).
output "vault_example" {
  description = "Содержимое секрета secret/example"
  value       = nonsensitive(data.vault_generic_secret.vault_example.data)
}

# Задание 7.4: обращение к конкретному ключу test.
output "vault_example_test" {
  description = "Значение ключа test из секрета secret/example"
  value       = nonsensitive(data.vault_generic_secret.vault_example.data.test)
}

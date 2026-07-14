output "database_name" {
  description = "Имя созданной базы данных"
  value       = yandex_mdb_mysql_database.this.name
}

output "username" {
  description = "Имя созданного пользователя"
  value       = yandex_mdb_mysql_user.this.name
}

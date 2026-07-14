# Задание 5.2: БД и пользователь в уже существующем кластере.
resource "yandex_mdb_mysql_database" "this" {
  cluster_id = var.cluster_id
  name       = var.database
}

resource "yandex_mdb_mysql_user" "this" {
  cluster_id = var.cluster_id
  name       = var.username
  password   = var.password

  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }
}

# Сеть и подсети для кластера (переиспользуем локальный vpc-модуль из задания 2).
# Две подсети (a, b): для single-host нужна одна, для HA=2 — обе.
module "vpc" {
  source   = "../src/vpc"
  env_name = "mysql"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.20.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.20.2.0/24" },
  ]
}

# Задание 5.1: модуль кластера. Число хостов зависит от var.ha (HA=true → 2, false → 1).
module "mysql_cluster" {
  source             = "./modules/mysql-cluster"
  name               = "example"
  network_id         = module.vpc.network_id
  subnet_ids         = module.vpc.subnet_ids
  ha                 = var.ha
  zones              = ["ru-central1-a", "ru-central1-b"]
  resource_preset_id = var.resource_preset_id
}

# Задание 5.2: модуль БД + пользователя в уже созданном кластере.
module "mysql_database" {
  source     = "./modules/mysql-database"
  cluster_id = module.mysql_cluster.cluster_id
  database   = "test"
  username   = "app"
  password   = var.db_password
}

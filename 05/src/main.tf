# ─────────────────────────────────────────────────────────────────────────────
# Задание 1: cloud-init с nginx и ssh-ключом через переменную.
# Ключ передаётся в data "template_file" в блоке vars = {}, шаблон — cloud-init.yml.
# Пример: https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/
# ─────────────────────────────────────────────────────────────────────────────
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_key = var.public_key
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Задание 2: локальный модуль vpc заменяет ресурсы yandex_vpc_network + yandex_vpc_subnet.
# develop-сеть создаётся скалярным интерфейсом задания 2 (zone + cidr → 1 сеть + 1 подсеть).
# ─────────────────────────────────────────────────────────────────────────────
module "vpc" {
  source   = "./vpc"
  env_name = var.vpc_name
  zone     = var.default_zone
  cidr     = var.default_cidr
}

# ─────────────────────────────────────────────────────────────────────────────
# Задание 4*: тот же модуль vpc, но интерфейсом list(object) — подсети во всех зонах.
# Демонстрирует, что модуль умеет и одну подсеть (develop выше), и несколько (production).
# Примечание: в YC зона ru-central1-c выведена из эксплуатации, актуальны a / b / d.
# ─────────────────────────────────────────────────────────────────────────────
module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.10.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.10.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.10.3.0/24" },
  ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Задание 1: две ВМ через ДВА вызова remote-модуля, разные проекты обозначены через labels.
# Обе ВМ — в develop-сети (subnet из vpc-модуля, задание 2), preemptible для экономии.
# ─────────────────────────────────────────────────────────────────────────────
module "marketing_vm" {
  # Модуль закреплён коммит-хешем тега 1.0.0 (было ?ref=main — подвижная ветка).
  # Хеш, а не имя тега: тег можно передвинуть, хеш неизменяем. Это закрывает сразу
  # три замечания линтеров — terraform_module_pinned_source, CKV_TF_1 и CKV_TF_2.
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=4d05fab828b1fcae16556a4d167134efca2fccf2" # tag 1.0.0

  env_name       = "marketing"
  network_id     = module.vpc.network_id
  subnet_zones   = module.vpc.subnet_zones
  subnet_ids     = values(module.vpc.subnet_ids)
  instance_name  = "vm"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true
  preemptible    = true

  labels = {
    owner   = "vpakspace"
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = "1"
  }
}

module "analytics_vm" {
  # Модуль закреплён коммит-хешем тега 1.0.0 (было ?ref=main — подвижная ветка).
  # Хеш, а не имя тега: тег можно передвинуть, хеш неизменяем. Это закрывает сразу
  # три замечания линтеров — terraform_module_pinned_source, CKV_TF_1 и CKV_TF_2.
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=4d05fab828b1fcae16556a4d167134efca2fccf2" # tag 1.0.0

  env_name       = "analytics"
  network_id     = module.vpc.network_id
  subnet_zones   = module.vpc.subnet_zones
  subnet_ids     = values(module.vpc.subnet_ids)
  instance_name  = "vm"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true
  preemptible    = true

  labels = {
    owner   = "vpakspace"
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = "1"
  }
}

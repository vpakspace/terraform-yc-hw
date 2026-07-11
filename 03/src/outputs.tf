########################################################################
#  Задание 5*: output списком словарей {name, id, fqdn} для ВМ
#  из ресурса count (web) и ресурса for_each (databases).
#  Итерация по ресурсам, без хардкода — любое число ВМ.
########################################################################

output "vms_count_foreach" {
  description = "ВМ из count (web) и for_each (databases): имя, идентификатор, внутренний FQDN"
  value = concat(
    [for vm in yandex_compute_instance.web : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }],
    [for vm in yandex_compute_instance.db : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }],
  )
}

# Задание 7.4: чтение секрета secret/example (создаётся заранее в web-UI или через CLI).
# Движок secret/ переведён в KV v1 (dev-режим по умолчанию монтирует v2, а с v2
# у vault_generic_secret путь был бы secret/data/example и значение в .data.data).
# С KV v1 путь и обращение к .data совпадают с примером из задания.
data "vault_generic_secret" "vault_example" {
  path = "secret/example"
}

# Задание 7.5: запись нового секрета в Vault средствами terraform.
resource "vault_generic_secret" "tf_example" {
  path = "secret/terraform"
  data_json = jsonencode({
    test = "written-by-terraform"
  })
}

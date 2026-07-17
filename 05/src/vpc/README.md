<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | v4\_cidr\_blocks одиночной подсети (задание 2). Игнорируется, если задан список subnets. | `string` | `null` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Имя окружения — используется как имя сети и префикс имён подсетей (develop, production, ...) | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Список подсетей по зонам (задание 4*). Приоритетнее zone/cidr. Пример: [{ zone = "ru-central1-a", cidr = "10.0.1.0/24" }] | <pre>list(object({<br/>    zone = string<br/>    cidr = string<br/>  }))</pre> | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Зона одиночной подсети (задание 2). Игнорируется, если задан список subnets. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID созданной облачной сети |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Имя созданной облачной сети |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | ID подсетей по зонам |
| <a name="output_subnet_zones"></a> [subnet\_zones](#output\_subnet\_zones) | Список зон, в которых созданы подсети |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Полные объекты созданных подсетей (yandex\_vpc\_subnet) по зонам |
<!-- END_TF_DOCS -->
# Задание 8*: второй root-модуль читает состояние первого (vpc) через remote state.
# Backend local: путь к terraform.tfstate соседнего root-модуля vpc.
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}

# Задание 9* — NAT gateway для выхода ВМ в интернет без внешнего IP (nat=false).
# Подсети develop / develop-b используют этот route table (0.0.0.0/0 -> gateway).
resource "yandex_vpc_gateway" "nat" {
  name = "${var.vpc_name}-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat" {
  name       = "${var.vpc_name}-nat-route"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

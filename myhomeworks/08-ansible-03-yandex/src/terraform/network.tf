# Создание сети и подсети в YC
resource "yandex_vpc_network" "default" {
  name = "bobronet"
}

resource "yandex_vpc_subnet" "default" {
  name = "${yandex_vpc_network.default.name}_subnet_${var.yc_zone}"
  zone           = "${var.yc_zone}"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.10.10.0/24"]
}

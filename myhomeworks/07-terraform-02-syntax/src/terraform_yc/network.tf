# Network
resource "yandex_vpc_network" "bobronet" {
  name = "bobronet"
  folder_id = "${var.yc_folder_id}"
}

resource "yandex_vpc_subnet" "bobrosubnet1" {
  name = "bobrosubnet1_rucentral1a"
  folder_id = "${var.yc_folder_id}"
  zone           = "${var.yc_zone}"
  network_id     = "${yandex_vpc_network.bobronet.id}"
  v4_cidr_blocks = ["10.10.10.0/24"]
}
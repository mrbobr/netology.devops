resource "yandex_compute_instance" "node01" {
  name                      = "clickhouse"
  zone                      = "${var.yc_zone}"
  hostname                  = "node01"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.yc_ami_centos_id}"
      name        = "root-node01"
      type        = "network-ssd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.10.10.11"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node03" {
  name                      = "lighthouse"
  zone                      = "${var.yc_zone}"
  hostname                  = "node03"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.yc_ami_centos_id}"
      name        = "root-node03"
      type        = "network-ssd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.10.10.13"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

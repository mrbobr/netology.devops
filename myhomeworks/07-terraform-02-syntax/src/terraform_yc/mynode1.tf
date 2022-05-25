resource "yandex_compute_instance" "myserver01" {
  name                      = "myserver01"
  hostname                  = "myserver01.netology.yc"
  zone                      = "${var.yc_zone}"
  folder_id                 = "${var.yc_folder_id}"
  service_account_id        = "${var.yc_sa_id}"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.yc_ami_id}"
      name        = "root-serv01"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.bobrosubnet1.id}"
    nat        = true
    ip_address = "10.10.10.11"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

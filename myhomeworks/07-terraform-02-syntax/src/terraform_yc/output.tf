output "id_myserver01" {
  value = "${yandex_compute_instance.myserver01.id}"
}

output "internal_ip_address_myserver01" {
  value = "${yandex_compute_instance.myserver01.network_interface.0.ip_address}"
}

output "public_ip_address_myserver01" {
  value = "${yandex_compute_instance.myserver01.network_interface.0.nat_ip_address}"
}
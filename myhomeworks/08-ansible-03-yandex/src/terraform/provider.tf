# Описание провайдера TF
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
# Указание параметров для YC
provider "yandex" {
  token     = "${var.yc_token}"
  zone      = "${var.yc_zone}"
  cloud_id  = "${var.yc_cloud_id}"
  folder_id = "${var.yc_folder_id}"
 # service_account_key_file = "key.json" # генерируется в web конфликтует с параметром token
}
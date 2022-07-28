# ПЕРЕМЕННЫЕ YC в явном виде
# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
#variable "yandex_cloud_id" {
#  default = ""
#}
# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
#variable "yandex_folder_id" {
#  default = ""
#}
# Заменить на ID своего образа
# ID можно узнать с помощью команды CLI yc compute image list или в сервисе compute cloud в разделе "образы"
#variable "centos-7-base" {
#  default = ""  #
#}

# ! Для скрытого использования в terraform можно создавать переменные окружения в формате TF_VAR_название_переменной
# Указать ID своего облака VPC в переменной TF_VAR_yc_cloud_id и т.д.
variable "yc_cloud_id" {}
# folder ID в облаке VPC
variable "yc_folder_id" {}
# зона доступности по умолчанию
variable "yc_zone" {}
# ID образа для ВМ
variable "yc_ami_centos_id" {}
# ID сервисного пользователя из IAM
variable "yc_sa_id" {}
# токен (можно присвоить env переменной значение `yc iam create-token` для автоматического получения токена для указанного SA)
variable "yc_token" {}

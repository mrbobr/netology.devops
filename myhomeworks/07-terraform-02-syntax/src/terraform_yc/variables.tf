# Для использования в terraform переменные окружения создавать в формате TF_VAR_название_переменной

# ПЕРЕМЕННЫЕ YC
# Указать ID своего облака VPC
variable "yc_cloud_id" {}
# Указать folder ID в облаке VPC
variable "yc_folder_id" {}
# Указать зону доступности по умолчанию
variable "yc_zone" {}
# Указать ID образа для ВМ
# ID можно узнать с помощью команды yc compute image list или в веб-консоли
# centos7 id=fd8rdcd74jho9ssh779e
variable "yc_ami_id" {}
# Указать ID сервисного пользователя из IAM
variable "yc_sa_id" {}
# Указать токен (можно присвоить env переменной значение `yc iam create-token`)
variable "yc_token" {}
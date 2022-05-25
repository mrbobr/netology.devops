# ПЕРЕМЕННЫЕ AWS
# ID облака VPC
variable "aws_vpc_id" {
  default = "vpc-02fad9ce0ac159ad9"
}
# Подсеть в облаке VPC
variable "aws_subnet_id" {
  default = "subnet-04c6eb4503214df5e"  #public
}
# Группа защиты для доступа только по SSH
variable "aws_sg_id" {
  default = "sg-0a8d53221ae0857c7"
}

variable "aws_pub_key" {}
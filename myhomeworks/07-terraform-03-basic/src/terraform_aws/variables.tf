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
# Публичный ключ из env
variable "aws_pub_key" {}

# инстансы cell1 для count
locals {
  instance_types = {
    dev = "t1.micro"
    stage = "t2.micro"
    prod = "t3.micro"
  }
  instance_count = {
    dev = 0
    stage = 1
    prod = 2
  }
}

#инстансы cell2 для for_each
variable "cell2_instances" {
default = {
  dev   = {
    node01 = "t1.micro"
    node02 = "t2.micro"
    node03 = "t3.micro"
  }
  stage = {
    node01 = "t2.micro"
  }
  prod  = {
    node01 = "t2.micro"
    node02 = "t2.micro"
  }
}
}

#Форматирование строк
variable "name" { default = "server"}
variable count_offset { default = 0 } #start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable count_format { default = "%02d" } #server number format (-1, -2, etc.)
# Configure the AWS Provider
provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh-key" {
  public_key = "${var.aws_pub_key}"
  key_name = "ssh-key"
}

resource "aws_instance" "server01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name      = "ssh-key"
  subnet_id = "${var.aws_subnet_id}"
  security_groups = ["${var.aws_sg_id}"]

  ebs_block_device {
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = 8
    volume_type = "standard"
  }
    tags = {
    Name = "server01"
  }
}
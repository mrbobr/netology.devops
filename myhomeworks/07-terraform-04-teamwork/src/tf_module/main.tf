# Configure the AWS Provider
provider "aws" {}

resource "aws_key_pair" "ssh-key" {
  public_key = "${var.aws_pub_key}"
  key_name = "ssh-key"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = toset(["server01", "server02"])

  name = "instance-${each.key}"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "ssh-key"
  associate_public_ip_address = true
  monitoring             = true
  vpc_security_group_ids = ["${var.aws_sg_id}"]
  subnet_id              = "${var.aws_subnet_id}"
  ebs_block_device = [{
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "standard"
  }]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
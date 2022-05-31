# Resources
# SSH-ключ для подключения к созданным инстансам
resource "aws_key_pair" "ssh-key" {
  public_key = "${var.aws_pub_key}"
  key_name = "ssh-key"
}
# Описание инстансов
resource "aws_instance" "cell01" {
  ami           = data.aws_ami.ubuntu.id #указаны в ami.tf
  instance_type = local.instance_types[terraform.workspace] #указаны в variables.tf
  count = local.instance_count[terraform.workspace] #указаны в variables.tf
  associate_public_ip_address = true
  key_name      = "ssh-key"
  subnet_id = "${var.aws_subnet_id}"
  security_groups = ["${var.aws_sg_id}"]

  ebs_block_device {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "standard" #стандартный HDD
  }
  tags = {
    Name = "${terraform.workspace}-${var.name}-${format(var.count_format, var.count_offset+count.index+1)}}"
  }
}

resource "aws_instance" "cell02" {
  for_each = var.cell2_instances[terraform.workspace]
  ami = data.aws_ami.ubuntu.id
  instance_type = each.value
  associate_public_ip_address = true
  key_name      = "ssh-key"
  subnet_id = "${var.aws_subnet_id}"
  security_groups = ["${var.aws_sg_id}"]

  ebs_block_device {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "standard" #стандартный HDD
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${terraform.workspace}-${each.key}"
  }
}
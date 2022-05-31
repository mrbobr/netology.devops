data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
#output "caller_arn" {
#  value = data.aws_caller_identity.current.arn
#}
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "cell01_instances_ids" {
  value = "${aws_instance.cell01.*.id}"
}

output "cell_01_instances_private_ips"  {
  value = "${aws_instance.cell01.*.private_ip}"
}

output "cell01_instances_public_ips" {
  value = "${aws_instance.cell01.*.public_ip}"
}

output "cell02_instances_ids" {
  value = tomap({
    for k, id in aws_instance.cell02 : k => id.id
  })
}

output "cell_02_instances_private_ips"  {
  value = tomap({
    for k, ip in aws_instance.cell02 : k => ip.private_ip
  })
}

output "cell02_instances_public_ips" {
  value = tomap({
    for k, ip in aws_instance.cell02 : k => ip.public_ip
  })
}

output "aws_current_region" {
  value = data.aws_region.current.name
}

#output "aws_current_region_end" {
#  value = data.aws_region.current.endpoint
#}

output "instances_subnet_id" {
  value = "${var.aws_subnet_id}"
}

data "aws_subnet" "cidr_block" {
  id = "${var.aws_subnet_id}"
}

output "subnet_cidr_blocks" {
  value = ["${data.aws_subnet.cidr_block.cidr_block}"]
}
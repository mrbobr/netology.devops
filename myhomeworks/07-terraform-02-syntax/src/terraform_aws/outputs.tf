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

output "instance_id_server01" {
value = "${aws_instance.server01.id}"
}

output "instance_private_ip_server01" {
value = "${aws_instance.server01.private_ip}"
}

output "instance_subnet_id_server01" {
value = "${aws_instance.server01.subnet_id}"
}

output "instance_public_ip_server01" {
value = "${aws_instance.server01.public_ip}"
}

output "aws_current_region" {
  value = data.aws_region.current.name
}

#output "aws_current_region_end" {
#  value = data.aws_region.current.endpoint
#}
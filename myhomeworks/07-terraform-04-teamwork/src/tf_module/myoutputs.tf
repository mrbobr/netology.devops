output "Instances_IDs" {
  value = tomap({
    for n, id in module.ec2_instance : n => id.id
  })
}

output "Instances_public_IPs" {
  value = tomap({
    for n, ip in module.ec2_instance : n => ip.public_ip
  })
}

output "Instances_private_IPs" {
  value = tomap({
    for n, ip in module.ec2_instance : n => ip.private_ip
  })
}

data "aws_region" "current" {}
output "aws_current_region" {
  value = data.aws_region.current.name
}
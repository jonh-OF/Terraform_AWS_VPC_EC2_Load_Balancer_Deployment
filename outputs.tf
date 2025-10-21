output "aws_region" {
  value = data.aws_region.current.name

}
output "aws_availability_zones" {
  value = data.aws_availability_zones.avaliable.names

}

output "cidir_vpc" {

  value = module.network.vpc_cidr_block

}

output "private_key" {
  value     = tls_private_key.web.private_key_pem
  sensitive = true
}

output "ip_server" {
  value = aws_instance.web.*.public_ip

}
output "dir_red" {
  value = aws_instance.web[0].public_ip
}
#ssh -i key.pem ubuntu@ip
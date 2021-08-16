output "ec2InstanceId" {
  value = aws_instance.ec2_instance.id
}
output "eip" {
  value = aws_eip.eip_ec2_instance.public_ip
}
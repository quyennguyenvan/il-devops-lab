output "vpc_id" {
  value = aws_vpc.il_vpc_main.id
}

output "sn_app_zone_a_ec_instance" {
  value = aws_subnet.sn_app_zone_a_ec_instance.id
}

output "sn_app_zone_c_ec_instance" {
 value = aws_subnet.sn_app_zone_c_ec_instance.id 
}

output "sn_dbg" {
  value = aws_db_subnet_group.db_sng_rds.id
}
#create the vpc
resource aws_vpc "il_vpc_main"{
    cidr_block = var.vpc_cidr
    tags = merge(var.tags,{Name = "VPC IL Lab"})
}
#setup IGW
resource "aws_internet_gateway" "igw_il_vpc_main_main" {
    vpc_id = aws_vpc.il_vpc_main.id
    tags = var.tags
}
#create the subnet
resource "aws_subnet" "sn_app_zone_a_ec_instance" {
    vpc_id = aws_vpc.il_vpc_main.id
    cidr_block = var.azonea_instance_cidr
    availability_zone = var.azonea
    assign_ipv6_address_on_creation = false
    map_public_ip_on_launch = true
    tags = merge(var.tags,
    {Name = "Subnet Instance Zone A"})
}
resource "aws_subnet" "sn_app_zone_c_ec_instance" {
    vpc_id = aws_vpc.il_vpc_main.id
    cidr_block = var.azonec_instance_cidr
    availability_zone = var.azonec
    assign_ipv6_address_on_creation = false
    map_public_ip_on_launch = true
    tags = merge(var.tags,
    {Name = "Subnet Instance Zone C"})
}
resource "aws_subnet" "sn_app_db_zonea" {
  vpc_id = aws_vpc.il_vpc_main.id
  cidr_block = var.azonea_db_cidr
  availability_zone = var.azonea
  tags = merge(var.tags,{Name = "Subnet DB Instance Zone A"})
}
resource "aws_subnet" "sn_app_db_zonec" {
  vpc_id = aws_vpc.il_vpc_main.id
  cidr_block = var.azonec_db_cidr
  availability_zone = var.azonec
  tags = merge(var.tags,{Name = "Subnet DB Instancce Zone C"})
}
resource "aws_db_subnet_group" "db_sng_rds" {
    name = "default_db_subnet_rds"
    subnet_ids = [ aws_subnet.sn_app_db_zonea.id,aws_subnet.sn_app_db_zonec.id ]
    tags = var.tags
}
#set route table
resource "aws_default_route_table" "rtb_vpc_il_vpc_main_main" {
    default_route_table_id = aws_vpc.il_vpc_main.default_route_table_id
    tags = var.tags
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_il_vpc_main_main.id
    }
}
resource "aws_route_table_association" "rtb_main_association_subnet" {
    subnet_id = aws_subnet.sn_app_zone_a_ec_instance.id
    route_table_id = aws_default_route_table.rtb_vpc_il_vpc_main_main.id
}
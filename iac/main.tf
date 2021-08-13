#generate the radon password for rds
resource "random_password" "rd_pwd_postgre" {
    length = 14
    special = true
}
#create the vpc
resource aws_vpc "if_vpc"{
    cidr_block = var.vpc_cidr
    tags = var.tags
}
#setup IGW
resource "aws_internet_gateway" "igw_if_vpc_main" {
    vpc_id = aws_vpc.if_vpc.id
    tags = var.tags
}
#create the subnet
resource "aws_subnet" "sn_app_ec_instance" {
    vpc_id = aws_vpc.if_vpc.id
    cidr_block = var.azonea_instance_cidr
    availability_zone = var.azonea
    tags = var.tags
}
resource "aws_subnet" "sn_app_db" {
  vpc_id = aws_vpc.if_vpc.id
  cidr_block = var.azonea_instance_cidr
  availability_zone = var.azonea
  tags = var.tags
}
#set route table
resource "aws_default_route_table" "rtb_vpc_if_vpc_main" {
    default_route_table_id = aws_vpc.if_vpc.default_route_table_id
    tags = var.tags
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_if_vpc_main.id
    }
}
resource "aws_route_table_association" "rtb_main_association_subnet" {
    subnet_id = aws_subnet.sn_app_ec_instance.id
    route_table_id = aws_default_route_table.rtb_vpc_if_vpc_main.id
}
#create the security group for ec2 instance
resource "aws_security_group" "sg_ec2_instance" {
    vpc_id = aws_vpc.if_vpc.id
    name = "SG EC2 APP INSTANCE"
    description = "Allow the users of admin group can access with restrict IP"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.currentIPACCESS]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = var.tags
}
#create the instance
resource "aws_instance" "ec2_instance" {
  ami = var.aws-linux2
  instance_type = var.instance-size
  vpc_security_group_ids = [ aws_security_group.sg_ec2_instance.id ]
  subnet_id = aws_subnet.sn_app_ec_instance.id
  tags = var.tags
}
#request EIP
resource "aws_eip" "eip_ec2_instance" {
  instance = aws_instance.ec2_instance.id
  vpc = true
  tags = var.tags
}

#create the S3 static web
resource aws_s3_bucket "if_s3_static_web_test_job"{
    bucket = "s3-static-web-job-tf"
    acl = "private"
    website {
        index_document = "index.html"
        error_document = "error.html"
    }
    cors_rule {
        allowed_headers = ["Authorization"]
        allowed_methods = ["GET", "HEAD", "POST", "DELETE"]
        allowed_origins = ["*"]
        max_age_seconds = 3000
    }
    tags = var.tags
}
resource "aws_s3_bucket_public_access_block" "block_s3_web_public_access" {
  bucket = aws_s3_bucket.if_s3_static_web_test_job.id
  block_public_acls   = false
  block_public_policy = false
}
#create the ECR
resource "aws_ecr_repository" "ecr_if_py_app" {
    name = "if_py_app"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
}

#create the security group for rds instance
resource "aws_security_group" "sg_rds_postgres_instance" {
    vpc_id = aws_vpc.if_vpc.id
    name = "SG RDS INSTANCE"
    description = "Allow app can access into the rds instance"
    ingress {
        description = "Allow Subnet EC Instance accessable"
        from_port = var.db_port
        to_port = var.db_port
        protocol = "tcp"
        cidr_blocks = [var.azonea_instance_cidr]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = var.tags
}
#create the postgresql
resource "aws_db_instance" "rds_postgre_db" {
    identifier =  var.identifier_db
    name =  var.db_name

    username = var.username
    password = random_password.rd_pwd_postgre.result
    port = var.db_port
    

    engine = "postgres"
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    storage_type = var.storage_type
    max_allocated_storage = var.max_allocated_storage

    availability_zone = var.availability_zone
    publicly_accessible = var.publicly_accessible

}
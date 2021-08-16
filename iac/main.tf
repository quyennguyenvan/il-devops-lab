#generate the radon password for rds
resource "random_password" "rd_pwd_postgre" {
    length = 14
    special = false
}
module "iam" {
  source = "./modules/iam"
  tags = var.tags
}

#load the module vpc
module "vpc" {
  depends_on = [
    module.iam
  ]
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azonea = var.azonea
  azonec = var.azonec
  azonea_db_cidr = var.azonea_db_cidr
  azonec_db_cidr = var.azonec_db_cidr
  azonea_instance_cidr = var.azonea_instance_cidr
  azonec_instance_cidr = var.azonec_instance_cidr
  tags = var.tags
}

#load the module for ec2 <basiton vm to test>
module "ec2_instance" {
  depends_on = [
    module.vpc
  ]
  count = var.enable_ec2_module ? 1 : 0
  
  source = "./modules/ec2instance"
  vpc_id =  module.vpc.vpc_id
  instanceami = var.aws-linux2
  instancesize = var.instancesize
  sn_instance_id = module.vpc.sn_app_zone_a_ec_instance
  allow_IP = var.SSH_IP_ADMIN_ALLOW
  cird_allow = "0.0.0.0/0"
  aws_key_pair_public = var.aws_key_pair_public
  tags = merge(var.tags,
    {
      name = "EC2 Instance"
    }
  )
}
#load the S3 static web
module "s3_storage_static_web"{
  count = var.enable_s3_module ? 1 : 0

  source = "./modules/s3"
  block_public_acls = false
  block_public_policy = false
  tags = var.tags
}

#load the module ecr
module "ecr_module"{
  count = var.enable_ecr_module ? 1 : 0

  source = "./modules/ecr"
}

#load the module postgres
module "postgresql_db" {
  depends_on = [
    module.vpc
  ]
  count = var.enable_postgresql_module ? 1 : 0
  source = "./modules/postgresql"
  vpc_id = module.vpc.vpc_id
  cidr_allow = var.vpc_cidr
  parameter_group_family = var.parameter_group_family
  parameter_group_name_description = var.parameter_group_name_description
  identifier_db = var.identifier_db
  db_name = var.db_name
  username = var.username
  rd_pwd_postgre = random_password.rd_pwd_postgre
  db_port = var.db_port
  enginedb = var.enginedb
  engine_version = var.engine_version
  instance_class = var.instance_class
  storage_type = var.storage_type
  multi_az = var.multi_az
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  availability_zone = var.availability_zone
  publicly_accessible = var.publicly_accessible
  db_subnet_group_name = module.vpc.sn_dbg_name
  skip_final_snapshot = var.skip_final_snapshot
  backup_retention_period = 7
  apply_immediately = var.apply_immediately
  monitoring_interval = var.monitoring_interval
  iam_monitoring_interval_rds_arn = module.iam.monitoring_interval_rds
  storage_credential_to_ssm  = true
  tags = var.tags
}


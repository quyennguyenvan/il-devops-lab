#generate the radon password for rds
resource "random_password" "rd_pwd_postgre" {
    length = 14
    special = false
}


#create the iam role for monitoring
resource "aws_iam_policy" "rds_enhance_policy" {
  name = "rds-enhanced-monitoring-policy"
  policy = file("policies/policy_monitoring_rds.json")
}
resource "aws_iam_role" "iam_monitoring_interval_rds" {
  name = "enhanced-monitoring-rds-instance-role"
  path = "/"
  description = "Allow the monitoring enhance of rds instance"
  max_session_duration = 3600 #one hours
  assume_role_policy = file("policies/trusted_rds_policy.json")
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "role_rds_monitoring_attachment_policy" {
  role = aws_iam_role.iam_monitoring_interval_rds.name
  policy_arn = aws_iam_policy.rds_enhance_policy.arn
}

#create the kms role
data "template_file" "kms_template_policy" {
  template = file("policies/key_kms_grant.json")
  vars = {
        username = "quyennvcom-admin" #replace the current user by your user on your cloud account
  }
}
resource "aws_iam_policy" "ksm_policy_grant" {
    name = "kms-grant-policy"
    policy = data.template_file.kms_template_policy.rendered
}
resource "aws_iam_role" "iam_cks_kms_role" {
  name = "customer-managed-key-role"
  path = "/"
  description = "Allow the users can managed the cks"
  max_session_duration = 3600 #one hours
  assume_role_policy = file("policies/trusted_kms.json")
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "role_kms_attachment_policy" {
  role = aws_iam_role.iam_cks_kms_role.name
  policy_arn = aws_iam_policy.ksm_policy_grant.arn
}
#create the kms key
resource "aws_kms_key" "kms_db_key" {
    description = "The kms key for rds perfomance insight"
    key_usage = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "RSA_2048"
    is_enabled = true
    enable_key_rotation = false
    deletion_window_in_days = 7
    tags = var.tags
}
resource "aws_kms_alias" "kms_alias_name" {
    name = "alias/ksm_app_db"
    target_key_id = aws_kms_key.kms_db_key.id
}
resource "aws_kms_grant" "kms_grant_permission" {
  name = "user-admin-grant-for-managed"
  key_id = aws_kms_key.kms_db_key.key_id
  grantee_principal = aws_iam_role.iam_cks_kms_role.arn
  operations = [ "Encrypt", "Decrypt"]
}

#load the module vpc
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azonea = var.azonea
  azonec = var.azonec
  azonea_db_cidr = var.azonea_db_cidr
  azonec_db_cidr = var.azonec_db_cidr
  azonea_instance_cidr = var.azonea_instance_cidr
  azonec_instance_cidr = var.azonec_instance_cidr
  tags = var.tags
  cidr_allow = var.vpc_cidr
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
  allow_IP = var.sshIPADMINALLOW
  cidr_allow = var.vpc_cidr
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
  vpc_id = aws_vpc.il_vpc_main.id
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
  db_subnet_group_name = aws_db_subnet_group.db_sng_rds.name
  skip_final_snapshot = var.skip_final_snapshot
  backup_retention_period = 7
  apply_immediately = var.apply_immediately
  monitoring_interval = var.monitoring_interval
  iam_monitoring_interval_rds_arn = aws_iam_role.iam_monitoring_interval_rds.arn
  storage_credential_to_ssm  = true
  tags = var.tags
}


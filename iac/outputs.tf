output "rds_postgres_endpoint" {
  value = module.postgresql_db.rds_postgres_endpoint
  description = "RDS endpoint."
}

output "rds_postgres_username" {
  value = module.postgresql_db.rds_postgres_username
  description = "RDS username."
}

output "rds_postgres_password" {
  value = module.postgresql_db.rds_postgres_password
  sensitive   = true
  description = "RDS password."
}

output "ecr_arn" {
    value = module.ecr.ecr_arn
    description = "The arn of ecr"
}

output "aws_vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_instance_id" {
  value = module.ec2.ec2InstanceId
}
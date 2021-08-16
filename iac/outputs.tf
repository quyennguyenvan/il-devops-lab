output "rds_postgres_endpoint" {
  value = toset(
      [
          for endpoint in module.postgresql_db : endpoint.rds_postgres_endpoint
      ]
  )
  description = "RDS endpoint."
}

output "rds_postgres_username" {
  value = toset(
      [
          for username in module.postgresql_db : username.rds_postgres_username
      ]
  )
  description = "RDS username."
}

output "rds_postgres_password" {
  value = toset(
      [
          for pwd in module.postgresql_db : pwd.rds_postgres_password
      ]
  )
  sensitive   = true
  description = "RDS password."
}

output "ecr_arn" {
    value = toset(
      [
          for ecr in module.ecr_module : ecr.ecr_arn
      ]
    )
    description = "The arn of ecr"
}

output "aws_vpc_id" {
  value = module.vpc.vpc_id
}
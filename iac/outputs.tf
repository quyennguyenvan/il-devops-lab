output "rds_postgres_endpoint" {
  value       = toset(
      [
          for endpoint in module.postgresql_db : endpoint.rds_postgres_endpoint
      ]
  )
  description = "RDS endpoint."
}

output "rds_postgres_username" {
  value       = module.postgresql_db[0].rds_postgres_username
  description = "RDS username."
}

output "rds_postgres_password" {
  value       = module.postgresql_db[0].rds_postgres_password
  sensitive   = true
  description = "RDS password."
}

output "ecr_arn" {
    value = module.ecr_module[0].ecr_arn
    description = "The arn of ecr"
}
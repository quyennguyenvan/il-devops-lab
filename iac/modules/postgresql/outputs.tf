output "rds_postgres_endpoint" {
  value       = aws_db_instance.rds_postgre_db.endpoint
  description = "RDS endpoint."
}

output "rds_postgres_username" {
  value       = aws_db_instance.rds_postgre_db.username
  description = "RDS username."
}

output "rds_postgres_password" {
  value       = aws_db_instance.rds_postgre_db.password
  sensitive   = true
  description = "RDS password."
}

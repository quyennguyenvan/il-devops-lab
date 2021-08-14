output "ecr_arn" {
    description = "The statistic of ecr arn"
    value = aws_ecr_repository.ecr_il_py_app.arn
}
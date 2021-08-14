#create the ECR
resource "aws_ecr_repository" "ecr_il_py_app" {
    name = "il_py_app"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
}
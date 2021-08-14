resource aws_s3_bucket "il_s3_static_web_test_job"{
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
  bucket = aws_s3_bucket.il_s3_static_web_test_job.id
  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
}

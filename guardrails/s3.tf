resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = var.s3.block_public_acls
  block_public_policy     = var.s3.block_public_policy
  ignore_public_acls      = var.s3.ignore_public_acls
  restrict_public_buckets = var.s3.restrict_public_buckets
}

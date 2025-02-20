resource "aws_s3_account_public_access_block" "default" {
  block_public_acls       = var.s3.account_public_access_block.block_public_acls
  block_public_policy     = var.s3.account_public_access_block.block_public_policy
  ignore_public_acls      = var.s3.account_public_access_block.ignore_public_acls
  restrict_public_buckets = var.s3.account_public_access_block.restrict_public_buckets
}

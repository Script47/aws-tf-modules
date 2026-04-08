resource "aws_s3_bucket" "this" {
  count = var.create_bucket ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = true
  tags          = var.tags
  provider      = aws.default
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = var.bucket_name != "" ? var.bucket_name : aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  provider                = aws.default
}

resource "aws_s3_bucket_policy" "this" {
  bucket   = var.bucket_name != "" ? var.bucket_name : aws_s3_bucket.this[0].bucket
  policy   = data.aws_iam_policy_document.cloudfront_to_s3.json
  provider = aws.default
}

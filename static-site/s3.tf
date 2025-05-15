resource "aws_s3_bucket" "static_site" {
  bucket        = local.bucket_name
  force_destroy = true
  tags          = var.tags
  provider      = aws.default
}

resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  provider                = aws.default
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket   = aws_s3_bucket.static_site.bucket
  policy   = data.aws_iam_policy_document.static_site.json
  provider = aws.default
}
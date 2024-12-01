resource "aws_s3_bucket" "static_site" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
  provider      = aws.default
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket   = aws_s3_bucket.static_site.bucket
  policy   = data.aws_iam_policy_document.static_site.json
  provider = aws.default
}
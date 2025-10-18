data "aws_caller_identity" "current" {}

data "aws_route53_zone" "hosted_zone" {
  count        = local.create_hosted_zone ? 0 : 1
  name         = var.hosted_zone
  private_zone = false
}

data "aws_iam_policy_document" "cloudfront_to_s3" {
  statement {
    sid       = "AllowCloudFrontToAccessBucket"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.static_site.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}
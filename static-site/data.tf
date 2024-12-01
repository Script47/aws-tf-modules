data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repo_path}"]
    }
  }
}


data "aws_iam_policy_document" "static_site" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.static_site.arn
      ]
    }
  }
}

data "aws_iam_policy_document" "deploy_web" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      aws_s3_bucket.static_site.arn,
      "${aws_s3_bucket.static_site.arn}/*",
      aws_cloudfront_distribution.static_site.arn
    ]
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  private_zone = false
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}
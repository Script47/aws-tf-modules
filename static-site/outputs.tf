output "bucket" {
  value = {
    id  = aws_s3_bucket.static_site.id
    arn = aws_s3_bucket.static_site.arn
  }
}

output "cloudfront" {
  value = {
    id          = aws_cloudfront_distribution.static_site.id
    domain_name = aws_cloudfront_distribution.static_site.domain_name
    aliases     = aws_cloudfront_distribution.static_site.aliases
  }
}

output "role" {
  value = var.setup_cd ? {
    arn = aws_iam_role.deploy_static_site[0].arn
  } : null
}

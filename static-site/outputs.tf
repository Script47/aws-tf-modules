output "bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy_static_site.arn
}

output "cloudfront" {
  value = {
    id          = aws_cloudfront_distribution.static_site.id
    domain_name = aws_cloudfront_distribution.static_site.domain_name
    aliases     = aws_cloudfront_distribution.static_site.aliases
  }
}
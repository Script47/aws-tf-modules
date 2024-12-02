output "bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy_static_site.arn
}

output "cloudfront_dist_id" {
  value = aws_cloudfront_distribution.static_site.id
}

output "cloudfront_dist_domain_name" {
  value = aws_cloudfront_distribution.static_site.domain_name
}

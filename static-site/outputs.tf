output "bucket" {
  value = {
    arn = var.create_bucket ? aws_s3_bucket.static_site[0].arn : data.aws_s3_bucket.user_created[0].arn
    id  = local.bucket_name
  }
}

output "cloudfront" {
  value = {
    arn         = aws_cloudfront_distribution.static_site.arn
    id          = aws_cloudfront_distribution.static_site.id
    domain_name = aws_cloudfront_distribution.static_site.domain_name
    aliases     = aws_cloudfront_distribution.static_site.aliases
  }
}

output "external_validation_records" {
  value = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      value  = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
    if !contains(local.internal_domains, dvo.domain_name)
  }
}
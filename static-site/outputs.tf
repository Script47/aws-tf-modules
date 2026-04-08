output "bucket" {
  value = {
    arn = var.create_bucket ? aws_s3_bucket.this[0].arn : data.aws_s3_bucket.user_created[0].arn
    id  = local.bucket_name
  }
}

output "cloudfront" {
  value = {
    arn         = aws_cloudfront_distribution.this.arn
    id          = aws_cloudfront_distribution.this.id
    domain_name = aws_cloudfront_distribution.this.domain_name
    aliases     = aws_cloudfront_distribution.this.aliases
  }
}

output "external_validation_records" {
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      value  = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
    if !contains(local.internal_domains, dvo.domain_name)
  }
}
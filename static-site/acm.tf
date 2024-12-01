resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
  provider          = aws.useast1
}
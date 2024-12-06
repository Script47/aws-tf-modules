resource "aws_acm_certificate" "cloudfront_cert" {
  count = local.setup_custom_domain ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
  provider          = aws.acm
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  count = local.setup_custom_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records[0] : record.fqdn]
  provider                = aws.acm
}
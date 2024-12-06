resource "aws_acm_certificate" "cloudfront_cert" {
  count = local.setup_custom_domain ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
  provider          = aws.acm

  lifecycle {
    prevent_destroy = local.setup_custom_domain ? false : true
  }
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  count = local.setup_custom_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.cloudfront_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records : record.fqdn]
  provider                = aws.acm

  lifecycle {
    prevent_destroy = local.setup_custom_domain ? false : true
  }
}
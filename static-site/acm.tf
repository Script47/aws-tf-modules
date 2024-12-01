resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
  provider          = aws.acm
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records : record.fqdn]
}
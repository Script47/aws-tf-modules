resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name               = local.primary_domain
  subject_alternative_names = local.domains
  validation_method         = "DNS"
  tags                      = var.tags
  provider                  = aws.acm
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records : record.fqdn]
  provider                = aws.acm
}
resource "aws_acm_certificate" "this" {
  domain_name               = local.primary_domain
  subject_alternative_names = var.domains
  validation_method         = "DNS"
  tags                      = var.tags
  provider                  = aws.acm

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
  validation_record_fqdns = [
    for record in aws_route53_record.acm_records : record.fqdn
    if contains(local.internal_domains, record.fqdn)
  ]
  provider = aws.acm
}

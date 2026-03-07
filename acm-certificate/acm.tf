locals {
  domains        = distinct(var.domains)
  primary_domain = local.domains[0]
}

resource "aws_acm_certificate" "this" {
  domain_name               = local.primary_domain
  subject_alternative_names = local.domains
  validation_method         = "DNS"
  tags                      = var.tags

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.acm
}

resource "aws_acm_certificate_validation" "this" {
  for_each = var.zone_id == null ? {} : { "validation" = true }

  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records : record.fqdn]

  provider = aws.acm
}

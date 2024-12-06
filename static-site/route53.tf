#############################################
# Validation for the ACM cert
#############################################

resource "aws_route53_record" "acm_records" {
  for_each = local.setup_custom_domain ? {
    for dvo in aws_acm_certificate.cloudfront_cert[0].domain_validation_options : dvo.domain_name => {
      type   = dvo.resource_record_type
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
    }
  } : {}

  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
  provider        = aws.default
}

#############################################
# Setup the A record for your custom domain
#############################################

resource "aws_route53_record" "static_site_a_record" {
  count = local.setup_custom_domain ? 1 : 0

  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }

  provider = aws.default
}

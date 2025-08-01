resource "aws_route53_zone" "hosted_zone" {
  count = local.create_hosted_zone ? 1 : 0
  name  = local.primary_domain
  tags  = var.tags
}

#############################################
# Validation for the ACM cert
#############################################
resource "aws_route53_record" "acm_records" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = local.create_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : data.aws_route53_zone.hosted_zone[0].zone_id
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
  count = length(local.domains)

  zone_id = local.create_hosted_zone ? aws_route53_zone.hosted_zone[0].zone_id : data.aws_route53_zone.hosted_zone[0].zone_id
  type    = "A"
  name    = local.domains[count.index]

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }

  provider = aws.default
}

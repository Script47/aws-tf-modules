#############################################
# Validation for the ACM cert
#############################################
resource "aws_route53_record" "acm_records" {
  for_each = var.zone_id == null ? {} : {
    for o in aws_acm_certificate.this.domain_validation_options : o.domain_name => o
  }

  zone_id         = var.zone_id
  type            = each.value.resource_record_type
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true

  provider = aws.default
}

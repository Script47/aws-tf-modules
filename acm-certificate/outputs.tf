output "arn" {
  value = var.zone_id == null ? aws_acm_certificate.this.arn : aws_acm_certificate_validation.this["validation"].certificate_arn
}

output "dns" {
  value = {
    domains = local.domains
    records = {
      for dvo in aws_acm_certificate.this.domain_validation_options :
      dvo.domain_name => {
        type  = dvo.resource_record_type
        name  = dvo.resource_record_name
        value = dvo.resource_record_value
      }
    }
  }
}

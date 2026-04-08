locals {
  create_hosted_zone = var.hosted_zone == ""
  hosted_zone_domain = local.create_hosted_zone ? local.primary_domain : data.aws_route53_zone.this[0].name
  primary_domain     = var.domains[0]
  primary_domain_normalised = replace(
    replace(local.primary_domain, "/\\*\\./", ""), # remove wildcard prefix
    "/[^a-zA-Z0-9-]/", "-"                         # replace anything else with -
  )
  internal_domains = [
    for d in var.domains : d
    if endswith(d, local.hosted_zone_domain)
  ]

  bucket_name = var.bucket_name == "" ? local.primary_domain : var.bucket_name
  bucket_arn  = var.create_bucket ? aws_s3_bucket.this[0].arn : data.aws_s3_bucket.user_created[0].arn
}

output "internal_domains" {
  value = local.internal_domains
}

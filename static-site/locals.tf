locals {
  domains        = distinct(var.domains)
  primary_domain = local.domains[0]

  primary_domain_normalised = replace(local.primary_domain, ".", "-")

  create_hosted_zone = var.hosted_zone == ""

  bucket_name = var.bucket_name == "" ? local.primary_domain : var.bucket_name
}

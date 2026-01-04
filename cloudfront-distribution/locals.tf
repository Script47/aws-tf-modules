locals {
  domains                   = distinct(var.domains)
  primary_domain            = local.domains[0]
  primary_domain_normalised = replace(local.primary_domain, ".", "-")
}

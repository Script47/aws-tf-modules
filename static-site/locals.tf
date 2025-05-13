locals {
  aliases            = [var.domain_name]
  create_hosted_zone = var.hosted_zone == ""
}
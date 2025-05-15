locals {
  aliases = [var.domain_name]
  create_hosted_zone = var.hosted_zone == ""
  bucket_name        = var.bucket_name == "" ? var.domain_name : var.bucket_name
}
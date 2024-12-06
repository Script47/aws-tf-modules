locals {
  aliases             = [var.domain_name]
  setup_custom_domain = var.domain_name != ""
}
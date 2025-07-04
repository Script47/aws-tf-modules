data "aws_route53_zone" "hosted_zone" {
  count        = local.create_hosted_zone ? 0 : 1
  name         = var.hosted_zone
  private_zone = false
}

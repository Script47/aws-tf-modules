data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone
  private_zone = false
}

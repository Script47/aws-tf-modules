resource "aws_route53_record" "domain_verification" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = var.domain_verification.ttl
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_route53_record" "dkim" {
  count   = var.dkim.enabled ? 3 : 0
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${aws_ses_domain_dkim.this[0].dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = var.dkim.ttl
  records = ["${aws_ses_domain_dkim.this[0].dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_route53_record" "dmarc" {
  count   = var.dmarc.enabled ? 1 : 0
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = var.dmarc.ttl
  records = [var.dmarc.policy]
}
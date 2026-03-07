locals {
  configure_dns = var.zone_id != null
  spf_record = join(
    " ",
    concat(
      ["v=spf1"],
      [for d in var.spf.includes : "include:${d}"],
      [var.spf.all]
    )
  )
}

resource "aws_route53_record" "domain_verification" {
  count = local.configure_dns ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = var.domain_verification.ttl
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_route53_record" "dkim" {
  count = local.configure_dns && var.dkim.enabled ? 3 : 0

  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.this[0].dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = var.dkim.ttl
  records = ["${aws_ses_domain_dkim.this[0].dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_route53_record" "spf" {
  count = local.configure_dns && var.spf.enabled ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = var.spf.ttl

  records = [
    local.spf_record
  ]
}

resource "aws_route53_record" "dmarc" {
  count = local.configure_dns && var.dmarc.enabled ? 1 : 0

  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = var.dmarc.ttl
  records = [var.dmarc.policy]
}

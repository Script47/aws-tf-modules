output "dkim" {
  value = var.dkim.enabled ? [
    for token in aws_ses_domain_dkim.this[0].dkim_tokens : {
      type  = "CNAME"
      name  = "${token}._domainkey.${var.domain}"
      value = "${token}.dkim.amazonses.com"
      ttl   = var.dkim.ttl
    }
  ] : []
}
output "dns" {
  value = {
    domain = var.domain
    records = concat(
      [
        {
          type  = "TXT"
          name  = "_amazonses.${var.domain}"
          value = aws_ses_domain_identity.this.verification_token
          ttl   = var.domain_verification.ttl
        }
      ],

      var.dkim.enabled ? [
        for token in aws_ses_domain_dkim.this[0].dkim_tokens : {
          type  = "CNAME"
          name  = "${token}._domainkey.${var.domain}"
          value = "${token}.dkim.amazonses.com"
          ttl   = var.dkim.ttl
        }
      ] : [],

      var.spf.enabled ? [{
        type = "TXT"
        name = var.domain
        value = join(
          " ",
          concat(
            ["v=spf1"],
            [for d in var.spf.includes : "include:${d}"],
            [var.spf.all]
          )
        )
        ttl = var.spf.ttl
      }] : [],

      var.dmarc.enabled ? [{
        type  = "TXT"
        name  = "_dmarc.${var.domain}"
        value = var.dmarc.policy
        ttl   = var.dmarc.ttl
      }] : []
    )
  }
}

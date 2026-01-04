resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "this" {
  count  = var.dkim.enabled ? 1 : 0
  domain = aws_ses_domain_identity.this.domain
}

# SES Domain Identity

This module allows you to setup domain identification for SES with the following features:

- Domain verification
- DKIM
- SPF
- DMARC

## Usage

### With a literal zone ID

```hcl
module "ses_domain_identity" {
  source = "github.com/script47/aws-tf-modules/ses-domain-identity"

  zone_id = "zone-id"
  domain  = "example.org"

  domain_verification = {
    ttl = 600
  }

  dkim = {
    enabled = true
    ttl     = 600
  }

  spf = {
    enabled  = true
    includes = ["amazonses.com"] # amazonses.com is default
    all      = "~all"
    ttl      = 600
  }

  dmarc = {
    enabled = true
    policy  = "v=DMARC1; p=reject;"
    ttl     = 600
  }
}
```

### With a resource-derived zone ID

If `zone_id` comes from a resource created in the same apply (e.g. `aws_route53_zone`), set `manage_dns_records = true` explicitly. Without it, Terraform cannot evaluate the `count` at plan time and will error with "Invalid count argument".

```hcl
module "ses_domain_identity" {
  source = "github.com/script47/aws-tf-modules/ses-domain-identity"

  zone_id            = aws_route53_zone.zone.id
  manage_dns_records = true
  domain             = "example.org"
}
```

### Without DNS management

To create the SES domain identity without managing Route53 records, set `manage_dns_records = false`. `zone_id` can then be omitted.

```hcl
module "ses_domain_identity" {
  source = "github.com/script47/aws-tf-modules/ses-domain-identity"

  manage_dns_records = false
  domain             = "example.org"
}
```

See `variables.tf` for the full argument reference.

# SES Domain Identity

This module allows you to setup domain identification for SES with the following features:

- Domain verification
- DKIM
- SPF
- DMARC

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "ses_doamin_identity" {
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

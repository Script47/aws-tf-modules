# SES Domain Identity

This module allows you to setup domain identification for SES with the following features:

- Domain verification
- DKIM
- DMARC

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "ses_doamin_identity" {
  source       = "github.com/script47/aws-tf-modules/ses-domain-identity"

  hosted_zone         = "my-hosted-zone"
  domain              = "example.org"

  domain_verification = {
    ttl = 600
  }

  dkim = {
    enabled = true
    ttl     = 600
  }

  dmarc = {
    enabled = true
    policy  = "v=DMARC1; p=reject;"
    ttl     = 600
  }
}
```

# ACM Certificate

This module provisions an AWS ACM certificate for one or more domains and optionally performs automatic DNS validation
using Route 53.

## Features

- AWS ACM certificate with multi-domain (SAN) support
- Optional automatic DNS validation via Route 53
- Ability to manage DNS validation externally if no hosted zone is provided
- Deterministic primary domain selection
- Safe certificate replacement using `create_before_destroy`
- Resource tagging support

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "acm_certificate" {
  source = "github.com/script47/aws-tf-modules/acm-certificate"

  domains = [
    "example.org",
    "www.example.org"
  ]

  zone_id = "Z123456789"

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }

  providers = {
    aws.default = aws
    aws.acm     = aws.useast1
  }
}

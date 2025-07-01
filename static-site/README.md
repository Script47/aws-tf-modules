# Static Site Module

## About

This module allows you to setup a static site with the following features:

- S3 bucket for static content (secure, private access only via CloudFront OAC)
- CloudFront distribution with TLS certificate (ACM) and full domain aliasing
  - Automatic DNS validation for ACM via Route 53
  - Optional creation of Route 53 Hosted Zone (or reuse an existing one)
  - Multi-domain support
- CI/CD deploy IAM role via OIDC (optional)
- Fallback support for SPA (`403 → 200 /index.html` and `404 → 200 /index.html`)
- Resource tagging for manageable resources

## Assumptions

This module assumes you have GitHub OIDC setup to use the CD features provided by the module. You can use the `setup_cd`
toggle to disable this.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "static_site" {
  source      = "github.com/Script47/aws-tf-modules/static-site"

  domains     = ["example.org"]
  bucket_name = "example.org"
  hosted_zone = "my-hosted_zone"
  role_name   = "deploy-example-org"
  repo        = "example-org/repo:ref:refs/heads/master"
  setup_cd    = false

  restriction = {
    type      = "none"
    locations = []
  }

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "produdction"
  }

  providers = {
    aws.default = aws
    aws.acm     = aws.useast1
  }
}
```

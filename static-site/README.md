# Static Site

## About

This module allows you to setup a static site with the following features:

- S3 bucket for static content (secure, private access only via CloudFront OAC)
- CloudFront distribution with TLS certificate (ACM) and full domain aliasing
  - Automatic DNS validation for ACM via Route 53
  - Optional creation of Route 53 Hosted Zone (or reuse an existing one)
  - Multi-domain support
- Fallback support for SPA (`403 → 200 /index.html` and `404 → 200 /index.html`)
- Resource tagging for manageable resources

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "static_site" {
  source      = "github.com/script47/aws-tf-modules/static-site"

  bucket_name = "example.org"
  hosted_zone = "my-hosted-zone"
  domains     = ["example.org"]

  geo_restriction = {
    type      = "none"
    locations = []
  }

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2025"
  }

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
```

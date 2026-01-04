# CloudFront Distribution

## About

This module allows you to setup a static site with the following features:

- CloudFront distribution with TLS certificate (ACM) and full domain aliasing
  - Automatic DNS validation for ACM via Route 53
  - Multi-domain support
- Resource tagging for manageable resources

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "cloudfront_distribution" {
  source      = "github.com/script47/aws-tf-modules/cloudfront-distribution"

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
    Environment = "produdction"
  }

  providers = {
    aws.default = aws
    aws.acm     = aws.useast1
  }
}
```

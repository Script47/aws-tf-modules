# Static Site Module

## About

This module enables you to set up a static site/SPA on AWS with the following features:

- Custom domain with corresponding A record in the hosted zone and TLS certificate (DNS validated)
- S3 bucket for hosting the static site
- CloudFront distribution for site delivery
  - OAC for secure access between CloudFront and S3
  - Ensures only signed requests (SigV4) are allowed to S3
- IAM role for CD (e.g., GitHub Actions)
- Resource tagging for manageable resources

## Assumptions

This module assumes you have an existing hosted zone for the static site domain and GitHub OIDC setup.

## Usage

```hcl
module "static_site" {
  source = "github.com/Script47/aws-tf-modules/static-site"

  bucket_name = "example.org"
  domain_name = "example.org"
  role_name   = "deploy-example-org"
  repo        = "example-org/web:ref:refs/heads/master"

  restriction = {
    type      = "none"
    locations = []
  }

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Project = "my-project"
    Service = "my-service"
  }

  providers = {
    aws.default = aws
    aws.acm     = aws.useast1
  }
}
```

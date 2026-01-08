# OIDC GitHub Provider

## About

This module allows you to setup the provider for GitHub OIDC.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "oidc_github_provider" {
  source      = "github.com/script47/aws-tf-modules/oidc-github-provider"

  thumbprints = []

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }
}
```

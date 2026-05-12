# HTTP API Domain

This module sets up a custom domain name for API Gateway v2 HTTP APIs.

## Features

- `aws_apigatewayv2_domain_name` with TLS 1.2 and REGIONAL endpoint
- Optional Route53 A alias record (omit `zone_id` to manage DNS externally)
- Designed to be shared across multiple `http-api` instances at different base paths

## Design notes

**Why is the domain separate from the API?** A single domain (`api.mysite.com`) can serve multiple independent APIs mounted at different base paths (`/auth`, `/posts`, `/members`). If the domain lived inside each `http-api` module instance, every API would try to create the same domain resource. Keeping the domain here lets you create it once and map as many APIs to it as you need.

**Bring-your-own cert.** Use the `acm-certificate` module to provision the ACM certificate, then pass its ARN here. ACM certificates for API Gateway regional endpoints must be in the same AWS region as the API (unlike CloudFront, which requires `us-east-1`).

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "cert" {
  source  = "github.com/script47/aws-tf-modules//acm-certificate"
  domains = ["api.mysite.com"]
  zone_id = "Z123456789ABCDEF"
  tags    = local.tags
}

module "api_domain" {
  source = "github.com/script47/aws-tf-modules//http-api-domain"

  domain_name     = "api.mysite.com"
  certificate_arn = module.cert.arn
  zone_id         = "Z123456789ABCDEF"

  tags = {
    Project     = "my-project"
    Environment = "production"
  }
}
```

Then pass the domain to each `http-api` module:

```hcl
module "posts_api" {
  source = "github.com/script47/aws-tf-modules//http-api"
  name   = "posts-api"

  domain = {
    name      = module.api_domain.domain.name
    base_path = "posts"
  }

  # ...
}

module "auth_api" {
  source = "github.com/script47/aws-tf-modules//http-api"
  name   = "auth-api"

  domain = {
    name      = module.api_domain.domain.name
    base_path = "auth"
  }

  # ...
}
```

See `http-api/README.md` for the full multi-module wiring example.

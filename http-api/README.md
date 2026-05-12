# HTTP API

This module sets up an API Gateway v2 HTTP API backed by Lambda functions.

## Features

- HTTP API with optional global CORS configuration
- Lambda proxy integrations (`AWS_PROXY`, payload format 2.0)
- Single REQUEST-type Lambda authorizer applied per-route (opt-out with `authorized = false`)
- All Lambda permissions (`lambda:InvokeFunction`) managed by this module; no configuration needed on the Lambda side
- Base-path mapping onto a shared custom domain (via `http-api-domain`)
- Default execute-api endpoint disabled when a custom domain is configured
- CloudWatch access logging for the `$default` stage

## Design notes

**Why is the domain separate?** The `http-api-domain` module owns the `aws_apigatewayv2_domain_name` resource. This module only creates the mapping between the API and a base path on that domain. This allows a single domain (`api.mysite.com`) to serve multiple independent APIs (`/auth`, `/posts`, `/members`) without each API competing to own the domain resource.

**Why does this module own all Lambda permissions?** Both route integrations and the authorizer Lambda need `aws_lambda_permission` scoped to this API's `execution_arn`. Creating them here (where the ARN is known) avoids a circular dependency: if the authorizer module granted its own permission, it would need to reference this API — and this API references the authorizer. By keeping all permissions here, the authorizer module has no back-reference.

**`authorized = true` by default.** Routes are protected unless you explicitly opt out. Set `authorized = false` for public endpoints (webhooks, health checks, etc.). If no `authorizer` is configured, this flag has no effect.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "api" {
  source = "github.com/script47/aws-tf-modules//http-api"

  name        = "my-api"
  description = "My HTTP API"

  cors_config = {
    allow_origins = ["https://app.mysite.com"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
  }

  authorizer = {
    function_arn = module.authorizer.arn
    # identity_sources defaults to ["$request.header.Authorization"]
  }

  routes = {
    "GET /items" = {
      function_arn = module.list_items_fn.arn
      # authorized defaults to true
    }
    "POST /items" = {
      function_arn = module.create_item_fn.arn
    }
    "POST /webhook" = {
      function_arn = module.webhook_fn.arn
      authorized   = false
    }
  }

  domain = {
    name      = module.api_domain.domain.name
    base_path = "items"
  }

  logs = {
    enabled           = true
    retention_in_days = 30
  }

  tags = {
    Project     = "my-project"
    Environment = "production"
  }
}
```

## Complete example

The following wires together all three HTTP API modules: `acm-certificate`, `http-api-domain`, `http-api-lambda-authorizer`, and `http-api`.

```hcl
locals {
  tags = {
    Project     = "my-project"
    Environment = "production"
  }
}

# ACM certificate for the custom domain (same region as the API)
module "cert" {
  source  = "github.com/script47/aws-tf-modules//acm-certificate"
  domains = ["api.mysite.com"]
  zone_id = "Z123456789ABCDEF"
  tags    = local.tags
}

# Custom domain: created once, shared across all APIs mounted on it
module "api_domain" {
  source          = "github.com/script47/aws-tf-modules//http-api-domain"
  domain_name     = "api.mysite.com"
  certificate_arn = module.cert.arn
  zone_id         = "Z123456789ABCDEF"
  tags            = local.tags
}

# Authorizer Lambda: validates JWT Bearer tokens in Lambda code
# No Lambda permissions are configured here; http-api handles them
module "authorizer" {
  source  = "github.com/script47/aws-tf-modules//http-api-lambda-authorizer"
  name    = "posts-authorizer"
  src     = abspath("${path.module}/../dist/authorizer")
  handler = "index.handler"
  tags    = local.tags
}

# Route Lambda functions
module "list_posts_fn" {
  source  = "github.com/script47/aws-tf-modules//lambda-function"
  name    = "list-posts"
  src     = abspath("${path.module}/../dist/list-posts")
  handler = "index.handler"
  tags    = local.tags
}

module "create_post_fn" {
  source  = "github.com/script47/aws-tf-modules//lambda-function"
  name    = "create-post"
  src     = abspath("${path.module}/../dist/create-post")
  handler = "index.handler"
  tags    = local.tags
}

module "webhook_fn" {
  source  = "github.com/script47/aws-tf-modules//lambda-function"
  name    = "posts-webhook"
  src     = abspath("${path.module}/../dist/webhook")
  handler = "index.handler"
  tags    = local.tags
}

# Posts API — mounted at api.mysite.com/posts
module "posts_api" {
  source = "github.com/script47/aws-tf-modules//http-api"

  name        = "posts-api"
  description = "Posts CRUD API"

  authorizer = {
    function_arn = module.authorizer.arn
  }

  routes = {
    "GET /posts" = {
      function_arn = module.list_posts_fn.arn
    }
    "POST /posts" = {
      function_arn = module.create_post_fn.arn
    }
    "POST /webhook" = {
      function_arn = module.webhook_fn.arn
      authorized   = false
    }
  }

  domain = {
    name      = module.api_domain.domain.name
    base_path = "posts"
  }

  logs = {
    enabled = true
  }

  tags = local.tags
}

# Outputs
output "api_endpoint" {
  value = "https://${module.posts_api.apigw.endpoint}"
  # With domain: https://api.mysite.com/posts
  # Without domain: module.posts_api.apigw.endpoint
}
```

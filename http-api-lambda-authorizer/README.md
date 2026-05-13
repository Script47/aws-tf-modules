# HTTP API Lambda Authorizer

This module sets up a Lambda function pre-configured as an HTTP API Gateway REQUEST authorizer.

## Features

- All features of the `lambda-function` module (IAM role, CloudWatch logs, layers, environment variables)
- Purpose-built for HTTP API Gateway v2 REQUEST authorizers
- The `http-api` module owns the Lambda permissions to avoid circular dependencies

## Design notes

**REQUEST type only.** The Lambda receives the full HTTP request and is responsible for validating the JWT from the `Authorization: Bearer <token>` header itself. This is different from the API Gateway-native JWT type, where API GW validates tokens directly against a JWKS endpoint (e.g. Cognito, Auth0). Use this module when you want full control over token validation logic in your Lambda code.

**No Lambda permissions created here.** When you wire this authorizer into an `http-api` module instance, that module creates the `aws_lambda_permission` granting `apigateway.amazonaws.com` the right to invoke this function - scoped to that API's `execution_arn`. Keeping permissions in the API module avoids a circular dependency: if this module created its own permission, it would need to reference the API's ARN, and the API already references this module's function ARN.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "authorizer" {
  source = "github.com/script47/aws-tf-modules//http-api-lambda-authorizer"

  name    = "my-api-authorizer"
  src     = abspath("${path.module}/../dist/authorizer")
  handler = "index.handler"

  logs = {
    enabled           = true
    retention_in_days = 14
  }

  tags = {
    Project     = "my-project"
    Environment = "production"
  }
}
```

Then pass the function ARN to `http-api`:

```hcl
module "api" {
  source = "github.com/script47/aws-tf-modules//http-api"
  name   = "my-api"

  authorizer = {
    function_arn = module.authorizer.arn
  }

  routes = {
    "GET /items" = {
      function_arn = module.items_fn.arn
    }
  }

  # ...
}
```

See `http-api/README.md` for the full multi-module wiring example.

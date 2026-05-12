# aws-tf-modules

A collection of opinionated Terraform modules for AWS.

## Modules

| Module | Description |
|---|---|
| [acm-certificate](acm-certificate/) | ACM certificate with optional Route53 DNS validation |
| [github-oidc-iam-role](github-oidc-iam-role/) | IAM role for GitHub Actions OIDC authentication |
| [github-oidc-provider](github-oidc-provider/) | GitHub OIDC identity provider |
| [guardrails](guardrails/) | Account-level security guardrails (EBS, S3, IAM) |
| [http-api](http-api/) | API Gateway v2 HTTP API with Lambda integrations and authorizer |
| [http-api-domain](http-api-domain/) | Custom domain name for HTTP APIs (shared across multiple APIs) |
| [http-api-lambda-authorizer](http-api-lambda-authorizer/) | Lambda function pre-configured as an HTTP API REQUEST authorizer |
| [lambda-function](lambda-function/) | Lambda function with IAM role, CloudWatch logging, and permissions |
| [lambda-layer](lambda-layer/) | Lambda layer packaging |
| [ses-domain-identity](ses-domain-identity/) | SES domain identity with DNS records |
| [sqs](sqs/) | SQS queue with optional dead-letter queue |
| [static-site](static-site/) | Static site hosting via S3 + CloudFront + Route53 |

## HTTP API modules

The `http-api`, `http-api-domain`, and `http-api-lambda-authorizer` modules are designed to work together. See [http-api/README.md](http-api/README.md) for the complete multi-module wiring example.

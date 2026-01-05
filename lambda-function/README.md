# Lambda Function

## About

This module allows you to setup a Lambda function.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "static_site" {
  source = "github.com/script47/aws-tf-modules/lambda-function"

  name        = "my-lambda-func"
  description = "Some description for my lambda function"

  role_arn = "my-existing-role-name" # if omitted, a role will be created by the module
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
  layer_arns = [
    "arn:aws:lambda:us-east-1:xxxxxxxxxxxx:layer:layer-name:1"
  ]

  runetime    = "nodejs24.x"
  architectures = ["arm64"]
  memory      = 128
  timeout     = 3
  concurrency = -1

  vars = {
    MY_ENV = "VAR"
  }

  src = abspath("${path.module}/../dist")
  handler = "index.handler"

  logs = {
    enabled           = true
    app_log_level     = "INFO"
    system_log_level  = "INFO"
    retention_in_days = 30
  }

  permissions = {
    apigw = {
      action     = "lambda:InvokeFunction"
      principal  = "apigateway.amazonaws.com"
      source_arn = ""
    }
  }

  async_invoke_config = {
    enabled                 = true
    max_retries             = 2
    max_event_age           = 3600
    failure_destination_arn = ""
    success_destination_arn = ""
  }

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "produdction"
  }
}
```

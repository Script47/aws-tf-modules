# Lambda Function

This module allows you to setup a Lambda function.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "fn" {
  source = "github.com/script47/aws-tf-modules/lambda-function"

  name        = "my-lambda-func"
  description = "Some description for my lambda function"

  role_arn = "my-existing-role-name" # if omitted, a role will be created by the module
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
  inline_policies = {
    s3_access = {
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["s3:GetObject"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::my-bucket/*"
        }
      ]
    }
  }
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

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }
}
```
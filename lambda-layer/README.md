# Lambda Layer

## About

This module allows you to setup a Lambda layer.

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "static_site" {
  source = "github.com/script47/aws-tf-modules/lambda-layer"

  name        = "my-lambda-layer"
  description = "Some description for my lambda layer"

  runtimes      = ["nodejs24.x"]
  architectures = ["arm64"]

  src = abspath("${path.module}/../dist")

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "produdction"
  }
}
```

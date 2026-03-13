# S3 Bucket

## About

This module allows you to setup an S3 bucket with the following features@


## Usage

See `variables.tf` for the full argument reference.

```hcl
module "s3_bucket" {
  source      = "github.com/script47/aws-tf-modules/s3-bucket"

  name = "my-bucket"

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }
}
```

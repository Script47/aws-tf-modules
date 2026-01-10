# Guardrails

## About

This module allows you to setup default guardrails to harden your AWS account with the following features:

- EBS encryption by default
- S3 account wide public block access
- IAM account password policy

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "guardrails" {
  source      = "github.com/script47/aws-tf-modules/guardrails"

  ebs = {
    encrypted = true
  }

  s3 = {
    public_access_block = {
        enabled                 = true
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
    }
  }

  iam = {
    password_policy = {
      enabled                        = true
      allow_users_to_change_password = true
      password_reuse_prevention      = 0
      hard_expiry                    = false
      max_password_age               = null
      minimum_password_length        = 12

      require_lowercase_characters   = true
      require_uppercase_characters   = true
      require_numbers                = true
      require_symbols                = true
    }
  }
}
```

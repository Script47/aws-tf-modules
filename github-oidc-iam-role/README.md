# OIDC GitHub IAM Role

## About

This module allows you to setup an IAM role for GitHub OIDC.

- IAM role with trust policy with `sub` pattern restrictions

## Assumptions

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "oidc_github_iam_role" {
  source      = "github.com/script47/aws-tf-modules/oidc-github-iam-role"

  role_name   = "my-role"

  policy_name = "my-policy-name"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "FullAccess"
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = ["*"]
      },
      {
        Sid      = "DenyCustomerBucket"
        Effect   = "Deny"
        Action   = ["s3:*"]
        Resource = [
          "arn:aws:s3:::customer",
          "arn:aws:s3:::customer/*"
        ]
      }
    ]
  })

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }
}
```

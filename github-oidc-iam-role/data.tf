data "aws_iam_openid_connect_provider" "github" {
  url      = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    dynamic "condition" {
      for_each = length(var.repo_owners) > 0 ? [1] : [] 

      content {
        test     = "StringEquals"
        variable = "token.actions.githubusercontent.com:repository_owner"
        values   = var.repo_owners
      }
    }

    dynamic "condition" {
      for_each = length(var.sub) > 0 ? [1] : [] 

      content {
        test     = "StringLike"
        variable = "token.actions.githubusercontent.com:sub"
        values   = var.sub
      }
    }
  }
}
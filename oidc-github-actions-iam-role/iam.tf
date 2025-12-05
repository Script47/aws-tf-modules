resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "policy" {
  name     = var.policy_name
  role     = aws_iam_role.role.id
  policy   = var.policy
}
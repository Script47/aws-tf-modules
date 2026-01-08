resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "policy" {
  count = var.policy != null ? 1 : 0

  name     = var.policy_name
  role     = aws_iam_role.role.id
  policy   = var.policy
}

resource "aws_iam_role_policy_attachment" "policies" {
  for_each = var.policy_arns

  role       = aws_iam_role.role.name
  policy_arn = each.value
}
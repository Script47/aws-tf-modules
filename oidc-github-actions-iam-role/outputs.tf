output "role" {
  value = {
    arn  = aws_iam_role.role.arn
    id   = aws_iam_role.role.id
    name = aws_iam_role.role.name
  }
}

output "policy" {
  value = {
    arn = aws_iam_role_policy.policy.name
    id  = aws_iam_role_policy.policy.id
  }
}
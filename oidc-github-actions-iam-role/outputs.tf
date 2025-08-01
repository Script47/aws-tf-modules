output "role" {
  value = {
    id   = aws_iam_role.role.id
    arn  = aws_iam_role.role.arn
    name = aws_iam_role.role.name
  }
}

output "policy" {
  value = {
    id  = aws_iam_role_policy.policy.id
    arn = aws_iam_role_policy.policy.name
  }
}
output "role" {
  value = {
    arn  = aws_iam_role.role.arn
    id   = aws_iam_role.role.id
    name = aws_iam_role.role.name
  }
}

output "policy" {
  value = length(aws_iam_role_policy.policy) > 0 ? {
    id  =  aws_iam_role_policy.policy[0].id
    name = aws_iam_role_policy.policy[0].name
  } : null
}
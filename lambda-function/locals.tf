locals {
  role_arn  = var.role_arn == null ? aws_iam_role.lambda[0].arn : var.role_arn
  role_name = var.role_arn == null ? aws_iam_role.lambda[0].name : basename(var.role_arn)
  policy_arns = setunion(
    var.policy_arns,
    var.logs.enabled ? [
      "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    ] : []
  )
}

resource "aws_iam_role" "lambda" {
  count = var.role_arn == null ? 1 : 0

  name = "${var.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "multiple" {
  for_each = local.policy_arns

  role       = local.role_name
  policy_arn = each.value
}
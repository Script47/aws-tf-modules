resource "aws_iam_role_policy" "logging" {
  name = "allow-cloudwatch-logs-access"
  role = var.role_arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.logs.arn}:*"
      }
    ]
  })
}

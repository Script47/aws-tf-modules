###############################################
# Sets up an IAM role which will allow deploying
# your site via pipelines.
###############################################

resource "aws_iam_role" "deploy_web" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.oidc.json
  tags               = var.tags
  provider           = aws.default
}

resource "aws_iam_policy" "deploy_web" {
  name     = var.role_name
  policy   = data.aws_iam_policy_document.deploy_web.json
  tags     = var.tags
  provider = aws.default
}

resource "aws_iam_role_policy_attachment" "deploy_web" {
  role       = aws_iam_role.deploy_web.name
  policy_arn = aws_iam_policy.deploy_web.arn
  provider   = aws.default
}
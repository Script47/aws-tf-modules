###############################################
# Sets up an IAM role which will allow deploying
# your site via pipelines.
###############################################

resource "aws_iam_role" "deploy_static_site" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.oidc.json
  tags               = var.tags
  provider           = aws.default
}

resource "aws_iam_policy" "deploy_static_site" {
  name     = var.role_name
  policy   = data.aws_iam_policy_document.deploy_static_site.json
  tags     = var.tags
  provider = aws.default
}

resource "aws_iam_role_policy_attachment" "deploy_static_site" {
  role       = aws_iam_role.deploy_static_site.name
  policy_arn = aws_iam_policy.deploy_static_site.arn
  provider   = aws.default
}
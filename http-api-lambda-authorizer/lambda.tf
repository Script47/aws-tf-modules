module "fn" {
  source = "../lambda-function"

  name            = var.name
  description     = var.description
  role_arn        = var.role_arn
  policy_arns     = var.policy_arns
  inline_policies = var.inline_policies
  layer_arns      = var.layer_arns
  runtime         = var.runtime
  architectures   = var.architectures
  memory          = var.memory
  timeout         = var.timeout
  concurrency     = var.concurrency
  vars            = var.vars
  src             = var.src
  handler         = var.handler
  logs            = var.logs
  tags            = var.tags
}

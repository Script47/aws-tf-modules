resource "aws_iam_account_password_policy" "this" {
  count = var.iam.password_policy.enabled ? 1 : 0

  allow_users_to_change_password = var.iam.password_policy.allow_users_to_change_password
  password_reuse_prevention      = var.iam.password_policy.password_reuse_prevention
  hard_expiry                    = var.iam.password_policy.hard_expiry
  max_password_age               = var.iam.password_policy.max_password_age
  minimum_password_length        = var.iam.password_policy.minimum_password_length

  require_lowercase_characters   = var.iam.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.iam.password_policy.require_uppercase_characters
  require_numbers                = var.iam.password_policy.require_numbers
  require_symbols                = var.iam.password_policy.require_symbols
}
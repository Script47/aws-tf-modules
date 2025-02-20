resource "aws_ebs_encryption_by_default" "default" {
  enabled = var.ebs.encryption_by_default
}
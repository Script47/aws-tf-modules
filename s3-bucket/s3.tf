resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.merged.json
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioned ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.sse.enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse.algo
      kms_master_key_id = var.sse.kms_key_id
    }

    bucket_key_enabled = var.sse.bucket_key_enabled
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

# resource "aws_s3_bucket_lifecycle_configuration" "this" {
#   count = length(var.lifecycle_rules) > 0 ? 1 : 0

#   bucket = aws_s3_bucket.this.id

#   dynamic "rule" {
#     for_each = var.lifecycle_rules

#     content {
#       id = each.value.id

#       status = each.value.enabled ? "Enabled" : "Disabled"

#       dynamic "transition" {
#         for_each = var.lifecycle_rules.transitions

#         content {
#           days          = each.value.days
#           storage_class = each.value.storage_class
#         }
#       }
#     }
#   }
# }

resource "aws_s3_bucket_notification" "this" {
  bucket      = aws_s3_bucket.this.id
  eventbridge = var.eventbridge
}
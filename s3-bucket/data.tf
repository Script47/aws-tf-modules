data "aws_iam_policy_document" "deny_insecure_requests" {
  statement {
    sid    = "DenyInsecureRequests"
    effect = "Deny"

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "enforce_sse" {
  statement {
    sid    = "DenyObjectsThatAreNotSSE"
    effect = "Deny"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
      "s3:CopyObject",
    ]

    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = var.sse.algo
    }

    dynamic "condition" {
      for_each = var.sse.kms_key_id != null ? [1] : []

      content {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
        values   = [var.sse.kms_key_id]
      }
    }
  }
}

data "aws_iam_policy_document" "merged" {
  source_policy_documents = compact([
    var.policy,
    data.aws_iam_policy_document.deny_insecure_requests.json,
    var.sse.enabled && var.sse.enforce ? data.aws_iam_policy_document.enforce_sse.json : null
  ])
}
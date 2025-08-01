resource "aws_lambda_function" "lambda" {
  function_name                  = var.name
  description                    = var.description
  role                           = var.role_arn
  runtime                        = var.runtime
  architectures                  = var.architectures
  memory_size                    = var.memory
  timeout                        = var.timeout
  reserved_concurrent_executions = var.concurrency
  layers                         = var.layer_arns
  handler                        = var.handler

  filename         = data.archive_file.func.output_path
  source_code_hash = data.archive_file.func.output_base64sha256

  environment {
    variables = var.vars
  }

  logging_config {
    log_group             = aws_cloudwatch_log_group.logs.name
    log_format            = "JSON"
    application_log_level = var.cloudwatch.app_log_level
    system_log_level      = var.cloudwatch.system_log_level
  }

  tags = var.tags
}

resource "aws_lambda_permission" "permissions" {
  for_each = var.permissions

  function_name = aws_lambda_function.lambda.function_name
  statement_id  = each.key
  principal     = each.value.principal
  action        = each.value.action
  source_arn    = each.value.source_arn
}

resource "aws_lambda_function_event_invoke_config" "invoke_config" {
  function_name = aws_lambda_function.lambda.function_name

  maximum_retry_attempts       = var.async_invoke_config.max_retries
  maximum_event_age_in_seconds = var.async_invoke_config.max_event_age

  dynamic "destination_config" {
    for_each = (
    var.async_invoke_config.success_destination_arn != null ||
    var.async_invoke_config.failure_destination_arn != null
    ) ? [1] : []

    content {
      dynamic "on_success" {
        for_each = var.async_invoke_config.success_destination_arn != null ? [1] : []

        content {
          destination = var.async_invoke_config.success_destination_arn
        }
      }

      dynamic "on_failure" {
        for_each = var.async_invoke_config.failure_destination_arn != null ? [1] : []

        content {
          destination = var.async_invoke_config.failure_destination_arn
        }
      }
    }
  }
}
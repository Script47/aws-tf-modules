output "arn" {
  value = module.fn.arn
}

output "function_name" {
  value = module.fn.function_name
}

output "invoke_arn" {
  value = module.fn.invoke_arn
}

output "fn" {
  description = "Lambda function details"
  value       = module.fn.fn
}

output "log_group" {
  description = "CloudWatch log group details (if enabled)"
  value       = module.fn.log_group
}

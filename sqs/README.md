# SQS

This module allows you to setup an SQS queue:

- Server-side encryption enabled by default (AWS-SSE)
- Optional Dead-Letter Queue (DLQ) with configurable retention and max receive count
- Configurable message visibility, delay, retention, and polling timeouts
- Supports tagging all created resources

## Assumptions

- DLQ is only created if explicitly enabled via the `dlq.create` flag
- The DLQ name will be the same as the primary queue with a `-dlq` suffix

## Usage

See `variables.tf` for the full argument reference.

```hcl
module "my_queue" {
  source = "github.com/script47/aws-tf-modules/sqs"

  name                                = "my-queue"
  max_size_in_bytes                   = 262144
  retention_in_seconds                = 604800
  initial_visibility_delay_in_seconds = 0
  poll_timeout_in_seconds             = 20
  lock_timeout_in_seconds             = 30

  dlq = {
    create               = true
    max_receive_count    = 5
    retention_in_seconds = 1209600
  }

  tags = {
    Project     = "my-project"
    Service     = "my-service"
    Environment = "production"
  }
}
```

## Outputs

| Name   | Description                                                                           |
| ------ | ------------------------------------------------------------------------------------- |
| `arn`  | ARN of the primary SQS queue                                                          |
| `name` | Name of the primary SQS queue                                                         |
| `url`  | URL of the primary SQS queue                                                          |
| `dlq`  | Object with DLQ attributes (`arn`, `name`, `url`) if DLQ is created; `null` otherwise |

## Resources

| Resources                      |
| ------------------------------ |
| `aws_sqs_queue`                |
| `aws_sqs_queue_redrive_policy` |

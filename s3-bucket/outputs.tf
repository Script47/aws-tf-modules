output "bucket" {
  value = {
    arn = aws_s3_bucket.this.arn
    id  = aws_s3_bucket.this.id
  }
}

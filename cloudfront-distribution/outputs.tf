output "cloudfront" {
  value = {
    arn         = aws_cloudfront_distribution.static_site.arn
    id          = aws_cloudfront_distribution.static_site.id
    domain_name = aws_cloudfront_distribution.static_site.domain_name
    aliases     = aws_cloudfront_distribution.static_site.aliases
  }
}

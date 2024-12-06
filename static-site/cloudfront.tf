resource "aws_cloudfront_distribution" "static_site" {
  comment             = "Distribution for ${var.domain_name}"
  aliases             = local.aliases
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.static_site.bucket}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront.restriction.type
      locations        = var.cloudfront.restriction.locations
    }
  }

  default_cache_behavior {
    target_origin_id           = "S3-${aws_s3_bucket.static_site.bucket}"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cloudfront.id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn            = local.setup_custom_domain ? aws_acm_certificate.cloudfront_cert[0].arn : null
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = local.setup_custom_domain ? var.cloudfront.viewer_certificate.minimum_protocol_version : null
    cloudfront_default_certificate = local.setup_custom_domain ? false : true
  }

  # For SPAs this is needed for hard refresh on dynamic routes
  custom_error_response {
    response_page_path    = "/index.html"
    response_code         = 404
    error_code            = 403
    error_caching_min_ttl = 0
  }

  tags     = var.tags
  provider = aws.default
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-for-${aws_s3_bucket.static_site.bucket}"
  description                       = "OAC for ${aws_s3_bucket.static_site.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  provider                          = aws.default
}

resource "aws_cloudfront_response_headers_policy" "cloudfront" {
  name    = "cloudfront-response-headers-policy"
  comment = "Response headers policy for ${var.domain_name}"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin"
      override        = true
    }

    strict_transport_security {
      access_control_max_age_sec = 15768000
      preload                    = false
      override                   = true
    }
  }

  provider = aws.default
}
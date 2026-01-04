resource "aws_cloudfront_distribution" "static_site" {
  comment             = "Distribution for ${local.primary_domain}"
  aliases             = local.domains
  enabled             = true
  is_ipv6_enabled     = true

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cloudfront_cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
    cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.type
      locations        = var.geo_restriction.locations
    }
  }

  dynamic "origin" {
    for_each = var.origins

    content {
      origin_id                = origin.value.id
      domain_name              = origin.value.domain_name
      origin_path              = origin.value.origin_path
      origin_access_control_id = origin.value.origin_access_control_id

      dynamic "custom_origin_config" {
        for_each = origin.value.origin_access_control_id == null ? [1] : []

        content {
          http_port              = origin.value.http_port
          https_port             = origin.value.https_port
          ip_address_type        = origin.value.ip_address_type
          origin_protocol_policy = origin.value.origin_protocol_policy
          origin_ssl_protocols   = origin.value.origin_ssl_protocols
        }
      }
    }
  }

  default_cache_behavior {
    target_origin_id           = var.origin.id
    viewer_protocol_policy     = "redirect-to-https"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cloudfront.id
    allowed_methods            = var.default_cache_behavior.allowed_methods
    origin_request_policy_id   = var.default_cache_behavior.origin_request_policy_id    
    cached_methods             = var.default_cache_behavior.cached_methods
    cache_policy_id            = var.default_cache_behavior.cache_policy_id
  }

  tags       = var.tags
  depends_on = [aws_acm_certificate_validation.cloudfront_cert_validation]
  provider   = aws.default
}

resource "aws_cloudfront_response_headers_policy" "cloudfront" {
  name    = "cf-resp-hdrs-${local.primary_domain_normalised}"
  comment = "Response headers policy for ${local.primary_domain}"

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
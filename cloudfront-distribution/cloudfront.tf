locals {
  default_origin = one([
    for o in var.origins : o if o.default
  ])
}

resource "aws_cloudfront_distribution" "static_site" {
  comment         = "Distribution for ${local.primary_domain}"
  aliases         = local.domains
  enabled         = true
  is_ipv6_enabled = true

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
    target_origin_id         = local.default_origin["id"]
    allowed_methods          = local.default_origin["allowed_methods"]
    origin_request_policy_id = local.default_origin["origin_request_policy_id"]
    cached_methods           = local.default_origin["cached_methods"]
    cache_policy_id          = local.default_origin["cache_policy_id"]
    viewer_protocol_policy   = "redirect-to-https"
  }

  dynamic "ordered_cache_behavior" {
    for_each = {
      for k, v in var.origins : k => v
      if !v.default
    }

    content {
      target_origin_id         = ordered_cache_behavior.value.id
      path_pattern             = ordered_cache_behavior.value.path_pattern
      allowed_methods          = ordered_cache_behavior.value.allowed_methods
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
      cached_methods           = ordered_cache_behavior.value.cached_methods
      cache_policy_id          = ordered_cache_behavior.value.cache_policy_id
      viewer_protocol_policy   = "redirect-to-https"
    }
  }

  tags       = var.tags
  depends_on = [aws_acm_certificate_validation.cloudfront_cert_validation]
  provider   = aws.default
}

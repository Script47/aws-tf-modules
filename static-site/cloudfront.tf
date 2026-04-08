locals {
  origin_id                   = "s3-static-site"
  origin_path                 = var.origin_path == "" ? "" : var.origin_path
  bucket_regional_domain_name = var.create_bucket ? aws_s3_bucket.static_site[0].bucket_regional_domain_name : data.aws_s3_bucket.user_created[0].bucket_regional_domain_name
  oac_name                    = replace("${local.bucket_name}-${replace(local.origin_path, "/", "-")}", "/[^a-zA-Z0-9-]/", "")
  rhp_name                    = local.primary_domain_normalised
}

resource "aws_cloudfront_distribution" "static_site" {
  comment             = "Distribution for ${local.primary_domain}"
  aliases             = local.domains
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

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

  origin {
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    domain_name              = local.bucket_regional_domain_name
    origin_path              = local.origin_path
  }

  default_cache_behavior {
    target_origin_id           = local.origin_id
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

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  tags       = var.tags
  depends_on = [aws_acm_certificate_validation.cloudfront_cert_validation]
  provider   = aws.default
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = local.oac_name
  description                       = "OAC for ${local.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  provider                          = aws.default
}

resource "aws_cloudfront_response_headers_policy" "cloudfront" {
  name    = local.rhp_name
  comment = "Response headers policy for ${local.primary_domain}"

  cors_config {
    access_control_allow_credentials = var.cors_config.access_control_allow_credentials

    access_control_allow_headers {
      items = var.cors_config.access_control_allow_headers
    }

    access_control_allow_methods {
      items = var.cors_config.access_control_allow_methods
    }

    access_control_allow_origins {
      items = var.cors_config.access_control_allow_origins
    }

    origin_override = var.cors_config.origin_override
  }

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

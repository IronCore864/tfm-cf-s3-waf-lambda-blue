locals {
  # only lowercase alphanumeric characters and hyphens allowed in s3 bucket name
  blue_s3_origin_bucket = "${replace(var.naming_prefix, "_", "-")}-blue"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "CF origin access identity for bucket ${local.blue_s3_origin_bucket}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.blue.bucket_regional_domain_name
    origin_id   = local.blue_s3_origin_bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true

  logging_config {
    include_cookies = false
    bucket          = "${local.log_bucket}.s3.amazonaws.com"
  }

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.blue_s3_origin_bucket

    forwarded_values {
      query_string = false
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.viewer_request_lambda_arn
      include_body = true
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.origin_request_lambda_arn
      include_body = false
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2018"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 403
    response_page_path    = "/403/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 405
    response_code         = 405
    response_page_path    = "/405/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 500
    response_code         = 500
    response_page_path    = "/500/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 503
    response_code         = 503
    response_page_path    = "/503/index.html"
  }

  web_acl_id          = aws_waf_web_acl.allow_office_ip_de_blue.id
  wait_for_deployment = false
}

resource "aws_route53_record" "blue" {
  zone_id = var.r53_zone_id
  name    = var.blue_r53_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

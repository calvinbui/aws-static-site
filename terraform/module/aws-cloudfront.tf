resource "aws_cloudfront_distribution" "main" {
  depends_on = [aws_acm_certificate_validation.main]

  comment = var.cloudfront_name

  # Distribution Settings
  price_class         = "PriceClass_All"
  aliases             = [for a in var.domain_names : a]
  http_version        = "http2"
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  enabled             = true

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.3_2025"
    ssl_support_method       = "sni-only"
  }

  # Origins and Origin Groups
  origin {
    domain_name = aws_s3_bucket.main.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.main.id}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  # Behaviors
  ## Default Cache Behavior
  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.main.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    min_ttl     = 86400
    max_ttl     = 31536000
    default_ttl = 86400
    compress    = true

    cache_policy_id            = data.aws_cloudfront_cache_policy.cachingoptimized.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.cors_s3origin.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers_policy.id
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = var.cloudfront_name
}

data "aws_cloudfront_cache_policy" "cachingoptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3origin" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "Managed-SecurityHeadersPolicy"
}

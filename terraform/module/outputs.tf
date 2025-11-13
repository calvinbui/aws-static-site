output "s3_bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "acm_arn" {
  value = aws_acm_certificate.main.arn
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.main.arn
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 bucket name"
}

variable "domain_names" {
  type        = list(string)
  description = "Domain names for the website"
}

variable "cloudfront_name" {
  type        = string
  description = "CloudFront distribution name"
}


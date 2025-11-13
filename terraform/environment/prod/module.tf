module "site" {
  source = "../../module"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  cloudfront_name = "${local.env}-mysite"
  bucket_name     = "${local.env}-mysite"
  domain_names    = ["example.com"]
}

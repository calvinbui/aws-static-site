resource "aws_acm_certificate" "main" {
  provider = aws.us-east-1

  domain_name               = var.domain_names[0]
  subject_alternative_names = [for a in var.domain_names : a if a != var.domain_names[0]]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "validation_zones" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => dvo
  }
  name         = each.value.domain_name
  private_zone = false
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type

  zone_id = data.aws_route53_zone.validation_zones[each.key].zone_id
}

resource "aws_acm_certificate_validation" "main" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

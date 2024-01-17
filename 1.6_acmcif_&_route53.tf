resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = "*.${var.web_domain_name}"
  subject_alternative_names = ["${var.web_domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
  vpc_id       = ""
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name            = each.value.name
  type            = each.value.type
  zone_id         = var.hosted_zone_id
  records         = [each.value.record]
  allow_overwrite = true
  ttl             = "60"
}

resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for k, v in aws_route53_record.cert_validation : v.fqdn]
}

# route53 alias creation 

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "s3_alias" {
  depends_on = [aws_acm_certificate_validation.ssl_certificate_validation]
  zone_id    = data.aws_route53_zone.hosted_zone.zone_id
  name       = var.web_domain_name #var.website-additional-domains   
  type       = "A"
  alias {
    name                   = aws_lb.wordpress-alb.dns_name
    zone_id                = aws_lb.wordpress-alb.zone_id
    evaluate_target_health = false
  }
}



## website-additional-domains
# Replace with your desired DNS record name 


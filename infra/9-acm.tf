module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.domain_name
  zone_id      = var.hosted_zone_id

  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names
  create_route53_records = true
  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}
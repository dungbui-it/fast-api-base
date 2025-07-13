output "endpoint_url" {
  value = "https://${var.domain_name}"
  description = "HTTPS endpoint URL for the application"
}

output "alb_dns_name" {
  value = module.alb.dns_name
  description = "ALB DNS name for direct access"
}

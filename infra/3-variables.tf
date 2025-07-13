# env default is dev, can be changed to prod
variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "domain_name" {
  type    = string
  default = "my-domain.com"
}

variable "subject_alternative_names" {
  type    = list(string)
}

variable "cpu_ecs_api" {
  type    = number
  default = 512  # Default ECS CPU
}

variable "memory_ecs_api" {
  type    = number
  default = 1024  # Default ECS Memory in MiB
}

variable "hosted_zone_id" {
  type    = string
  description = "The ID of the Route 53 hosted zone. If not provided, system will not working"
  default = null
}
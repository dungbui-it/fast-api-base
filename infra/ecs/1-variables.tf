variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets for ecs fargate workers"
}

variable "alb_target_group_arn" {
  type        = string
  description = "Arg of the alb target group"
}

variable "alb_security_group_id" {
  type        = string
  description = "Alb security group id"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "container_name" {
  type        = string
  description = "Container name"
  default     = "ecs-api"
}


variable "container_port" {
  type        = number
  description = "Container port"
  default     = 80
}


variable "docker_file_path" {
  type = string
  description = "File path to a docker file"
}


variable "docker_source_path" {
  type = string
  description = "Docker build source paht"
}

variable "cpu_ecs_api" {
  type        = number
  description = "CPU units for the ECS task"
  default     = 512  # Adjust as needed
}

variable "memory_ecs_api" {
  type        = number
  description = "Memory in MiB for the ECS task"
  default     = 1024  # Adjust as needed
}

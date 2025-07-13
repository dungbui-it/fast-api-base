module "ecs_api" {
  source = "./ecs"

  subnet_ids            = module.vpc.private_subnets
  alb_target_group_arn  = module.alb.target_groups["ex_ecs"].arn
  alb_security_group_id = module.alb.security_group_id
  cluster_name          = local.name

  docker_file_path   = "app/dockerfiles/ecs.Dockerfile"
  docker_source_path = ".."

  container_name     = "ecs-api"
  cpu_ecs_api       = var.cpu_ecs_api    # Default 512 CPU units
  memory_ecs_api    = var.memory_ecs_api  # Default 1024 Mi
}

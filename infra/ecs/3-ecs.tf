module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.12.1"

  cluster_name = var.cluster_name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

}


module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.1"
  name        = "ecs-api-fargate"
  cluster_arn = module.ecs_cluster.arn

  cpu    = var.cpu_ecs_api
  memory = var.memory_ecs_api

  # Enables ECS Exec
  enable_execute_command = true

  # Container definition(s)
  container_definitions = {

    (var.container_name) = {
      cpu       = var.cpu_ecs_api
      memory    = var.memory_ecs_api
      essential = true
      image    = module.docker_build_ecr.image_uri
      port_mappings = [
        {
          name          = var.container_name
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      linux_parameters = {
        capabilities = {
          add = []
          drop = [
            "NET_RAW"
          ]
        }
      }

      memory_reservation = floor(var.memory_ecs_api * 0.6) # Soft limit, ECS will try to reserve this much memory for the container
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = var.container_port
        dns_name = var.container_name
      }
      port_name      = var.container_name
      discovery_name = var.container_name
    }
  }

  load_balancer = {
    service = {
      target_group_arn = var.alb_target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = var.subnet_ids
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = var.alb_security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


resource "aws_service_discovery_http_namespace" "this" {
  name        = var.cluster_name
  description = "CloudMap namespace for ${var.cluster_name}"
}

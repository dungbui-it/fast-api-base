module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    # HTTP listener - redirect to HTTPS
    ex-http-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # HTTPS listener - main traffic
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
      certificate_arn = module.acm.acm_certificate_arn
      
      weighted_forward = {
        target_groups = [
          {
            target_group_key = "ex_ecs"
            weight           = 100
          }
        ]
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/health-check"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }
}

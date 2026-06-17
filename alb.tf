module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 10.0"

  name    = local.name
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  create_security_group = false
  security_groups       = [module.alb_sg.id]

  enable_deletion_protection = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "ec2"
      }
    }
  }

  target_groups = {
    ec2 = {
      name_prefix       = "ec2-"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      create_attachment = false

      health_check = {
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 10
        matcher             = "200"
      }
    }
  }

  additional_target_group_attachments = {
    ec2 = {
      target_group_key = "ec2"
      target_id        = module.ec2.id
      port             = 80
    }
  }

  tags = local.tags
}

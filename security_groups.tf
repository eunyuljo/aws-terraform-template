module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = "${local.name}-alb"
  description = "Security group for ALB - allow HTTP from internet"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from internet"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound"
    }
  }

  tags = local.tags
}

module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = "${local.name}-ec2"
  description = "Security group for EC2 - allow HTTP only from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    from_alb = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg.id
      description                  = "HTTP from ALB"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound (for SSM, yum, etc)"
    }
  }

  tags = local.tags
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = "${local.name}-rds"
  description = "Security group for RDS - allow MySQL only from EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    from_ec2 = {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.ec2_sg.id
      description                  = "MySQL from EC2"
    }
  }

  tags = local.tags
}

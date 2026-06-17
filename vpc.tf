data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["${var.region}a", "${var.region}c"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

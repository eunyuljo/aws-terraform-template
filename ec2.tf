data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_iam_role" "ec2_ssm" {
  name = "${local.name}-ec2-ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${local.name}-ec2-ssm"
  role = aws_iam_role.ec2_ssm.name

  tags = local.tags
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name = local.name

  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name
  associate_public_ip_address = false

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo "<h1>Hello from $(hostname) - ${var.environment}</h1>" > /usr/share/nginx/html/index.html
  EOT

  metadata_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tags = local.tags
}

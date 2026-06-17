module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 7.0"

  identifier = local.name

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 0
  storage_encrypted     = true

  db_name  = "appdb"
  username = "admin"
  port     = 3306

  manage_master_user_password = true

  multi_az                = false
  create_db_subnet_group  = true
  subnet_ids              = module.vpc.private_subnets
  vpc_security_group_ids  = [module.rds_sg.id]

  publicly_accessible = false

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled = false
  create_monitoring_role       = false

  tags = local.tags
}

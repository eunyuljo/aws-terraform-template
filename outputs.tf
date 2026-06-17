output "alb_dns_name" {
  description = "ALB DNS name - 브라우저로 접속 가능한 주소"
  value       = module.alb.dns_name
}

output "ec2_id" {
  description = "EC2 instance ID - SSM Session Manager 접속 시 사용"
  value       = module.ec2.id
}

output "rds_endpoint" {
  description = "RDS endpoint - EC2에서 mysql 클라이언트로 접속"
  value       = module.rds.db_instance_endpoint
}

output "rds_master_secret_arn" {
  description = "RDS master password가 저장된 Secrets Manager ARN"
  value       = module.rds.db_instance_master_user_secret_arn
}

output "ssm_connect_command" {
  description = "EC2 SSM 접속 명령"
  value       = "aws ssm start-session --target ${module.ec2.id} --region ${var.region}"
}

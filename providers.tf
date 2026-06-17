provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags
  }
}

# Terraform backend configuration
# Backend 상세 설정은 envs/<env>/backend.hcl 에서 주입:
#   terraform init -backend-config=envs/dev/backend.hcl
terraform {
  backend "s3" {}
}

# Option 2: Terraform Cloud/Enterprise (alternative)
# Delete the backend "s3" block above and uncomment the cloud block below
# to use Terraform Cloud/Enterprise
# terraform {
#   cloud {}
# }

# Note: You can only have one backend configuration active at a time.

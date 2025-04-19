terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "aws_ecr" {
  source = "../.."

  repository_name               = "demo"
  repository_type               = "private"
  image_tag_mutability          = "MUTABLE"
  scan_on_push                  = true
  force_delete                  = false
  attach_repository_policy      = true
  repository_policy             = ""
  read_only_arns                = []
  read_write_arns               = []
  create_lifecycle_policy       = true
  lifecycle_days                = 7
  tagged_image_limit            = 10
  lifecycle_policy_tag_prefixes = ["latest", "stable"]
  enable_ecr_logging            = true
  log_retention_days            = 30
  enable_replication            = false
  replication_arns              = []
  enable_scan_permissions       = false
  scan_access_arns              = []
  encryption_type               = "AES256"
  tags = {
    Name = "my-private-repo"
    Env  = "dev"
  }
}

# Outputs
output "all_module_outputs" {
  description = "All outputs from the ECR module"
  value       = module.aws_ecr
}

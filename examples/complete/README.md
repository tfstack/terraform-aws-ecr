# Terraform Module: AWS ECR

## Overview

This Terraform module provisions an **AWS Elastic Container Registry (ECR)** repository. It supports both **private and public repositories**, along with lifecycle policies, logging, and IAM access control.

## Usage

```hcl
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
  region                        = "ap-southeast-2"
  tags = {
    Name = "my-private-repo"
    Env  = "dev"
  }
}
```

## Features

- **Private & Public ECR Support** (Public repositories are limited to `us-east-1`)
- **Lifecycle Policies** to automatically remove older images
- **IAM Access Control** via read-only and read-write ARNs
- **CloudWatch Logging** for tracking image pulls & pushes
- **Image Scanning on Push**
- **ECR Replication Support** (Disabled by default)

## Outputs

```hcl
output "all_module_outputs" {
  description = "All outputs from the ECR module"
  value       = module.aws_ecr
}
```

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 4.0

## License

MIT License

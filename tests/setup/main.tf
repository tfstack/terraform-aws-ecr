terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Generate a random suffix for resource naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# IAM Role for Read-Only Access
resource "aws_iam_role" "ecr_read_only" {
  name = "ECRReadOnly-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Read-Only Access
resource "aws_iam_policy" "ecr_read_only_policy" {
  name        = "ECRReadOnlyPolicy-${random_string.suffix.result}"
  description = "Policy for read-only access to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
      Resource = "*"
    }]
  })
}

# Attach Read-Only Policy to the Role
resource "aws_iam_policy_attachment" "ecr_read_only_attach" {
  name       = "ecr-read-only-attachment-${random_string.suffix.result}"
  roles      = [aws_iam_role.ecr_read_only.name]
  policy_arn = aws_iam_policy.ecr_read_only_policy.arn
}

# IAM Role for Read-Write Access
resource "aws_iam_role" "ecr_read_write" {
  name = "ECRReadWrite-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Read-Write Access
resource "aws_iam_policy" "ecr_read_write_policy" {
  name        = "ECRReadWritePolicy-${random_string.suffix.result}"
  description = "Policy for read and write access to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"]
      Resource = "*"
    }]
  })
}

# Attach Read-Write Policy to the Role
resource "aws_iam_policy_attachment" "ecr_read_write_attach" {
  name       = "ecr-read-write-attachment-${random_string.suffix.result}"
  roles      = [aws_iam_role.ecr_read_write.name]
  policy_arn = aws_iam_policy.ecr_read_write_policy.arn
}

# Output the ARN of the IAM Roles
output "read_only_arn" {
  value = aws_iam_role.ecr_read_only.arn
}

output "read_write_arn" {
  value = aws_iam_role.ecr_read_write.arn
}

output "suffix" {
  value = random_string.suffix.result
}

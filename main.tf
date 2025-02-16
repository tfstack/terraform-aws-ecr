data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

################################################################################
# Private ECR Repository
################################################################################

resource "aws_ecr_repository" "private" {
  count = var.repository_type == "private" ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

################################################################################
# Public ECR Repository
################################################################################

resource "aws_ecrpublic_repository" "public" {
  count    = var.repository_type == "public" ? 1 : 0
  provider = aws.us_east_1

  repository_name = var.repository_name
  tags            = var.tags
}

################################################################################
# Repository Policy
################################################################################

resource "aws_ecr_repository_policy" "private_policy" {
  count = var.repository_type == "private" && var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.private[0].name
  policy     = var.repository_policy != "" ? var.repository_policy : data.aws_iam_policy_document.default[0].json
}

resource "aws_ecrpublic_repository_policy" "public_policy" {
  count    = var.repository_type == "public" && var.attach_repository_policy ? 1 : 0
  provider = aws.us_east_1

  repository_name = aws_ecrpublic_repository.public[0].repository_name
  policy          = var.repository_policy != "" ? var.repository_policy : data.aws_iam_policy_document.default[0].json
}

################################################################################
# IAM Policy Document
################################################################################

data "aws_iam_policy_document" "default" {
  count = var.attach_repository_policy ? 1 : 0

  statement {
    sid    = "AllowReadOnly"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    principals {
      type        = "AWS"
      identifiers = length(var.read_only_arns) > 0 ? var.read_only_arns : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "AllowReadWrite"
    effect = "Allow"
    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    principals {
      type        = "AWS"
      identifiers = length(var.read_write_arns) > 0 ? var.read_write_arns : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

################################################################################
# Lifecycle Policy (Only for Private Repositories)
################################################################################

resource "aws_ecr_lifecycle_policy" "private_lifecycle" {
  count = var.repository_type == "private" && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.private[0].name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Delete untagged images older than ${var.lifecycle_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.lifecycle_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Retain only ${var.tagged_image_limit} most recent tagged images with specified prefixes"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.lifecycle_policy_tag_prefixes
          countType     = "imageCountMoreThan"
          countNumber   = var.tagged_image_limit
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

################################################################################
# CloudWatch Logging for Image Pulls
################################################################################

resource "aws_cloudwatch_log_group" "ecr_logging" {
  count = var.enable_ecr_logging ? 1 : 0

  name              = "/aws/ecr/${var.repository_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_event_rule" "ecr_events" {
  count = var.enable_ecr_logging ? 1 : 0

  name        = "${var.repository_name}-ecr-events"
  description = "Capture ECR image push and pull events"
  event_pattern = jsonencode({
    source        = ["aws.ecr"],
    "detail-type" = ["ECR Image Action"],
    detail = {
      "action-type"     = ["PUSH", "PULL"],
      "repository-name" = [var.repository_name]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecr_event_target" {
  count = var.enable_ecr_logging ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecr_events[0].name
  target_id = "SendToCloudWatch"
  arn       = aws_cloudwatch_log_group.ecr_logging[0].arn
}

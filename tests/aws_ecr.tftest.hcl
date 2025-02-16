run "setup_ecr" {
  module {
    source = "./tests/setup"
  }
}

run "test_aws_ecr" {
  variables {
    repository_name               = "test-ecr-repo-${run.setup_ecr.suffix}"
    repository_type               = "private"
    image_tag_mutability          = "IMMUTABLE"
    scan_on_push                  = true
    force_delete                  = false
    attach_repository_policy      = true
    repository_policy             = "" # Default policy
    read_only_arns                = [run.setup_ecr.read_only_arn]
    read_write_arns               = [run.setup_ecr.read_write_arn]
    create_lifecycle_policy       = true
    lifecycle_days                = 7
    tagged_image_limit            = 5
    lifecycle_policy_tag_prefixes = ["release", "beta"]
    enable_ecr_logging            = true
    log_retention_days            = 14
    enable_replication            = false
    replication_arns              = []
    enable_scan_permissions       = false
    scan_access_arns              = []
    encryption_type               = "AES256"
    region                        = "ap-southeast-2"
    tags = {
      Name = "test-ecr-repo-${run.setup_ecr.suffix}"
      Env  = "test"
    }
  }

  assert {
    condition     = length(aws_ecr_repository.private[*]) == 1
    error_message = "ECR repository was not created."
  }

  assert {
    condition     = aws_ecr_repository.private[0].image_tag_mutability == "IMMUTABLE"
    error_message = "ECR repository tag mutability is not set to IMMUTABLE."
  }

  assert {
    condition     = aws_ecr_repository.private[0].encryption_configuration[0].encryption_type == "AES256"
    error_message = "ECR repository encryption type is not AES256."
  }

  assert {
    condition     = aws_ecr_repository.private[0].image_scanning_configuration[0].scan_on_push == true
    error_message = "ECR repository image scan on push is not enabled."
  }
}

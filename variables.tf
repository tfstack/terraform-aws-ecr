# ----------------------------------------
# General Configuration
# ----------------------------------------

variable "region" {
  description = "AWS region for the provider. Defaults to ap-southeast-2 if not specified."
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d{1})$", var.region))
    error_message = "Invalid AWS region format. Example: 'us-east-1', 'ap-southeast-2'."
  }
}

variable "tags" {
  description = "Tags for the ECR repository"
  type        = map(string)
  default     = {}
}

# ----------------------------------------
# ECR Repository Configuration
# ----------------------------------------

variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "repository_type" {
  description = "Type of ECR repository: 'private' or 'public'"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.repository_type)
    error_message = "repository_type must be either 'private' or 'public'."
  }
}

variable "image_tag_mutability" {
  description = "Image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either 'MUTABLE' or 'IMMUTABLE'."
  }
}

variable "scan_on_push" {
  description = "Enable scanning on image push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Force delete the repository on destroy"
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "Encryption type for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be either 'AES256' or 'KMS'."
  }
}

# ----------------------------------------
# Repository Policy Configuration
# ----------------------------------------

variable "attach_repository_policy" {
  description = "Attach a repository policy"
  type        = bool
  default     = false
}

variable "repository_policy" {
  description = "Custom repository policy JSON"
  type        = string
  default     = ""

  validation {
    condition     = can(jsondecode(var.repository_policy)) || var.repository_policy == ""
    error_message = "repository_policy must be a valid JSON string."
  }
}

variable "read_only_arns" {
  description = "List of IAM ARNs for read-only access"
  type        = list(string)
  default     = []
}

variable "read_write_arns" {
  description = "List of IAM ARNs for read/write access"
  type        = list(string)
  default     = []
}

# ----------------------------------------
# Lifecycle Policy Configuration
# ----------------------------------------

variable "create_lifecycle_policy" {
  description = "Enable lifecycle policy"
  type        = bool
  default     = false
}

variable "lifecycle_days" {
  description = "Number of days before untagged images expire"
  type        = number
  default     = 7

  validation {
    condition     = var.lifecycle_days > 0
    error_message = "lifecycle_days must be greater than 0."
  }
}

variable "tagged_image_limit" {
  description = "Number of most recent tagged images to retain"
  type        = number
  default     = 10

  validation {
    condition     = var.tagged_image_limit > 0
    error_message = "tagged_image_limit must be greater than 0."
  }
}

variable "lifecycle_policy_tag_prefixes" {
  description = "List of tag prefixes to apply lifecycle policy rules (Required when tagStatus=TAGGED)"
  type        = list(string)
  default     = ["latest"]

  validation {
    condition     = !(var.create_lifecycle_policy && var.tagged_image_limit > 0 && length(var.lifecycle_policy_tag_prefixes) == 0)
    error_message = "lifecycle_policy_tag_prefixes must have at least one tag prefix when using TAGGED status."
  }
}

# ----------------------------------------
# Logging & Monitoring
# ----------------------------------------

variable "enable_ecr_logging" {
  description = "Enable logging for image pulls and pushes to CloudWatch"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs in days"
  type        = number
  default     = 30

  validation {
    condition     = var.log_retention_days >= 1 && var.log_retention_days <= 3650
    error_message = "log_retention_days must be between 1 and 3650."
  }
}

# ----------------------------------------
# Replication Configuration
# ----------------------------------------

variable "enable_replication" {
  description = "Enable ECR image replication permissions"
  type        = bool
  default     = false
}

variable "replication_arns" {
  description = "List of IAM ARNs allowed to replicate images"
  type        = list(string)
  default     = []
}

# ----------------------------------------
# Image Scan Permissions
# ----------------------------------------

variable "enable_scan_permissions" {
  description = "Enable permissions for image scan findings"
  type        = bool
  default     = false
}

variable "scan_access_arns" {
  description = "List of IAM ARNs allowed to access scan findings"
  type        = list(string)
  default     = []
}

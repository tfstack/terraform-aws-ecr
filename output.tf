output "repository_url" {
  description = "ECR repository URL"
  value       = var.repository_type == "private" ? aws_ecr_repository.private[0].repository_url : aws_ecrpublic_repository.public[0].repository_uri
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = var.repository_type == "private" ? aws_ecr_repository.private[0].arn : aws_ecrpublic_repository.public[0].arn
}

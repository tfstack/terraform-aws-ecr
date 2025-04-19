# terraform-aws-ecr

Terraform module for managing AWS ECR repositories

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.95.0 |
| <a name="provider_aws.us_east_1"></a> [aws.us\_east\_1](#provider\_aws.us\_east\_1) | 5.95.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.ecr_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ecr_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.ecr_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.private_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.private_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_ecrpublic_repository.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository) | resource |
| [aws_ecrpublic_repository_policy.public_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_repository_policy"></a> [attach\_repository\_policy](#input\_attach\_repository\_policy) | Attach a repository policy | `bool` | `false` | no |
| <a name="input_create_lifecycle_policy"></a> [create\_lifecycle\_policy](#input\_create\_lifecycle\_policy) | Enable lifecycle policy | `bool` | `false` | no |
| <a name="input_enable_ecr_logging"></a> [enable\_ecr\_logging](#input\_enable\_ecr\_logging) | Enable logging for image pulls and pushes to CloudWatch | `bool` | `false` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Enable ECR image replication permissions | `bool` | `false` | no |
| <a name="input_enable_scan_permissions"></a> [enable\_scan\_permissions](#input\_enable\_scan\_permissions) | Enable permissions for image scan findings | `bool` | `false` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | Encryption type for the repository (AES256 or KMS) | `string` | `"AES256"` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Force delete the repository on destroy | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Image tag mutability (MUTABLE or IMMUTABLE) | `string` | `"MUTABLE"` | no |
| <a name="input_lifecycle_days"></a> [lifecycle\_days](#input\_lifecycle\_days) | Number of days before untagged images expire | `number` | `7` | no |
| <a name="input_lifecycle_policy_tag_prefixes"></a> [lifecycle\_policy\_tag\_prefixes](#input\_lifecycle\_policy\_tag\_prefixes) | List of tag prefixes to apply lifecycle policy rules (Required when tagStatus=TAGGED) | `list(string)` | <pre>[<br/>  "latest"<br/>]</pre> | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Retention period for CloudWatch logs in days | `number` | `30` | no |
| <a name="input_read_only_arns"></a> [read\_only\_arns](#input\_read\_only\_arns) | List of IAM ARNs for read-only access | `list(string)` | `[]` | no |
| <a name="input_read_write_arns"></a> [read\_write\_arns](#input\_read\_write\_arns) | List of IAM ARNs for read/write access | `list(string)` | `[]` | no |
| <a name="input_replication_arns"></a> [replication\_arns](#input\_replication\_arns) | List of IAM ARNs allowed to replicate images | `list(string)` | `[]` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | ECR repository name | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | Custom repository policy JSON | `string` | `""` | no |
| <a name="input_repository_type"></a> [repository\_type](#input\_repository\_type) | Type of ECR repository: 'private' or 'public' | `string` | `"private"` | no |
| <a name="input_scan_access_arns"></a> [scan\_access\_arns](#input\_scan\_access\_arns) | List of IAM ARNs allowed to access scan findings | `list(string)` | `[]` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Enable scanning on image push | `bool` | `true` | no |
| <a name="input_tagged_image_limit"></a> [tagged\_image\_limit](#input\_tagged\_image\_limit) | Number of most recent tagged images to retain | `number` | `10` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the ECR repository | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | ECR repository ARN |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | ECR repository URL |
<!-- END_TF_DOCS -->

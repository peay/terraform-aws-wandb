variable "namespace" {
  type        = string
  description = "Prefix to use when creating resources"
}

variable "create_kms_key" {
  description = <<EOT
    If a KMS key should be created to encrypt S3 storage bucket objects. This can only be used when you set the value of sse_algorithm as aws:kms.

    WARNING: when `create_kms_key` is false and `sse_algorithm` is `aws:kms`, the AWS-managed default S3 KMS key will be used, which is not
    recommended.

    WARNING: the key is created with the current identity as the sole principal with all permissions in the KMS key policy, instead of an
    account principal, which is not recommended.
  EOT

  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`."
  type        = string
  default     = "aws:kms"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "`sse_algorithm` should be a supported value."
  }
}

variable "deletion_protection" {
  description = "If the bucket should have deletion protection enabled."
  type        = bool
  default     = false
}

variable "aws_principal_arn" {
  description = "AWS principal that can access the bucket"
  type        = string
}


locals {
  should_create_kms_key = var.sse_algorithm == "aws:kms" && var.create_kms_key
}
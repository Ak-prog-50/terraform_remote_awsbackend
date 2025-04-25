variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file."
  type        = string
  sensitive = true
}

variable "table_name" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "ddb_deletion_protection" {
  description = "Enable deletion protection for the DynamoDB table."
  type        = bool
  default     = true
}

variable "s3_force_destroy" {
  description = "Force destroy the S3 bucket."
  type        = bool
  default     = false
}

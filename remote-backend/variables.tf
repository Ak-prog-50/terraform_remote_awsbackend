variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "smata-pipeline0" # REPLACE WITH YOUR PROJECT NAME
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file."
  type        = string
  default     = "smata-pipeline0-tf-state" # REPLACE WITH YOUR BUCKET NAME
}

variable "table_name" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
  default     = "smata-pipeline0-tf-state-locking" # REPLACE WITH YOUR TABLE NAME
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}
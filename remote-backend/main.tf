terraform {
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU SHOULD UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  backend "s3" {
    bucket         = "REPLACE WITH YOUR BUCKET NAME" # REPLACE WITH YOUR BUCKET NAME
    key            = "YOUR_PROJECT_NAME/bootstrap-remotebackend/terraform.tfstate"
    region         = "AWS_REGION_IN_VARIABLES.TF"
    dynamodb_table = "REPLACE WITH YOUR TABLE NAME" # REPLACE WITH YOUR TABLE NAME
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  force_destroy = false # when this is set to true, u can destroy this remote backend using `terraform destroy`
  lifecycle {
    prevent_destroy = true # when true terraform rejects destroy of this resource
  }
  tags = {
    Project =var.project_name
  }
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true # when true terraform rejects destroy of this resource
  }

  tags = {
    Project =var.project_name
  }
}

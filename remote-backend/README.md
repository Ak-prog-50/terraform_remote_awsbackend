# Terraform Remote Backend Setup

This 

### Author

A.Kal ( [@ak-prog-50](https://github.com/ak-prog-50) )

## Overview

The remote backend configuration in this project:
- Uses an S3 bucket to store Terraform state files
- Uses DynamoDB for state locking to prevent concurrent operations
- Enables versioning on the S3 bucket for state history
- S3 bucket's encrypttion is default SSE-S3

## Prerequisites

- AWS CLI installed and configured with appropriate credentials
- Terraform >= 1.0.0 installed

## Setup Instructions

### 1. Initialize the Remote Backend Infrastructure

First, we need to create the S3 bucket and DynamoDB table that will store our state:

```bash
# Navigate to the remote-backend directory
cd remote-backend
```

1. Replace variable names in `variables.tf` with your own values.
2. Make sure remote backend configuration in `main.tf` is commented out.

```bash
# Initialize Terraform (this will use local state initially)
terraform init

# Apply the configuration to create the S3 bucket and DynamoDB table
terraform apply
```

3. Uncomment the remote backend configuration and replace your own values in bucket, key, region and dynamodb_table.

```hcl
  backend "s3" {
    bucket         = "REPLACE WITH YOUR BUCKET NAME" # REPLACE WITH YOUR BUCKET NAME
    key            = "YOUR_PROJECT_NAME/bootstrap-remotebackend/terraform.tfstate"
    region         = "AWS_REGION_IN_VARIABLES.TF"
    dynamodb_table = "REPLACE WITH YOUR TABLE NAME" # REPLACE WITH YOUR TABLE NAME
    encrypt        = true
  }
```

```bash
# The AWS remote backend is already configured in the main.tf file
# Re-initialize Terraform to migrate local state to remote
terraform init

# Confirm the state migration when prompted

# Local .tfstate file should be empty and can be deleted
rm terraform.tfstate
```

### 2. Verify the Remote Backend
After the migration, you can verify that the remote backend is working correctly by running:

```bash
# Check the current state
terraform state list
```

### 3. Clean Up
To clean up the resources created for the remote backend, first check,
 `force_destroy` setting of s3 bucket and `prevent_destroy` terraform lifecycle rule of s3 and dynamodb.
If `force_destroy` is set to false, you need to manually delete the objects in the bucket before destroying the infrastructure.
If `prevent_destroy` is set to true, you need to remove the lifecycle block from the resource before destroying. 

```bash
# ( Optional) Run terraform apply if `force_destroy` or `prevent_destroy` got changed
terraform apply

# Comment out the remote backend configuration in main.tf
# Re-initialize Terraform to use local state. ( Otherwise, s3 bucket and ddb will get deleted, but you will get an errored.tf file. )
terraform init 

# Destroy the remote backend infrastructure
terraform destroy
```



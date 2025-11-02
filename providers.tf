terraform {
    required_version = ">= 1.2.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    # For production: configure an s3 backend + dynamodb locking
    # backend "s3" {
    #   bucket = "my-terraform-state-bucket"
    #   key    = "monitoring/terraform.tfstate"
    #   region = "us-east-1"
    #   dynamodb_table = "terraform-locks"
    # }
}

provider "aws" {
    region = var.aws_region
}
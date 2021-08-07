#Set the required terraform and provider versions.
terraform {
  required_version = "~> 1.00"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.37"
    }
  }
}

#Define the region.
provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = var.region
}
terraform {
  /* backend "s3" {
    bucket         = "s3statebackend12"
    dynamodb_table = "db-statelock-test1"
    key            = "key"
    region         = "us-east-1"
    encrypt        = true
  } */
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


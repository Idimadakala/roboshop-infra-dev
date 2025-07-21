terraform {
  required_providers {
     aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
  backend "s3" {
    bucket       = "roboshop-infra-joindevsecops-dev"
    key          = "module-component-user-test"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}
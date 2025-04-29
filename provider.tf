terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"

    }
  }

  backend "s3" {
    bucket       = "descomplicando-terraform-gomex"
    key          = "terraform/environment/dev/state.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}
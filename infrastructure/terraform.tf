terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "igork_aws"
  default_tags {
    tags = {
      Owner = "Igor Kostin"
    }
  }
  #   region = "eu-central-1"
}

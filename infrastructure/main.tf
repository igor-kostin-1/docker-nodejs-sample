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
}

module "vpc" {
  source = "./module/vpc"

  vcp_base_cider_block = var.vpc_cidr_block
}




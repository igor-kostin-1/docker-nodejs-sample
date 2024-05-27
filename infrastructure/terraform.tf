terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
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

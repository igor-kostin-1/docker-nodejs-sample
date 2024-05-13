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
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "igork_aws"
  default_tags {
    tags = {
      Owner = "Igor Kostin"
    }
  }
}

locals {
  subnet_prefix_name = {
    public  = "public_SUBENT_${var.owner_code_name}_${var.vpc_version}"
    private = "private_SUBENT_${var.owner_code_name}_${var.vpc_version}"
    db      = "db_SUBENT_${var.owner_code_name}_${var.vpc_version}"
  }

  subnet_cider_bits = {
    public  = 8
    private = 2
    db      = 8
  }

  vpc_cider_block = var.vpc_cidr_block
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

module "public_subnet_cider_blocks" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr_block

  networks = [
    {
      name     = "${local.subnet_prefix_name.private}_${var.azs[0]}"
      new_bits = tonumber(local.subnet_cider_bits.private)
    },
    {
      name     = "${local.subnet_prefix_name.private}_${var.azs[1]}"
      new_bits = tonumber(local.subnet_cider_bits.private)
    },
    {
      name     = "${local.subnet_prefix_name.private}_${var.azs[2]}"
      new_bits = tonumber(local.subnet_cider_bits.private)
    },
    {
      name     = "${local.subnet_prefix_name.db}_${var.azs[0]}"
      new_bits = tonumber(local.subnet_cider_bits.db)
    },
    {
      name     = "${local.subnet_prefix_name.db}_${var.azs[1]}"
      new_bits = tonumber(local.subnet_cider_bits.db)
    },
    {
      name     = "${local.subnet_prefix_name.db}_${var.azs[2]}"
      new_bits = tonumber(local.subnet_cider_bits.db)
    },
    {
      name     = "${local.subnet_prefix_name.public}_${var.azs[0]}"
      new_bits = tonumber(local.subnet_cider_bits.public)
    },
    {
      name     = "${local.subnet_prefix_name.public}_${var.azs[1]}"
      new_bits = tonumber(local.subnet_cider_bits.public)
    },
    {
      name     = "${local.subnet_prefix_name.public}_${var.azs[2]}"
      new_bits = tonumber(local.subnet_cider_bits.public)
    }
  ]
}

locals {

  subnets = {
    public_subnet_cider = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : v if can(regex("^${local.subnet_prefix_name.public}.*", k))]
    public_subnet_name  = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : k if can(regex("^${local.subnet_prefix_name.public}.*", k))]

    db_subnet_cider = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : v if can(regex("^${local.subnet_prefix_name.db}.*", k))]
    db_subnet_name  = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : k if can(regex("^${local.subnet_prefix_name.db}.*", k))]

    private_subnet_cider = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : v if can(regex("^${local.subnet_prefix_name.private}.*", k))]
    private_subnet_name  = [for k, v in module.public_subnet_cider_blocks.network_cidr_blocks : k if can(regex("^${local.subnet_prefix_name.private}.*", k))]
  }
}



resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = "EIP_vpc_nat_gateway_igork_01"
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC_${var.owner_code_name}_${var.vpc_version}"
  cidr = var.vpc_cidr_block

  enable_nat_gateway = true
  single_nat_gateway = true
  reuse_nat_ips = true
  external_nat_ip_ids = aws_eip.nat_gateway.*.id

  create_database_subnet_group = false

  azs                   = var.azs
  public_subnets        = local.subnets.public_subnet_cider
  public_subnet_names   = local.subnets.public_subnet_name
  database_subnets      = local.subnets.db_subnet_cider
  database_subnet_names = local.subnets.db_subnet_name
  private_subnets       = local.subnets.private_subnet_cider
  private_subnet_names  = local.subnets.private_subnet_name

  create_database_internet_gateway_route = true
  create_database_nat_gateway_route = false
  create_database_subnet_route_table = false

  create_igw = true

  igw_tags = { Name = "IGW_${var.owner_code_name}_${var.vpc_version}" }
  private_route_table_tags = { Name = "private_RT_${var.owner_code_name}_${var.vpc_version}" }
  public_route_table_tags = { Name = "public_RT_${var.owner_code_name}_${var.vpc_version}"}
  nat_gateway_tags = { Name = "NAT_GW_${var.owner_code_name}_${var.vpc_version}"}

}

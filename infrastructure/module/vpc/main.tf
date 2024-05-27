data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_cider_blocks" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vcp_base_cider_block
  networks        = [
    {
      name     = "private_subnet_igork_1a"
      new_bits = 2
    },
    {
      name     = "private_subnet_igork_1b"
      new_bits = 2
    },
    {
      name     = "private_subnet_igork_1c"
      new_bits = 2
    },
    {
      name     = "db_subnet_igork_1a"
      new_bits = 8
    },
    {
      name     = "db_subnet_igork_1b"
      new_bits = 8
    },
    {
      name     = "db_subnet_igork_1c"
      new_bits = 8
    },
    {
      name     = "public_subnet_igork_1a"
      new_bits = 8
    },
    {
      name     = "public_subnet_igork_1b"
      new_bits = 8
    },
    {
      name     = "public_subnet_igork_1c"
      new_bits = 8
    }
  ]
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = "EIP_vpc_nat_gateway"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC_igork"
  cidr = var.vcp_base_cider_block

  enable_nat_gateway  = true
  single_nat_gateway  = true
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat_gateway.*.id

  create_database_subnet_group = true

  azs = data.aws_availability_zones.available.names

  public_subnets = [
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "public_subnet_igork_1a"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "public_subnet_igork_1b"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "public_subnet_igork_1c")
  ]
  public_subnet_names = ["public_subnet_igork_1a", "public_subnet_igork_1b", "public_subnet_igork_1c"]
  database_subnets    = [
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "db_subnet_igork_1a"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "db_subnet_igork_1b"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "db_subnet_igork_1c")
  ]
  database_subnet_names = ["db_subnet_igork_1a", "db_subnet_igork_1b", "db_subnet_igork_1c"]
  private_subnets       = [
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "private_subnet_igork_1a"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "private_subnet_igork_1b"),
    lookup(module.subnet_cider_blocks.network_cidr_blocks, "private_subnet_igork_1c")
  ]
  private_subnet_names = ["private_subnet_igork_1a", "private_subnet_igork_1b", "private_subnet_igork_1c"]

  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false
  create_database_subnet_route_table     = false

  create_igw = true # Explicitly specifying usage of internet gateway

  # Configure Tags(Name) for resources
  igw_tags = { Name = "IGW_igork" }
  private_route_table_tags = { Name = "private_RT_igork" }
  public_route_table_tags = { Name = "public_RT_igork" }
  nat_gateway_tags = { Name = "NAT_GW_igork" }


  public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }


}
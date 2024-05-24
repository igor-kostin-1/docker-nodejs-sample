module "vpc" {
  source = "./module/vpc"

  vcp_base_cider_block = var.vpc_cidr_block
}

module "iam" {
  source = "./module/iam"
}

module "eks" {
  source = "./module/eks"

  node_subnets_id = module.vpc.private_subnets
  control_subnets_id = module.vpc.private_subnets
  vpc_id = module.vpc.id
}

module "pv-pvc" {
  source = "./module/pv-pvc"
}
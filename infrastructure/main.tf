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
  vpc_id = module.vpc.id
}

module "psql" {
  source = "./module/database"

  eks_cluster_name = module.eks.eks_cluster_name

  password = var.db_password // secret db password is passed as evn
}
module "vpc" {
  source = "./module/vpc"

  vcp_base_cider_block = var.vpc_cidr_block
}

module "iam" {
  source = "./module/iam"
}

module "eks" {
  source = "./module/eks"

  hosted_zone_name = "omega.devops.sitesstage.com"
  node_subnets_id  = module.vpc.private_subnets
  vpc_id           = module.vpc.id
}

module "psql" {
  source = "./module/database"

  eks_cluster_name = module.eks.eks_cluster_name
}

module "app" {
  source             = "./module/app"
  secret_manager_arn = module.psql.secret_manager_arn
}

module "dns" {
  source = "./module/dns"

  created = module.app
  hosted_zone_name   = "omega.devops.sitesstage.com"
}
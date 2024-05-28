module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name    = "igork-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_iam_role.iam_role_arn
    }
  }
  create_iam_role = true

  cluster_endpoint_public_access_cidrs = ["82.117.210.2/32"]

  vpc_id                   = var.vpc_id
  subnet_ids               = var.node_subnets_id

  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    disk_size     = 50,
    instance_type = ["t3.small"]
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1 // desired number of nodes
      min_size = 1 // minimum number of nodes
      max_size = 10 // maximum number of nodes

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      ami_type = "BOTTLEROCKET_x86_64"

      // Role for eks
      create_iam_role          = true
      iam_role_name            = "EKSManagedNodeGroup-Role-igork"
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group complete example role"
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }


}
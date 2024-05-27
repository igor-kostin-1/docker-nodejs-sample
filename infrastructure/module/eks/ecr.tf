module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  repository_type = "private"
  repository_name = "ecr-igork-private"
  create_lifecycle_policy = false
}
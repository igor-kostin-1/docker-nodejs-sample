
module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.39.0"

  name = "GitHubActions_POLICY_igork"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage"
            ],
            "Resource": "*"
        },
        {
            "Effect" : "Allow",
            "Action" : [
              "eks:DescribeCluster",
              "eks:ListClusters",
              "eks:AccessKubernetesApi",
              "sts:AssumeRole"
            ],
            "Resource" : "*"
        }
    ]
  }
  EOF
}

module "iam_iam-assumable-role-with-oidc" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "5.39.0"
  create_role = true

  role_name = "GitHubAction-RoleWithActions-igork-01"


  role_policy_arns = [module.iam_policy.arn]

  provider_url                   = module.iam_github_oidc_provider.url
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  oidc_subjects_with_wildcards   = ["repo:igor-kostin-1/docker-nodejs-sample:*"]
}
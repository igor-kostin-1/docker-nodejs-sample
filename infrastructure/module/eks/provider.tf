data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}


data "aws_eks_cluster_auth" "default" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = [
        "eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.id,
      ]
    }
  }
}
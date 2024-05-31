resource "helm_release" "ecr-igork-private" {
  name       = "ecr-igork-private"
  repository = "oci://${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-central-1.amazonaws.com"
  chart      = "ecr-igork-private"
  version    = "0.1.1"

  namespace = "vegait-training"

  create_namespace = false

  set {
    name  = "serviceAccount.create"
    value = false
  }

  values = [
    file("/home/igorkostin/Project/devops/docker-nodejs-sample/infrastructure/module/app/_values.yaml")
  ]

}
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

  set {
    name  = "image.repository"
    value = "ghcr.io/igor-kostin-1/docker-nodejs-sample"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "image.pullPolicy"
    value = "IfNotPresent"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "service.port"
    value = "3000"
  }

  set_sensitive {
    name  = "postgresql.host"
    value = lookup(jsondecode(sensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\""))), "host", "host")
  }

  set_sensitive {
    name  = "postgresql.user"
    value = lookup(jsondecode(sensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\""))), "username", "user")
  }

  set_sensitive {
    name  = "postgresql.password"
    value = lookup(jsondecode(sensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\""))), "password", "password")
  }

  set_sensitive {
    name  = "postgresql.database"
    value = lookup(jsondecode(sensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\""))), "database", "db")
  }

  set_sensitive {
    name  = "postgresql.port"
    value = lookup(jsondecode(sensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\""))), "port", 5432)
  }
}
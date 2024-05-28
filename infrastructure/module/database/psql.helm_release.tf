data "aws_secretsmanager_secret" "psql_db" {
  arn = module.secrets-manager.secret_arn
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.psql_db.id
}

locals {
  secret_data = jsondecode(nonsensitive(trim(data.aws_secretsmanager_secret_version.current.secret_string, "\"")))
}

output "secret_string" {
  value = nonsensitive(local.secret_data)
}

resource "helm_release" "psql" {
  name       = "psql-database"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.4.0"
  namespace  = "vegait-training"

  count = 1

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "primary.persistence.enabled"
    value = true
  }

  set {
    name  = "primary.persistence.volumeName"
    value = "igorkvolume"
  }

  set {
    name  = "primary.persistence.storageClass"
    value = "ebssc"
  }

  set {
    name  = "primary.persistence.size"
    value = "8Gi"
  }

  set {
    name  = "auth.username"
    value = lookup(local.secret_data, "username", "user") //kubernetes_config_map.example.data.POSTGRESQL_USERNAME
  }

  set {
    name  = "auth.password"
    value = lookup(local.secret_data, "password", "password") //kubernetes_secret.example.data.POSTGRESQL_PASSWORD
  }

  set {
    name  = "auth.database"
    value = lookup(local.secret_data, "database", "db")
  }

  set {
    name  = "primary.service.ports.postgresql"
    value = lookup(local.secret_data, "port", 5432) //kubernetes_config_map.example.data.POSTGRESQL_PORT_NUMBER
  }

}
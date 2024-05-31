data "aws_secretsmanager_secret" "psql_db" {
  arn = var.secret_manager_arn
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.psql_db.id
}

data "aws_caller_identity" "current" {}
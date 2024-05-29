data "aws_caller_identity" "current" {}

module "secrets-manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.2"

  name_prefix = "psql-db"
  description = "Example Secrets Manager secret"

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid        = "AllowAccountRead"
      principals = [
        {
          type        = "AWS"
          identifiers = [data.aws_caller_identity.current.arn]
        }
      ]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }
  ignore_secret_changes = true
  secret_string = jsonencode({
    username = ""
    password = ""
    database = "",
    port     = ""
  })
}


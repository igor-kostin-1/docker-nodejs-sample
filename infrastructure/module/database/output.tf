output "secret_manager_arn" {
  description = "Secret manager arn"
  value = module.secrets-manager.secret_arn
}
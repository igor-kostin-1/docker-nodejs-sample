output "private_subnets" {
  description = "List of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnets"
  value = module.vpc.public_subnets
}

output "id" {
  value = module.vpc.vpc_id
}
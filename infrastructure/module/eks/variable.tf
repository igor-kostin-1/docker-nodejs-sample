
variable "node_subnets_id" {
  description = "Subnets Id used for creation of the EKS cluster"
  type = list(string)
}

variable "control_subnets_id" {
  description = "Subnets Id used for creation of the EKS cluster"
  type = list(string)
}

variable "vpc_id" {
  description = "Subnets Id used for creation of the EKS cluster"
  type = string
}
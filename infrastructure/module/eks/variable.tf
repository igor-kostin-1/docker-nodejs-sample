
variable "node_subnets_id" {
  description = "Subnets Id used for creation of the EKS cluster"
  type = list(string)
}

variable "vpc_id" {
  description = "Subnets Id used for creation of the EKS cluster"
  type = string
}

variable "hosted_zone_name"{
  description = "Hosted zone name."
  type = string
}

variable "region" {
  description = "Region used for creating the EKS cluster"
  type = string
}
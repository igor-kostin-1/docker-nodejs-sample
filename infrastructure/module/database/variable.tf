variable "eks_cluster_name" {
  description = "The name of the cluster, used for creating database."
  type = string
}

# variable "username"{
#   description = "The name of the user, used in database."
#   type = string
# }
#
# variable "db"{
#   description = "Database name."
#   type = string
# }
#
variable "password"{
  description = "Password for the user, used in database."
  type = string
}
#
# variable "port" {
#   description = "Port for the database."
#   type = number
# }
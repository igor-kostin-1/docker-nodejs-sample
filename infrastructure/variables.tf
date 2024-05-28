
variable vpc_cidr_block {
  description = "Base cider block for main vpc"
  default = "172.17.0.0/16"
}

variable "db_password"{
  description = "Password for the user, used in database."
  type = string
}
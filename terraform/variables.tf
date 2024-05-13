variable vpc_cidr_block {
  description = "Base cider block for main vpc"
  default = "172.17.0.0/16"
}

variable owner_code_name {
  description = "Code name for owner"
  default = "igork"
}

variable owner_label {
  description = "Label for owner"
  default = "Igor Kostin"
}

variable "vpc_version" {
  default = "02"
}
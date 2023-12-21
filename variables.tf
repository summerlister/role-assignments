variable "role_assignment" {
  default = {}
}

variable "role_assign_scope" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "role_assign_principal_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "role_assign_condition_version" {
  default = "2.0"
}

variable "role_assign_condition" {
  default = true
}

variable "role_assign_role_definition_name" {
  default = "User Access Administrator"
}

variable "role_assign_role_definition" {
  default = {
    AcrDelete = {
      name = "AcrDelete"
    }
    AcrPull = {
      name = "AcrPull"
    }
    AcrPush = {
      name = "AcrPush"
    }
  }
}


variable "pim_eligible_role_assignment" {
  default = {}
}

variable "pim_scope" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "pim_role_definition" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "pim_principal_id" {
  default = "00000000-0000-0000-0000-000000000000"
}
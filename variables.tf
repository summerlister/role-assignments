variable "subscription_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "principal_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "condition_version" {
  default = "2.0"
}

variable "role_definition_name" {
  default = "User Access Administrator"
}

variable "condition" {
  default = null
}
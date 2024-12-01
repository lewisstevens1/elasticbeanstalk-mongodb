variable "environment" {
  type = string

  validation {
    error_message = "Only dev and prod environments are allowed."
    condition     = can(regex("^(dev|prod)$", var.environment))
  }
}

variable "resource_prefix" {
  type = string

  validation {
    error_message = "The resource_prefix must start with a lowercase letter."
    condition     = can(regex("^[a-z]", var.resource_prefix))
  }
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"

  validation {
    error_message = "The cidr_block must be in the form x.x.x.x/16."
    condition     = can(regex("^([0-9]{1,3}.){3}[0-9]{1,3}/16$", var.cidr_block))
  }
}

variable "number_of_azs" {
  type    = number
  default = 2
}

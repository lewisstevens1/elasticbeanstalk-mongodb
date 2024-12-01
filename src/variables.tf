variable "environment" {
  type = string

  validation {
    error_message = "Only dev and prod environments are allowed."
    condition     = can(regex("^(dev|prod)$", var.environment))
  }
}

variable "account_id" {
  # Account ids have to be string due to some being prefixed with 0.
  type = string
}

variable "resource_prefix" {
  type    = string
  default = "exmpl"
}

variable "region" {
  type    = string
  default = "eu-west-2"

  validation {
    error_message = "Invalid region specified. The region must be either eu-west-2 (London) or us-east-1 (N. Virginia)."
    condition     = can(regex("^(eu-west-2|us-east-1)$", var.region))
  }
}

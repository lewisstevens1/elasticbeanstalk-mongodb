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

variable "solution_stack_name" {
  type    = string
  default = "64bit Amazon Linux 2023 v6.4.0 running Node.js 22"
}

variable "tier" {
  type    = string
  default = "WebServer"
}

variable "vpc_id" {
  type = string

  validation {
    error_message = "The VPC ID must be a valid identifier starting with 'vpc-'."
    condition     = startswith(var.vpc_id, "vpc-")
  }
}

variable "private_subnets" {
  type = map(string)

  validation {
    error_message = "Invalid private_subnets configuration. The map keys must be valid subnet IDs starting with 'subnet-' and the values must be valid IPv4 addresses in format xxx.xxx.xxx.xxx/xx"

    condition = alltrue(
      concat(
        [
          for subnet in keys(var.private_subnets) : startswith(subnet, "subnet-")
        ],
        [
          for cidr in values(var.private_subnets) : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", cidr))
        ]
      )
    )
  }
}

variable "public_subnets" {
  type = map(string)

  validation {
    error_message = "Invalid public_subnets configuration. The map keys must be valid subnet IDs starting with 'subnet-' and the values must be valid IPv4 addresses in format xxx.xxx.xxx.xxx/xx"

    condition = alltrue(
      concat(
        [
          for subnet in keys(var.public_subnets) : startswith(subnet, "subnet-")
        ],
        [
          for cidr in values(var.public_subnets) : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", cidr))
        ]
      )
    )
  }
}

variable "s3_bucket_prefix" {
  default = "ls-test-bucket-"

  validation {
    error_message = "The S3 bucket prefix must start with a lowercase letter and end with a hyphen."
    condition     = can(regex("^[a-z][a-z0-9\\-]*-$", var.s3_bucket_prefix))
  }
}

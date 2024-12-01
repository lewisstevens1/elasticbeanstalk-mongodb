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

variable "vpc_id" {
  type = string

  validation {
    error_message = "The VPC ID must be a valid identifier starting with 'vpc-'."
    condition     = startswith(var.vpc_id, "vpc-")
  }
}

variable "r53_zone_id" {
  type = string

  validation {
    error_message = "The Route 53 zone ID must be a valid identifier starting with 'Z'."
    condition     = startswith(var.r53_zone_id, "Z")
  }
}

variable "public_route_table_id" {
  type = string

  validation {
    error_message = "Invalid route table ID. The value must be a valid AWS route table identifier starting with 'rtb-'. Please provide a valid route table ID from your AWS account."
    condition     = startswith(var.public_route_table_id, "rtb-")
  }
}

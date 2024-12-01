locals {
  remote_backend = "local"
  # Disabled as for an example there is no need to implement a backend at all.
  # remote_backend  = tobool(get_env("DISABLE_BACKEND", "false")) ? "local": "s3"

  remote_state_config = {
    local = {
      path = format("%s/terraform.tfstate", get_original_terragrunt_dir())
    }

    # s3 = {
    #   disable_bucket_update = true
    #   bucket                = format("%s-state-bucket", local.resource_prefix)
    #   key                   = format("accounts/%s/terraform.tfstate", local.account_id)
    #   region                = local.region
    #   encrypt               = true
    #   dynamodb_table        = format("%s-state-lockdb", local.resource_prefix)
    #   profile               = local.profile
    # }
  }

  region = "eu-west-2"
}

remote_state {
  generate = {
    if_exists = "overwrite_terragrunt"
    path      = "backend.tf"
  }

  backend = local.remote_backend
  config  = local.remote_state_config[local.remote_backend]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"

  contents  = <<EOF
terraform {
  required_version = "1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

provider "aws" {
  region  = "${local.region}"
}
EOF
}

generate "paths" {
  path      = "paths.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
find_in_parent_folders = "${find_in_parent_folders()}"
path_relative_to_include = "${path_relative_to_include()}"
path_relative_from_include = "${path_relative_from_include()}"
get_repo_root = "${get_repo_root()}"
get_path_from_repo_root = "${get_path_from_repo_root()}"
get_path_to_repo_root = "${get_path_to_repo_root()}"
get_terragrunt_dir = "${get_terragrunt_dir()}"
get_parent_terragrunt_dir = "${get_parent_terragrunt_dir()}"
get_original_terragrunt_dir = "${get_original_terragrunt_dir()}"
}
EOF
}

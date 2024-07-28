locals {
  # ENV
  env_regex = "live/([^/]+)/"
  aws_env   = try(regex(local.env_regex, get_terragrunt_dir())[0], "unknown")
  # Application
  app_name  = "rvs"

  # AWS Organizations Accounts
  account_mapping = {
    dev             = "497503349557"
    prd             = "445525869619"
    shared-services = "431021103958"
  }
  # IAM Roles to Assume
  account_role_name = "apps-terraform-execution-role" # <--- Role to Assume
  # Region and Zones
  region = "us-east-1"
}


remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "tf-terraform-state-shared-services-${local.app_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    profile        = "shared-services" #<----- AWS profile
    encrypt        = true
    dynamodb_table = "shared-services-lock-table-rvs"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "shared-services" #<----- AWS profile
  allowed_account_ids = [
    "${local.account_mapping[local.aws_env]}"
  ]
  assume_role {
    role_arn = "arn:aws:iam::${local.account_mapping[local.aws_env]}:role/${local.account_role_name}"
  }
  default_tags {
    tags = {
      Environment = "${local.aws_env}"
      ManagedBy   = "terraform"
      DeployedBy  = "terragrunt"
      Creator     = "${get_env("USER", "NOT_SET")}"
      Application = "${local.app_name}"
    }
  }
}
EOF
}

inputs = {
  environment    = local.aws_env,
  aws_account_id = local.account_mapping[local.aws_env]
}
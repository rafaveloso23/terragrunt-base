include {
    path = find_in_parent_folders("terragrunt.hcl")
}

# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=5.8.1".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.8.1"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  name = "my-vpc-terragrunt-dev"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24"]
  public_subnets  = ["10.1.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    IAC = "true"
    Environment = "dev"
  }
}
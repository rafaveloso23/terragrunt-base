include {
    path = find_in_parent_folders("terragrunt.hcl")
}

# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=5.8.1".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source  = "tfr:///terraform-aws-modules/ec2-instance/aws?version=5.5.0"
}

dependency "vpc" {
  config_path = "../networking"
}

dependency "key_instance" {
  config_path = "../keys"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  name = "single-instance-prd"
  instance_type          = "t2.micro"
  key_name               = dependency.key_instance.outputs.key_pair_name
  vpc_security_group_ids = [dependency.vpc.outputs.default_security_group_id]
  subnet_id              = dependency.vpc.outputs.public_subnets[0]
}

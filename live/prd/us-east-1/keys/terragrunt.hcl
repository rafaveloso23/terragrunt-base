include {
    path = find_in_parent_folders("terragrunt.hcl")
}

# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=5.8.1".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source  = "tfr:///terraform-aws-modules/key-pair/aws?version=2.0.3"
}

inputs = {
  key_name = "ec2-instance-prd-01"
  public_key = file("~/.ssh/id_rsa.pub")
}
# setting
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
/*
terraform block define the setting, which providers must be installed beforehand(using "terraform init"),
after init these will be stored in file ./terraform
source is where to find the provider code, hashicorp/aws is short for registry.terraform.io/hashicorp/aws(hostname/namespace/provider)
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# which setting terraform use to interact with the provider infrastructure
provider "aws" {
  profile = "FYP"
  region  = "us-east-1"
}

/*
TO see what will be created, use "terraform plan".
TO create the resources, use "terraform apply", add "-auto-approve" to skip approval, this will create resources and file named "terraform.tfstate".
The state files track what is on cloud and do compare when "terraform apply", to know what need to be done.
To delete everything, use "terraform destroy".
*/
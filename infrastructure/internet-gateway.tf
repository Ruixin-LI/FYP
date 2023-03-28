# Resource: aws_internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

/*
if mannually created, can log the information of resoureces as data.
data [resource] [name]{
    id = ""
}
if created in tf, can use [resource].[name].id to reference 
*/

resource "aws_internet_gateway" "main" {
  # The VPC ID to create in, do not need meta-module "depend-on" because tf infer the dependency
  vpc_id = aws_vpc.main.id

  # A map of tags to assign to the resource.
  tags = {
    Name = "FYP"
  }
}
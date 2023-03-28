# Resource: aws_vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "main" {
  # The CIDR block for the VPC
  # http://www.faqs.org/rfcs/rfc1918.html, because of the size, choose the 16-bit block, if grows, can sitch to larger blocks.
  cidr_block = "192.168.0.0/16"

  # Makes your instances shared on the host, default is cheaper.
  instance_tenancy = "default"

  # because nodes need to be registered to cluster through DNS server, must Enable DNS hostname and resolution support in the VPC.
  enable_dns_support = true
  enable_dns_hostnames = true

  # A map of tags to assign to the resource.
  tags = {
    Name = "FYP"
  }
}

# what will be shown in console after creation, so the ids can be directly logged instead of going to AWS console
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id."
  # Setting an output value as sensitive prevents Terraform from showing its value in plan and apply.
  sensitive = false
}
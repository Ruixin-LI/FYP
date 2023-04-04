# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

/*
For high availability, there is two public subnets and two private subnets seperated into two availablity zones, so that one AZ is down, the service is still available
A pair of public and private subnet is in an AZ, so that only machines in public network is open to public, 
The applications will be in private subnet and access internet via NAT gateway, and NAT gateway is in public subnet associate with elastic ip.
*/

resource "aws_subnet" "public_1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.0.0/18"

  # The AZ for the subnet.
  availability_zone = "us-east-1a"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "FYPpublic-us-east-1a"
    "kubernetes.io/cluster/FYP" = "shared" # neccary for the subnet to be discuvered by cluster
    "kubernetes.io/role/elb"    = 1 # for load balancer
  }
}

resource "aws_subnet" "public_2" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.64.0/18"

  # The AZ for the subnet.
  availability_zone = "us-east-1b"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "FYPpublic-us-east-1b"
    "kubernetes.io/cluster/FYP" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "private_1" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.128.0/18"

  # The AZ for the subnet.
  availability_zone = "us-east-1a"

  # A map of tags to assign to the resource.
  tags = {
    Name                              = "FYPprivate-us-east-1a"
    "kubernetes.io/cluster/FYP"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private_2" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.192.0/18"

  # The AZ for the subnet.
  availability_zone = "us-east-1b"

  # A map of tags to assign to the resource.
  tags = {
    Name                              = "FYPprivate-us-east-1b"
    "kubernetes.io/cluster/FYP"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

/*
The private and public does not have affect here, it will be literal after associate route table with these subnets.
*/
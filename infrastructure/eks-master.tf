# Resource: aws_iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
/*
we need roles to create the master and slave clusters, and only the role will have access to it, but we can later add permisson
so first define what resource can assume the role, this can be done using inline(in slave file) or data object(in master file)
then attach policies to the role, the attachment is also a resource
*/
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  # The name of the role
  name = "eks-cluster"

  # The policy that grants an entity permission to assume the role.
  # Used to access AWS resources that you might not normally have access to.
  # The role that Amazon EKS will use to create AWS resources for Kubernetes clusters
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Resource: aws_iam_role_policy_attachment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  # The ARN of the policy you want to apply
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # The role the policy should be applied to
  role = aws_iam_role.eks_cluster.name
}

# Resource: aws_eks_cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
# require: name role vpc
resource "aws_eks_cluster" "control-plane" {
  # Name of the cluster.
  name = "FYP"

  /*
  The Amazon Resource Name (ARN) of the IAM role that provides permissions for 
  the Kubernetes control plane to make calls to AWS API operations on your behalf
  */
  role_arn = aws_iam_role.eks_cluster.arn

  # Desired Kubernetes master version
  # version = "1.26"

  vpc_config {
    # Indicates whether or not the Amazon EKS private API server endpoint is enabled
    endpoint_private_access = false

    # Indicates whether or not the Amazon EKS public API server endpoint is enabled
    endpoint_public_access = true

    # Must be in at least two different availability zones
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  # need depend on because there is no explicit usage of the resource
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}
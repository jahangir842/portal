provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "portal_cluster" {
  name     = "portal-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
  }
}

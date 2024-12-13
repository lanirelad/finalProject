# Provision AWS resources for EKS cluster


# Security Group for EKS Control Plane
resource "aws_security_group" "eks_sg" {
  name        = "eks-cluster-sg"
  description = "Allow access to EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow access within VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS Control Plane SG"
  }
}

# EKS Cluster Configuration
module "eks_cluster" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "20.31.0"
  cluster_name     = var.eks_cluster_name
  cluster_version  = "1.30"
  vpc_id           = var.vpc_id
  subnet_ids       = var.private_subnets
  enable_irsa      = true
  cluster_security_group_id = aws_security_group.eks_sg.id
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    flask-eks = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      instance_types = ["t3.medium"]
    }
  }
}

# Network Load Balancer for Static IP
resource "aws_lb" "eks_lb" {
  name               = "eks-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnets

  ip_address_type = "ipv4"
  security_groups = [aws_security_group.lb_sg.id]
}

# Security Group for Network Load Balancer
resource "aws_security_group" "lb_sg" {
  name_prefix = "eks-lb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5056
    to_port     = 5056
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
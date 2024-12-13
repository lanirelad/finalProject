# Main "main" Terraform file to trigger infrastructure creation


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# VPC Module configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  

  tags = {
    Environment = "dev"
    Project     = "eks-setup"
  }
}


# EKS Module configuration
module "eks" {
  source           = "./eks"
  eks_cluster_name = var.eks_cluster_name
  vpc_id           = module.vpc.vpc_id
  # nat_gateway_ids  = module.vpc.natgw_ids  
  private_subnets  = module.vpc.private_subnets
  public_subnets   = module.vpc.public_subnets
}

# EC2 Module configuration
module "ec2" {
  source  = "./ec2"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  key_name = var.key_name
}
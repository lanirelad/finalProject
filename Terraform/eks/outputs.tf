output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks_cluster.cluster_arn
}

output "vpc_id" {
  description = "VPC ID for the EKS cluster"
  value       = var.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster"
  value       = var.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  value       = var.private_subnets
}

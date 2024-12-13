# EKS variables definition 

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "flask-eks"
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

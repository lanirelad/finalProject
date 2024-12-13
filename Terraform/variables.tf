variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "flask-eks"
}

variable "key_name" {
  description = "The name of the key pair for the EC2 instance"
  type        = string
  default     = "firstKey"
}
output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.example.endpoint
}

output "eks_cluster" {
  value = aws_eks_cluster.example.name
}
output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster" {
  value = aws_eks_cluster.eks.name
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}
output "oidc_url" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

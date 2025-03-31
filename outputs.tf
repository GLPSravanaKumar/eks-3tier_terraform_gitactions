output "vpc_id" {
  value = module.vpc.vpc_id
}
output "pub_subnet_ids" {
  value = module.vpc.pub_subnet_ids
}
output "pvt_subnet_ids" {
  value = module.vpc.pvt_subnet_ids
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}   
output "eks_cluster_endpoint" {
    value = module.eks.eks_cluster_endpoint  
}
output "eks_cluster" {
    value = module.eks.eks_cluster
}

region = "ap-south-1"
cluster_name    = "glps-eks-cluster"
frontend_image  = "471112932176.dkr.ecr.ap-south-1.amazonaws.com/my-frontend:latest"
backend_image   = "471112932176.dkr.ecr.ap-south-1.amazonaws.com/my-backend:latest"
database_image  = "471112932176.dkr.ecr.ap-south-1.amazonaws.com/my-database:latest"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.4.0/24", "10.0.7.0/24"]
database_subnet_cidr = ["10.0.9.0/24", "10.0.11.0/24"]
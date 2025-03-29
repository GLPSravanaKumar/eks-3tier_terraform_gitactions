terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = var.cluster_name
  cluster_version = "1.29"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
}

module "k8s_apps" {
  source = "./modules/k8s-apps"

  frontend_image = var.frontend_image
  backend_image  = var.backend_image
  database_image = var.database_image
}

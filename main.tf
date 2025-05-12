terraform {
  backend "s3" {
    bucket         = "glps-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  cluster_name = var.cluster_name
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
}

module "eks" {
  source         = "./modules/eks"
  cluster_name = var.cluster_name
  pub_subnet_ids = module.vpc.pub_subnet_ids
  pvt_subnet_ids = module.vpc.pvt_subnet_ids
}

module "k8s_apps" {
  source = "./modules/k8s-apps"
  cluster_name = var.cluster_name
  region = var.region
  frontend_image = var.frontend_image
  backend_image  = var.backend_image
  database_image = var.database_image
  oidc_url = module.eks.oidc_url
}

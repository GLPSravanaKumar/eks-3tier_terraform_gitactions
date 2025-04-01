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
}

module "eks" {
  source         = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids = ([
              module.vpc.pvt_subnet_ids,
              module.vpc.pub_subnet_ids,
              module.vpc.db_subnet_ids
                ])
}

module "k8s_apps" {
  source = "./modules/k8s-apps"

  frontend_image = var.frontend_image
  backend_image  = var.backend_image
  database_image = var.database_image
}

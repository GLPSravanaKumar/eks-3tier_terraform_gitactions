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
  region = "ap-south-1"
}

provider "kubernetes" {
  host                   = "var.eks_cluster_endpoint"
#  cluster_ca_certificate = base64decode(var.cluster_name.certifiate_authority[0].data)
}
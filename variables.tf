variable "frontend_image" {}
variable "backend_image" {}
variable "database_image" {}
variable "cluster_name" {}
variable "region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {
    description = "CIDR blocks for public subnets"
    type        = list(string)
}
variable "private_subnet_cidr" {
    description = "CIDR blocks for public subnets"
    type        = list(string)
}
variable "database_subnet_cidr" {
    description = "CIDR blocks for public subnets"
    type        = list(string)
}
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}